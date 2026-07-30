#!/bin/bash

echo "Database Health"

pg_isready || true

