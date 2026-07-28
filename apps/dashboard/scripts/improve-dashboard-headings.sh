#!/bin/bash

echo "=========================================="
echo " XaaSGrid Dashboard Heading Enhancement"
echo "=========================================="

cd /data/eaasgrid-platform/apps/dashboard || exit 1

find app -name "page.jsx" | while read file
do
    sed -i 's/fontWeight:"950"/fontWeight:800/g' "$file"
    sed -i 's/fontWeight:950/fontWeight:800/g' "$file"

    sed -i 's/color:"#061A40"/color:"#ffffff"/g' "$file"

    sed -i '/textShadow:/d' "$file"

    sed -i '/opacity:/d' "$file"

    sed -i '/fontWeight:800/a\
              lineHeight:"1.15",' "$file"
done

rm -rf .next
rm -rf node_modules/.cache

echo
echo "Running lint..."
npm run lint

echo
echo "Running production build..."
npx next build

echo
echo "Done."
