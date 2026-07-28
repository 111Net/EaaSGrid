#!/bin/bash

echo "=========================================="
echo " XaaSGrid Enterprise Heading Modernizer"
echo "=========================================="

FILES=(
app/control-centre/page.jsx
app/operations/page.jsx
app/monitoring/page.jsx
app/billing/page.jsx
app/analytics/page.jsx
app/security/page.jsx
app/settings/page.jsx
app/users/page.jsx
)

for FILE in "${FILES[@]}"
do
echo "Updating $FILE"

python3 <<EOF
from pathlib import Path

f=Path("$FILE")
text=f.read_text()

# remove old blurry shadow
text=text.replace(
'textShadow:"0 2px 4px rgba(0,0,0,0.18)"',
'textShadow:"none"'
)

# larger title
text=text.replace(
'fontSize:"42px"',
'fontSize:"48px"'
)

text=text.replace(
'fontWeight:"950"',
'fontWeight:"800"'
)

# use white instead of dark blue
text=text.replace(
'color:"#061A40"',
'color:"#ffffff"'
)

# improve spacing
text=text.replace(
'marginBottom:"12px"',
'marginBottom:"10px"'
)

# subtitle
text=text.replace(
'fontSize:"18px"',
'fontSize:"21px"'
)

f.write_text(text)
EOF

done

echo
echo "Cleaning cache..."
rm -rf .next

echo
echo "Done."
echo
echo "Run:"
echo "npm run dev"
