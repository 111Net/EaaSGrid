#!/bin/bash

set -e

echo "======================================"
echo " XaaSGrid Deployment Assets Table Fix"
echo "======================================"

FILE="/data/eaasgrid-platform/apps/dashboard/app/control-centre/page.jsx"

cp "$FILE" "$FILE.backup-table-fix-$(date +%F-%H%M%S)"


python3 <<'PY'

from pathlib import Path

file = Path("/data/eaasgrid-platform/apps/dashboard/app/control-centre/page.jsx")

text = file.read_text()


start = text.find("Deployment Assets")

if start == -1:
    print("Deployment Assets section not found")
    exit(1)


# Find next synchronisation section
end = text.find("Last synchronisation")

if end == -1:
    print("Synchronisation section not found")
    exit(1)


replacement = r'''

<h2 style={{
marginTop:"40px",
fontSize:"28px",
fontWeight:"700"
}}>
Deployment Assets
</h2>


<table
style={{
width:"100%",
marginTop:"20px",
borderCollapse:"collapse"
}}
>

<thead>

<tr>

<th style={{textAlign:"left"}}>
Site
</th>

<th style={{textAlign:"left"}}>
Type
</th>

<th style={{textAlign:"left"}}>
Manufacturer
</th>

<th style={{textAlign:"left"}}>
Status
</th>

</tr>

</thead>


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


</table>


'''

text = text[:start] + replacement + text[end:]

file.write_text(text)

print("Deployment Assets table replaced successfully")

PY


echo "[1] Restarting dashboard"


cd /data/eaasgrid-platform/apps/dashboard

pkill -f "next" || true

sleep 2

nohup npm run dev > /tmp/eaasgrid-dashboard.log 2>&1 &


echo ""
echo "======================================"
echo " FIX COMPLETE"
echo "======================================"

echo "Reload:"
echo "http://192.168.100.21:3000/control-centre"

