#!/usr/bin/env bash


echo "Checking API"

curl -s http://localhost:4000/api/v1/health


echo ""

echo "Checking Database"

pg_isready

