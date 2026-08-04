#!/bin/bash


FILE=$1
IMPORT=$2


if grep -q "$IMPORT" "$FILE"; then

echo "IMPORT EXISTS"

else

echo "IMPORT AVAILABLE"

fi

