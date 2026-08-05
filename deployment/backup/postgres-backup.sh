#!/bin/bash

docker exec xaasgrid-postgres pg_dump -U eaas_user eaas_db > xaasgrid-backup-$(date +%F).sql
