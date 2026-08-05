#!/bin/bash


generate_certification(){


REPORT="reports/framework/platform-validation.txt"


mkdir -p reports/framework


echo "XaaSGrid Platform Validation" > "$REPORT"

echo "" >> "$REPORT"

echo "Date:" >> "$REPORT"

date >> "$REPORT"


echo "" >> "$REPORT"

echo "Containers:" >> "$REPORT"

docker compose ps >> "$REPORT"



echo "Report generated:"
echo "$REPORT"


}
