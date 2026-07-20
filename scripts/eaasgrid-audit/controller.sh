#!/usr/bin/env bash
set -uo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
AUDIT_ROOT="$ROOT_DIR/scripts/eaasgrid-audit"
REPORT_ROOT="$ROOT_DIR/docs/audits"

TIMESTAMP="$(date '+%Y-%m-%dT%H:%M:%S%z')"
DATE="$(date '+%Y-%m-%d')"
AUDIT_DIR="$REPORT_ROOT/$DATE"

mkdir -p "$AUDIT_DIR"

REPORT_MD="$AUDIT_DIR/platform-state.md"
REPORT_JSON="$AUDIT_DIR/platform-state.json"

STATUS="PASS"
PASS_COUNT=0
WARN_COUNT=0
FAIL_COUNT=0

declare -a CHECKS

record_check() {
    local category="$1"
    local check="$2"
    local status="$3"
    local details="$4"

    CHECKS+=("$category|$check|$status|$details")

    case "$status" in
        PASS)
            PASS_COUNT=$((PASS_COUNT + 1))
            ;;
        WARN)
            WARN_COUNT=$((WARN_COUNT + 1))
            STATUS="WARN"
            ;;
        FAIL)
            FAIL_COUNT=$((FAIL_COUNT + 1))
            STATUS="FAIL"
            ;;
    esac
}

check_command() {
    local command="$1"

    if command -v "$command" >/dev/null 2>&1; then
        record_check "environment" "command:$command" "PASS" "Available"
    else
        record_check "environment" "command:$command" "FAIL" "Unavailable"
    fi
}

check_file() {
    local file="$1"

    if [ -f "$ROOT_DIR/$file" ]; then
        record_check "repository" "file:$file" "PASS" "Exists"
    else
        record_check "repository" "file:$file" "FAIL" "Missing"
    fi
}

