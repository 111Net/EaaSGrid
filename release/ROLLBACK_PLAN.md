
# Rollback Plan


If release failure occurs:


1. Stop containers


docker compose down


2. Checkout previous release tag


git checkout previous-tag


3. Restore database backup


4. Restart services


