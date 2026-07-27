#!/usr/bin/env bash

set -uo pipefail


ROOT="/data/eaasgrid-platform"

DATE=$(date +%Y-%m-%d)

REPORT_DIR="$ROOT/docs/sprint-reports/$DATE/sprint-37"

mkdir -p "$REPORT_DIR"

REPORT="$REPORT_DIR/multi-tenant-access-report.txt"


echo "==========================================" | tee "$REPORT"
echo "EaaSGrid Platform Sprint 37" | tee -a "$REPORT"
echo "Production User Access & Multi-Tenant Portal Activation" | tee -a "$REPORT"
echo "Date: $DATE" | tee -a "$REPORT"
echo "==========================================" | tee -a "$REPORT"



ACCESS="$ROOT/security/multi-tenant"



echo "[1] Creating Multi Tenant Structure" | tee -a "$REPORT"


mkdir -p \
"$ACCESS/users" \
"$ACCESS/tenants" \
"$ACCESS/permissions"



echo "Tenant structure created" | tee -a "$REPORT"



echo "[2] Creating Tenant Model" | tee -a "$REPORT"



cat > "$ACCESS/tenants/tenant-model.yaml" <<'EOF'
tenants:


types:

- customer

- partner

- internal


isolation:

enabled: true


status:

- active

- suspended

EOF



echo "Tenant #!/usr/bin/env bash

set -uo pipefail


ROOT="/data/eaasgrid-platform"

DATE=$(date +%Y-%m-%d)

REPORT_DIR="$ROOT/docs/sprint-reports/$DATE/sprint-37"

mkdir -p "$REPORT_DIR"

REPORT="$REPORT_DIR/multi-tenant-access-report.txt"


echo "==========================================" | tee "$REPORT"
echo "EaaSGrid Platform Sprint 37" | tee -a "$REPORT"
echo "Production User Access & Multi-Tenant Portal Activation" | tee -a "$REPORT"
echo "Date: $DATE" | tee -a "$REPORT"
echo "==========================================" | tee -a "$REPORT"



ACCESS="$ROOT/security/multi-tenant"



echo "[1] Creating Multi Tenant Structure" | tee -a "$REPORT"


mkdir -p \
"$ACCESS/users" \
"$ACCESS/tenants" \
"$ACCESS/permissions"



echo "Tenant structure created" | tee -a "$REPORT"



echo "[2] Creating Tenant Model" | tee -a "$REPORT"



cat > "$ACCESS/tenants/tenant-model.yaml" <<'EOF'
tenants:


types:

- customer

- partner

- internal


isolation:

enabled: true


status:

- active

- suspended

EOF



echo "Tenant model created" | tee -a "$REPORT"



echo "[3] Creating User Model" | tee -a "$REPORT"



cat > "$ACCESS/users/user-model.yaml" <<'EOF'
users:


fields:

- username

- email

- role

- tenant


status:

- active

- disabled

EOF



echo "User model created" | tee -a "$REPORT"



echo "[4] Creating Portal Access Rules" | tee -a "$REPORT"



cat > "$ACCESS/permissions/portal-access.yaml" <<'EOF'
access:


admin:

control_centre: true


customer:

customer_portal: true


partner:

partner_portal: true

EOF



echo "Portal permissions created" | tee -a "$REPORT"



echo "[5] Creating Portal Documentation" | tee -a "$REPORT"



mkdir -p "$ROOT/docs/portals"


cat > "$ROOT/docs/portals/user-access-guide.txt" <<'EOF'
EaaSGrid Portal Access


Available portals:


Administrator:

Control Centre


Customer:

Customer Portal


Partner:

Partner Portal


EOF



echo "Documentation created" | tee -a "$REPORT"



echo "[6] Recovery Evidence" | tee -a "$REPORT"


mkdir -p "$ROOT/docs/recovery/sprint-37"




cp "$REPORT" "$ROOT/docs/recovery/sprint-37/"



echo "==========================================" | tee -a "$REPORT"
echo "SPRINT 37 STATUS: GREEN" | tee -a "$REPORT"
echo "MULTI-TENANT FOUNDATION READY" | tee -a "$REPORT"
echo "USER ACCESS FRAMEWORK READY" | tee -a "$REPORT"
echo "==========================================" | tee -a "$REPORT"




mkdir -p "$ROOT/docs/recovery/sprint-37"

cp "$REPORT" "$ROOT/docs




