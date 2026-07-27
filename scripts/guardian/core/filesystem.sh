#!/usr/bin/env bash

#
# EaaSGrid Guardian Core Library
# filesystem.sh
#
# Purpose:
# Filesystem discovery and validation utilities
#

GUARDIAN_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$GUARDIAN_ROOT/core/logger.sh"


#
# Check if file exists
#
check_file(){

    local FILE="$1"

    if [ -f "$FILE" ]; then

        log_success "File exists: $FILE"
        return 0

    else

        log_error "File missing: $FILE"
        return 1

    fi

}


#
# Check if directory exists
#
check_directory(){

    local DIR="$1"

    if [ -d "$DIR" ]; then

        log_success "Directory exists: $DIR"
        return 0

    else

        log_error "Directory missing: $DIR"
        return 1

    fi

}


#
# Check permissions
#
check_permission(){

    local TARGET="$1"

    if [ -r "$TARGET" ]; then
        log_info "Readable: $TARGET"
    else
        log_warn "Not readable: $TARGET"
    fi


    if [ -w "$TARGET" ]; then
        log_info "Writable: $TARGET"
    else
        log_warn "Not writable: $TARGET"
    fi


    if [ -x "$TARGET" ]; then
        log_info "Executable: $TARGET"
    fi

}


#
# Get ownership
#
get_owner(){

    local TARGET="$1"

    if [ -e "$TARGET" ]; then

        stat -c "%U:%G" "$TARGET"

    else

        echo "UNKNOWN"

    fi

}


#
# Get file size
#
get_size(){

    local TARGET="$1"

    if [ -e "$TARGET" ]; then

        du -sh "$TARGET" | awk '{print $1}'

    else

        echo "0"

    fi

}


#
# Disk usage
#
get_disk_usage(){

    df -h /

}


#
# Find files
#
find_files(){

    local LOCATION="$1"
    local PATTERN="$2"

    find "$LOCATION" -type f -name "$PATTERN" 2>/dev/null

}


#
# Count files
#
count_files(){

    local LOCATION="$1"

    find "$LOCATION" -type f 2>/dev/null | wc -l

}


#
# Directory tree summary
#
directory_summary(){

    local LOCATION="$1"

    echo "Filesystem Summary"
    echo "=================="

    echo "Location:"
    echo "$LOCATION"

    echo ""

    echo "Owner:"
    get_owner "$LOCATION"

    echo ""

    echo "Size:"
    get_size "$LOCATION"

    echo ""

    echo "Files:"
    count_files "$LOCATION"

}


#
# Safety check
#
filesystem_safe(){

    local TARGET="$1"

    case "$TARGET" in

        "/"|"/etc"|"/usr"|"/bin")
            log_error "Dangerous filesystem target blocked: $TARGET"
            return 1
            ;;

        *)
            log_success "Filesystem target approved: $TARGET"
            return 0
            ;;

    esac

}
