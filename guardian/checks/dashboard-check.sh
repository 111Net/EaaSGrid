#!/bin/bash

if curl -s http://localhost:3000 >/dev/null
then
 echo "Dashboard: HEALTHY"
 exit 0
else
 echo "Dashboard: FAILED"
 exit 1
fi
