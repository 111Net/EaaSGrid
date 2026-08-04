#!/bin/bash


SCHEMA=$1
MODEL=$2


if grep -q "^model $MODEL" "$SCHEMA"; then

echo "MODEL EXISTS: $MODEL"

else

echo "MODEL AVAILABLE: $MODEL"

fi

