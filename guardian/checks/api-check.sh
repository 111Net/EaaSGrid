#!/bin/bash

if curl -s http://localhost:4000/api/v1/dashboard >/dev/null
then
 echo "API: HEALTHY"
 exit 0
else
 echo "API: FAILED"
 exit 1
fi
