#!/usr/bin/env bash

HASH=$(node -e "
const bcrypt=require('bcrypt');
bcrypt.hash('Admin@123',10)
.then(console.log)
")

sudo -u postgres psql eaas_db <<SQL

UPDATE users
SET password_hash='$HASH'
WHERE email='admin@eaasgrid.com';

SQL

echo "Admin password reset complete"
