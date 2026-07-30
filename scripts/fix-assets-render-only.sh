#!/bin/bash

set -e

FILE="/data/eaasgrid-platform/apps/dashboard/app/control-centre/page.jsx"

echo "======================================"
echo " XaaSGrid Assets Render Fix"
echo "======================================"


cp "$FILE" "$FILE.backup-render-$(date +%F-%H%M%S)"


python3 <<'PY'

from pathlib import Path

p=Path("/data/eaasgrid-platform/apps/dashboard/app/control-centre/page.jsx")

x=p.read_text()


old="""
<tbody>

</tbody>
"""


new="""
<tbody>

{
(data.sites || []).map((site)=>(
<tr key={site.id}>

<td>
{site.site_code}
</td>

<td>
{site.device_type}
</td>

<td>
{site.manufacturer}
</td>

<td>
{site.status}
</td>

</tr>
))
}

</tbody>
"""


if old not in x:
    print("Target tbody not found")
    exit(1)


x=x.replace(old,new)

p.write_text(x)

print("Assets renderer inserted")

PY


cd /data/eaasgrid-platform/apps/dashboard

npm run build


pkill -f "next" || true

sleep 2

nohup npm run dev > /tmp/eaasgrid-dashboard.log 2>&1 &


echo ""
echo "======================================"
echo " COMPLETE"
echo " Reload browser:"
echo " CTRL + F5"
echo "======================================"
