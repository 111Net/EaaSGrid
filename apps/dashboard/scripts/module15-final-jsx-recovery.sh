#!/bin/bash

echo "===================================="
echo " XaaSGrid Module 15 Final JSX Recovery"
echo "===================================="


cd /data/eaasgrid-platform/apps/dashboard


echo "[1] Backup current broken pages"

mkdir -p backups/before-final-recovery

cp app/*/page.jsx backups/before-final-recovery/ 2>/dev/null


echo "[2] Repair heading closing tags"

FILES="
app/analytics/page.jsx
app/billing/page.jsx
app/control-centre/page.jsx
app/monitoring/page.jsx
app/operations/page.jsx
app/security/page.jsx
app/settings/page.jsx
app/users/page.jsx
"


for FILE in $FILES
do

if [ -f "$FILE" ]; then

echo "Repairing $FILE"


python3 - <<EOF
path="$FILE"

data=open(path).read()

data=data.replace("</div>\n\n<p>",
"</h1>\n\n<p>")


data=data.replace("</div>\n\n\n<p>",
"</h1>\n\n\n<p>")


open(path,"w").write(data)

EOF


fi

done


echo "[3] Remove duplicate h1 nesting"

python3 - <<'EOF'

import glob,re


for f in glob.glob("app/**/page.jsx",recursive=True):

    data=open(f).read()

    data=re.sub(
        r'<h1([^>]*)>\s*<h1([^>]*)>',
        r'<h1\1>',
        data
    )


    data=data.replace(
        "</h1>\n</h1>",
        "</h1>"
    )


    open(f,"w").write(data)


EOF



echo "[4] Remove cache"

rm -rf .next
rm -rf node_modules/.cache



echo "[5] ESLint check"

npm run lint


echo "[6] Production build"

npx next build


echo "===================================="
echo " Recovery completed"
echo "===================================="
