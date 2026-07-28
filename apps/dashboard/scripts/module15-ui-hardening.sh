#!/bin/bash

echo "======================================"
echo " XaaSGrid Module 15 UI Hardening"
echo "======================================"

BASE="/data/eaasgrid-platform/apps/dashboard"

cd $BASE || exit 1


echo "[1] Backup current files"

mkdir -p backups/module15

cp app/control-centre/page.jsx backups/module15/ 2>/dev/null
cp components/intelligence/IntelligenceCard.jsx backups/module15/ 2>/dev/null
cp app/page.jsx backups/module15/ 2>/dev/null


echo "[2] Remove duplicate homepage"

if [ -f app/page.tsx ]; then
    rm app/page.tsx
    echo "Removed duplicate app/page.tsx"
fi


echo "[3] Replace Intelligence Card design"


mkdir -p components/intelligence


cat > components/intelligence/IntelligenceCard.jsx <<'EOF'
"use client";

export default function IntelligenceCard({
 title,
 children,
 icon
}) {

return (

<section
style={{
background:"linear-gradient(135deg,#ffffff,#eef5ff)",
borderRadius:"20px",
padding:"28px",
marginBottom:"25px",
boxShadow:"0 12px 35px rgba(0,0,0,0.12)",
border:"1px solid rgba(20,80,220,0.18)"
}}
>

<h2
style={{
display:"flex",
alignItems:"center",
gap:"12px",
fontSize:"25px",
fontWeight:"900",
color:"#071A3D",
letterSpacing:"0.2px",
marginBottom:"20px",
textShadow:"0 1px 2px rgba(0,0,0,.15)"
}}
>

{icon}

{title}

</h2>


<div
style={{
fontSize:"16px",
fontWeight:"600",
color:"#243b63",
lineHeight:"1.8"
}}
>

{children}

</div>


</section>

);

}
EOF


echo "[4] Upgrade Control Centre header"


python3 <<'EOF'

from pathlib import Path

p=Path("app/control-centre/page.jsx")

if p.exists():

    text=p.read_text()

    text=text.replace(
    "Executive Platform Intelligence",
    """
<h1
style={{
fontSize:"42px",
fontWeight:"950",
color:"#061A40",
letterSpacing:"-0.8px",
marginBottom:"12px"
}}
>
Executive Platform Intelligence
</h1>
"""
    )

    p.write_text(text)

EOF


echo "[5] Clear Next cache"

rm -rf .next
rm -rf node_modules/.cache


echo "[6] Validate"

npm run lint


echo "[7] Build"

npx next build


echo "======================================"
echo " Module 15 UI Hardening Completed"
echo "======================================"
