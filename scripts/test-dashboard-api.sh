#!/bin/bash


echo "======================================"
echo " XaaSGrid Dashboard API Test"
echo "======================================"



curl -s \
http://localhost:4000/api/v1/dashboard \
| python3 -m json.tool



echo ""

echo "======================================"
echo " Complete"
echo "======================================"
