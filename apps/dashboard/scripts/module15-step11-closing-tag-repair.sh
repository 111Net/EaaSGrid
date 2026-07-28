#!/bin/bash

echo "===================================="
echo " XaaSGrid Closing Tag Repair"
echo "===================================="

cd /data/eaasgrid-platform/apps/dashboard


python3 <<'PY'

from pathlib import Path

files=[
"app/control-centre/page.jsx",
"app/analytics/page.jsx",
"app/operations/page.jsx",
"app/security/page.jsx",
"app/settings/page.jsx",
"app/users/page.jsx"
]


for f in files:

    p=Path(f)

    if not p.exists():
        continue

    text=p.read_text()

    # fix heading closure
    text=text.replace(
        "Executive Platform Intelligence\n</div>",
        "Executive Platform Intelligence\n</h1>"
    )

    text=text.replace(
        "Analytics Intelligence Centre\n</div>",
        "Analytics Intelligence Centre\n</h1>"
    )

    text=text.replace(
        "Operations Intelligence Centre\n</div>",
        "Operations Intelligence Centre\n</h1>"
    )

    text=text.replace(
        "Security Operations Centre\n</div>",
        "Security Operations Centre\n</h1>"
    )

    text=text.replace(
        "Platform Settings\n</div>",
        "Platform Settings\n</h1>"
    )

    text=text.replace(
        "User Administration\n</div>",
        "User Administration\n</h1>"
    )

    p.write_text(text)

print("Closing tags repaired")

PY


echo "Cleaning cache"

rm -rf .next 2>/dev/null
rm -rf node_modules/.cache 2>/dev/null


echo "Lint test"

npm run lint
