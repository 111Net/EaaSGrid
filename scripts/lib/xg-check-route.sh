#!/bin/bash


FILE=$1
NAME=$2


if grep -q "$NAME" "$FILE"; then

echo "ROUTE EXISTS: $NAME"

else

echo "ROUTE AVAILABLE: $NAME"

fi

