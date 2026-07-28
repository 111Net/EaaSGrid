#!/bin/bash

echo "======================================"
echo " XaaSGrid Module 15 Step 8 UI Repair"
echo "======================================"

ROOT="/data/eaasgrid-platform/apps/dashboard"

cd $ROOT


echo "[1] Backup pages"

mkdir -p backups/module15

cp app/control-centre/page.jsx backups/module15/ 2>/dev/null
cp app/page.jsx backups/module15/ 2>/dev/null


echo "[2] Remove duplicate root page"

if [ -f app/page.tsx ]; then
    mv app/page.tsx backups/module15/page.tsx.disabled
fi


echo "[3] Repair nested h1 headings"

find app -name "page.jsx" -exec sed -i '
s/<h1>/<div className="page-title">/g;
s/<\/h1>/<\/div>/g;
' {} \;


echo "[4] Create clean typography CSS"

mkdir -p styles

cat > styles/intelligence.css <<'EOF'

.page-title {
    font-size:42px;
    font-weight:900;
    color:#061A40;
    letter-spacing:-0.8px;
    margin-bottom:20px;
}

.page-subtitle {
    font-size:20px;
    font-weight:700;
    color:#334155;
    margin-bottom:30px;
}

.intelligence-card {
    background:white;
    border-radius:18px;
    padding:25px;
    box-shadow:
    0 10px 30px rgba(0,0,0,.08);
    margin-bottom:20px;
}

.intelligence-card h2 {
    font-size:24px;
    font-weight:850;
    color:#061A40;
}

.intelligence-card p {
    font-size:16px;
    color:#475569;
}

EOF


echo "[5] Clear Next cache"

rm -rf .next
rm -rf node_modules/.cache


echo "[6] Validate"

npm run lint

echo "======================================"
echo " UI Repair Complete"
echo " Restart npm run dev"
echo "======================================"
