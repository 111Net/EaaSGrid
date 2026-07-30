#!/bin/bash

ROOT="/data/eaasgrid-platform"
REPORT="$ROOT/reports/sprint01-baseline.md"

echo "======================================"
echo " XaaSGrid Sprint 1"
echo " Platform Baseline"
echo "======================================"


echo "# XaaSGrid Sprint 1 Baseline" > $REPORT

echo "" >> $REPORT
echo "Date: $(date)" >> $REPORT


echo "" >> $REPORT
echo "## System" >> $REPORT

echo "Ubuntu:" >> $REPORT
lsb_release -d >> $REPORT 2>/dev/null


echo "" >> $REPORT
echo "Node:" >> $REPORT
node -v >> $REPORT


echo "" >> $REPORT
echo "NPM:" >> $REPORT
npm -v >> $REPORT


echo "" >> $REPORT
echo "## Applications" >> $REPORT

if [ -d "$ROOT/apps/api" ]; then
echo "API: PRESENT" >> $REPORT
else
echo "API: MISSING" >> $REPORT
fi


if [ -d "$ROOT/apps/dashboard" ]; then
echo "Dashboard: PRESENT" >> $REPORT
else
echo "Dashboard: MISSING" >> $REPORT
fi


echo "" >> $REPORT
echo "## Database" >> $REPORT

psql -U eaas_user -d eaas_db -c "SELECT current_database(),current_user;" >> $REPORT 2>&1


echo "" >> $REPORT
echo "## Disk" >> $REPORT

df -h / >> $REPORT


mkdir -p "$ROOT/state"


cat > "$ROOT/state/platform-state.json" <<EOF
{
"platform":"XaaSGrid",
"baseline":"created",
"current_sprint":1,
"status":"stable"
}
EOF


echo ""
echo "Sprint 1 Complete"
echo "Report:"
echo "$REPORT"
