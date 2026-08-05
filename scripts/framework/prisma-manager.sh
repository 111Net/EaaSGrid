#!/bin/bash


prisma_check(){


echo "[PRISMA] Checking schema"


if [ -f apps/api/prisma/schema.prisma ]

then


cd apps/api


npx prisma validate


cd ../..


echo "Prisma OK"


else


echo "No Prisma schema found"


fi


}
