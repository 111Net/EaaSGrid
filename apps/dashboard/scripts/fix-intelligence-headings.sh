#!/bin/bash

echo "===================================="
echo " XaaSGrid Intelligence Heading Repair"
echo "===================================="


FILES="
app/operations/page.jsx
app/analytics/page.jsx
app/users/page.jsx
app/security/page.jsx
app/settings/page.jsx
"


for FILE in $FILES
do

echo "Repairing $FILE"

if [ -f "$FILE" ]; then

cp "$FILE" "$FILE.backup"

sed -i 's/textShadow:[^,}]*/textShadow:"none"/g' "$FILE"

sed -i 's/filter:[^,}]*/filter:"none"/g' "$FILE"

sed -i 's/fontWeight:"950"/fontWeight:"800"/g' "$FILE"

sed -i 's/fontWeight:"900"/fontWeight:"800"/g' "$FILE"

fi

done


echo "===================================="
echo " Heading Repair Completed"
echo "===================================="
