#!/bin/bash

echo "XaaSGrid API Health"

curl -s http://localhost:4000/api/v1/dashboard \
| head -c 200

echo
