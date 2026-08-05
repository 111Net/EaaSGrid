#!/bin/bash


code_safety_check(){


echo "[CODE SAFETY] Checking duplicates"


echo "Checking duplicate routes"


grep -R "app.use" apps/api/src 2>/dev/null \
| sort \
| uniq -d || true



echo "Checking duplicate Prisma models"


grep "^model " apps/api/prisma/schema.prisma 2>/dev/null \
| sort \
| uniq -d || true



echo "Code safety complete"


}
