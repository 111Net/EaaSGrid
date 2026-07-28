#!/bin/bash

echo "===================================="
echo " XaaSGrid Module 15 Step 9 JSX Repair"
echo "===================================="

cd /data/eaasgrid-platform/apps/dashboard


echo "[1] Backup current pages"

mkdir -p backups/module15-step9

cp app/*/page.jsx backups/module15-step9/ 2>/dev/null


echo "[2] Detect broken div headings"

grep -R "page-title" app


echo "[3] Replace malformed page title blocks"

python3 <<'PY'

from pathlib import Path
import re

for file in Path("app").rglob("page.jsx"):

    text=file.read_text()

    # repair common broken pattern:
    text=re.sub(
        r'<div className="page-title"[^>]*>\s*([^<]+)\s*</div>',
        r'<h1 className="page-title">\1</h1>',
        text
    )

    file.write_text(text)

print("JSX repair complete")

PY


echo "[4] Clear cache"

rm -rf .next
rm -rf node_modules/.cache


echo "[5] Lint"

npm run lint


echo "===================================="
echo "Repair complete"
echo "Run npm run dev"
echo "===================================="
