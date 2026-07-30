#!/bin/bash

#########################################
# XaaSGrid Reporting Module
#########################################

PROJECT_DIR="/data/eaasgrid-platform"
REPORT_DIR="$PROJECT_DIR/reports"


generate_platform_report() {

    echo "[REPORTS] Generating platform report"


    mkdir -p "$REPORT_DIR"


    REPORT_FILE="$REPORT_DIR/eaasgrid-platform-report-$(date +%Y%m%d-%H%M%S).txt"


    {
        echo "========================================"
        echo " XaaSGrid Platform Integration Report"
        echo "========================================"

        echo
        echo "Generated:"
        date

        echo
        echo "Hostname:"
        hostname

        echo
        echo "Operating System:"
        uname -a

        echo
        echo "Disk Usage:"
        df -h /

        echo
        echo "Memory:"
        free -h

        echo
        echo "Running Processes:"
        ps aux | grep -E "node|python|postgres|nginx" | grep -v grep || true

        echo
        echo "Docker Containers:"
        docker ps 2>/dev/null || echo "Docker unavailable"

        echo
        echo "========================================"
        echo " End of Report"
        echo "========================================"

    } > "$REPORT_FILE"


    echo "Report generated:"
    echo "$REPORT_FILE"

}
