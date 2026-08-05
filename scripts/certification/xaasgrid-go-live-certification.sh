
#!/bin/bash


echo "================================="
echo "XaaSGrid Go Live Certification"
echo "================================="


echo

echo "Docker"

docker ps


echo

echo "API"

curl -s http://localhost:4000/api/system/status


echo

echo "Health"

curl -s http://localhost:4000/api/health


echo

echo "Website"

curl -I http://localhost:3000


echo

echo "Database"


docker exec xaasgrid-postgres \
psql -U eaas_user -d eaas_db \
-c "\dt"


echo

echo "Certification Complete"