run_opening_state() {

    # ------------------------------------------------------------
    # 1. REPOSITORY
    # ------------------------------------------------------------

    if [ -d "$ROOT_DIR" ]; then
        record_check "repository" "repository_path" "PASS" "$ROOT_DIR"
    else
        record_check "repository" "repository_path" "FAIL" "Repository missing"
    fi

    for required_dir in apps packages database scripts tools docs infrastructure; do
        if [ -d "$ROOT_DIR/$required_dir" ]; then
            record_check "repository" "directory:$required_dir" "PASS" "Exists"
        else
            record_check "repository" "directory:$required_dir" "WARN" "Missing"
        fi
    done

    # ------------------------------------------------------------
    # 2. SYSTEM IDENTITY
    # ------------------------------------------------------------

    record_check "system" "user" "PASS" "$(whoami)"
    record_check "system" "hostname" "PASS" "$(hostname)"
    record_check "system" "working_directory" "PASS" "$(pwd)"
    record_check "system" "operating_system" "PASS" "$(uname -srm)"

    # ------------------------------------------------------------
    # 3. GIT BASELINE
    # ------------------------------------------------------------

    if [ -d "$ROOT_DIR/.git" ]; then
        record_check "git" "repository" "PASS" "Git repository detected"

        branch="$(git -C "$ROOT_DIR" branch --show-current 2>/dev/null || true)"
        commit="$(git -C "$ROOT_DIR" rev-parse --short HEAD 2>/dev/null || true)"
        status_count="$(git -C "$ROOT_DIR" status --short 2>/dev/null | wc -l | tr -d ' ')"

        record_check "git" "branch" "PASS" "${branch:-detached-or-unknown}"
        record_check "git" "commit" "PASS" "${commit:-unknown}"

        if [ "$status_count" -eq 0 ]; then
            record_check "git" "working_tree" "PASS" "Clean"
        else
            record_check "git" "working_tree" "WARN" "$status_count changed/untracked entries"
        fi
    else
        record_check "git" "repository" "WARN" "Git metadata not found"
    fi

    # ------------------------------------------------------------
    # 4. PROJECT IDENTITY
    # ------------------------------------------------------------

    check_file "package.json"
    check_file "version.json"
    check_file "README.md"

    package_name="$(node -e '
        try {
            const p=require("./package.json");
            console.log(p.name || "unknown");
        } catch(e) {
            console.log("unavailable");
        }
    ' 2>/dev/null || echo "unavailable")"

    package_version="$(node -e '
        try {
            const p=require("./package.json");
            console.log(p.version || "unknown");
        } catch(e) {
            console.log("unavailable");
        }
    ' 2>/dev/null || echo "unavailable")"

    version_product="$(node -e '
        try {
            const p=require("./version.json");
            console.log(p.product || "unknown");
        } catch(e) {
            console.log("unavailable");
        }
    ' 2>/dev/null || echo "unavailable")"

    version_number="$(node -e '
        try {
            const p=require("./version.json");
            console.log(p.version || "unknown");
        } catch(e) {
            console.log("unavailable");
        }
    ' 2>/dev/null || echo "unavailable")"

    record_check "project" "package_name" "PASS" "$package_name"
    record_check "project" "package_version" "PASS" "$package_version"
    record_check "project" "version_product" "PASS" "$version_product"
    record_check "project" "version_json_version" "PASS" "$version_number"

    if [ "$package_version" = "$version_number" ]; then
        record_check "project" "version_consistency" "PASS" "Versions match"
    else
        record_check "project" "version_consistency" "WARN" \
            "package.json=$package_version; version.json=$version_number"
    fi

    # ------------------------------------------------------------
    # 5. REQUIRED COMMANDS
    # ------------------------------------------------------------

    for command in git node npm psql pg_isready sha256sum; do
        check_command "$command"
    done

    # ------------------------------------------------------------
    # 6. RUNNING SERVICE STATE
    # ------------------------------------------------------------

    if pg_isready >/dev/null 2>&1; then
        record_check "services" "postgresql" "PASS" "Accepting connections"
    else
        record_check "services" "postgresql" "FAIL" "Unavailable"
    fi

    for port in 3000 3001 3002 4000; do
        if command -v ss >/dev/null 2>&1 && \
           ss -ltn 2>/dev/null | grep -q ":$port "; then
            record_check "services" "tcp_port:$port" "PASS" "Listening"
        else
            record_check "services" "tcp_port:$port" "WARN" "Not listening"
        fi
    done

    # ------------------------------------------------------------
    # 7. DATABASE CONNECTION STATE
    # ------------------------------------------------------------

    if command -v psql >/dev/null 2>&1; then

        # Load the repository database configuration without printing secrets.
        if [ -f "$ROOT_DIR/.env" ]; then
            set -a
            # shellcheck disable=SC1091
            . "$ROOT_DIR/.env"
            set +a
        fi

        DB_HOST="${PGHOST:-127.0.0.1}"
        DB_PORT="${PGPORT:-5432}"
        DB_NAME="${PGDATABASE:-eaas_db}"
        DB_USER="${PGUSER:-eaas_user}"

        export PGHOST="$DB_HOST"
        export PGPORT="$DB_PORT"
        export PGDATABASE="$DB_NAME"
        export PGUSER="$DB_USER"

        if psql -Atqc "SELECT 1;" >/dev/null 2>&1; then
            record_check "database" "local_connection" "PASS" "Application database connection successful"

            db_name="$(psql -Atqc 'SELECT current_database();' 2>/dev/null || echo unknown)"
            db_user="$(psql -Atqc 'SELECT current_user;' 2>/dev/null || echo unknown)"
            db_schema="$(psql -Atqc 'SELECT current_schema();' 2>/dev/null || echo unknown)"

            record_check "database" "database_host" "PASS" "$DB_HOST"
            record_check "database" "database_port" "PASS" "$DB_PORT"
            record_check "database" "database_name" "PASS" "$db_name"
            record_check "database" "database_user" "PASS" "$db_user"
            record_check "database" "schema" "PASS" "$db_schema"
        else
            record_check "database" "local_connection" "WARN" \
                "Application database connection unavailable"
        fi
    fi
}

