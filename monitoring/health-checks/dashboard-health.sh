#!/bin/bash

echo "XaaSGrid Dashboard Health"

curl -I -s http://localhost:3000 \
| head -n 1

