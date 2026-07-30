#!/bin/bash

if pg_isready >/dev/null 2>&1
then
 echo "Database: HEALTHY"
 exit 0
else
 echo "Database: FAILED"
 exit 1
fi