write_markdown() {

    {
        echo "# EaaSGrid Platform Audit"
        echo
        echo "## Opening State"
        echo
        echo "- **Audit Date:** $DATE"
        echo "- **Timestamp:** $TIMESTAMP"
        echo "- **Repository:** $ROOT_DIR"
        echo "- **Overall Status:** $STATUS"
        echo
        echo "## Summary"
        echo
        echo "| Status | Count |"
        echo "|---|---:|"
        echo "| PASS | $PASS_COUNT |"
        echo "| WARN | $WARN_COUNT |"
        echo "| FAIL | $FAIL_COUNT |"
        echo
        echo "## Checks"
        echo
        echo "| Category | Check | Status | Details |"
        echo "|---|---|---|---|"

        for item in "${CHECKS[@]}"; do
            IFS='|' read -r category check status details <<< "$item"
            details="${details//|/\\|}"
            echo "| $category | $check | $status | $details |"
        done

        echo
        echo "## Audit Principle"
        echo
        echo "This report was generated by the unified EaaSGrid Audit Framework."
        echo
        echo "One automated audit framework."
        echo
        echo "Multiple controlled audit functions."
        echo
        echo "One report structure."
        echo
        echo "One source of truth for the state of the EaaSGrid software."
    } > "$REPORT_MD"
}

write_json() {

    {
        echo "{"
        echo "  \"audit\": \"EaaSGrid Platform Opening State\","
        echo "  \"timestamp\": \"$TIMESTAMP\","
        echo "  \"repository\": \"$ROOT_DIR\","
        echo "  \"status\": \"$STATUS\","
        echo "  \"summary\": {"
        echo "    \"pass\": $PASS_COUNT,"
        echo "    \"warn\": $WARN_COUNT,"
        echo "    \"fail\": $FAIL_COUNT"
        echo "  },"
        echo "  \"checks\": ["

        first=true

        for item in "${CHECKS[@]}"; do
            IFS='|' read -r category check status details <<< "$item"

            category_json="$(printf '%s' "$category" | sed 's/\\/\\\\/g; s/"/\\"/g')"
            check_json="$(printf '%s' "$check" | sed 's/\\/\\\\/g; s/"/\\"/g')"
            status_json="$(printf '%s' "$status" | sed 's/\\/\\\\/g; s/"/\\"/g')"
            details_json="$(printf '%s' "$details" | sed 's/\\/\\\\/g; s/"/\\"/g')"

            if [ "$first" = false ]; then
                echo ","
            fi

            printf '    {"category":"%s","check":"%s","status":"%s","details":"%s"}' \
                "$category_json" "$check_json" "$status_json" "$details_json"

            first=false
        done

        echo
        echo "  ]"
        echo "}"
    } > "$REPORT_JSON"
}

main() {

    case "${1:-opening-state}" in
        opening-state)
            run_opening_state
            ;;
        *)
            echo "Usage: $0 opening-state"
            exit 2
            ;;
    esac

    write_markdown
    write_json

    echo
    echo "=============================================="
    echo "EAASGRID UNIFIED AUDIT FRAMEWORK"
    echo "=============================================="
    echo "Audit: OPENING STATE"
    echo "Repository: $ROOT_DIR"
    echo
    echo "PASS: $PASS_COUNT"
    echo "WARN: $WARN_COUNT"
    echo "FAIL: $FAIL_COUNT"
    echo
    echo "OVERALL STATUS: $STATUS"
    echo
    echo "Markdown Report:"
    echo "$REPORT_MD"
    echo
    echo "JSON Report:"
    echo "$REPORT_JSON"
    echo "=============================================="

    if [ "$STATUS" = "FAIL" ]; then
        exit 1
    fi
}

main "$@"
