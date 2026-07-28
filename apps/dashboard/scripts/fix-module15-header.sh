#!/bin/bash

echo "====================================="
echo " XaaSGrid Header Visibility Repair"
echo "====================================="


cd /data/eaasgrid-platform/apps/dashboard || exit 1


echo "[1] Backup control centre"

mkdir -p backups/module15

cp app/control-centre/page.jsx backups/module15/control-centre-page-before-header-fix.jsx


echo "[2] Remove bad nested h1"


python3 <<'PY'

from pathlib import Path
import re

p = Path("app/control-centre/page.jsx")

text = p.read_text()


# Remove injected h1 wrapper
text = re.sub(
r'<h1\s*style=\{\{.*?\}\}\s*>\s*<h1\s*style=\{\{.*?\}\}\s*>\s*Executive Platform Intelligence\s*</h1>\s*</h1>',
'''
<h1
style={{
fontSize:"42px",
fontWeight:"950",
color:"#061A40",
letterSpacing:"-0.8px",
marginBottom:"12px",
textShadow:"0 2px 4px rgba(0,0,0,0.18)"
}}
>
Executive Platform Intelligence
</h1>
''',
text,
flags=re.S
)


p.write_text(text)

PY


echo "[3] Clear cache"

rm -rf .next
rm -rf node_modules/.cache


echo "[4] Build test"

npm run lint

npx next build


echo "====================================="
echo " HEADER REPAIR COMPLETE"
echo "====================================="

