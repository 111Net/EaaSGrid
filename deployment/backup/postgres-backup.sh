
#!/bin/bash


DATE=$(date +"%Y%m%d")


mkdir -p backups/database



docker exec xaasgrid-postgres \
pg_dump -U eaas_user eaas_db \
> backups/database/xaasgrid-$DATE.sql



