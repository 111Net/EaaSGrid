#!/bin/bash

echo "====================================="
echo " XaaSGrid JSX Heading Structural Repair"
echo "====================================="

cd /data/eaasgrid-platform/apps/dashboard


python3 <<'PY'

from pathlib import Path
import re


pages = list(Path("app").rglob("page.jsx"))


for file in pages:

    text = file.read_text()

    #
    # Convert broken page-title divs back into h1
    #
    text = re.sub(
        r'<div className="page-title"\s*\n?\s*style=\{\{.*?\}\}\s*>',
        '<h1 className="page-title">',
        text,
        flags=re.S
    )


    #
    # close matching page-title divs
    #
    text = text.replace(
        '</div>\n\n<p',
        '</h1>\n\n<p'
    )


    #
    # Fix duplicated headings
    #
    text = re.sub(
        r'<h1 className="page-title">\s*<h1',
        '<h1 className="page-title">',
        text
    )


    text = re.sub(
        r'</h1>\s*</h1>',
        '</h1>',
        text
    )


    file.write_text(text)


print("Repaired", len(pages), "pages")

PY


rm -rf .next
rm -rf node_modules/.cache


echo "Running lint..."

npm run lint


echo "====================================="
echo " Repair completed"
echo "====================================="
