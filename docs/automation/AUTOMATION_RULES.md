# XaaSGrid Automation Rules

## Repository Detection

Project root:

/data/eaasgrid-platform


API:

apps/api


Prisma:

apps/api/prisma/schema.prisma


## Route Rules

Before adding Express routes:

1. Detect existing import
2. Detect existing app.use()
3. Insert before 404 handler


## Prisma Rules

Before adding models:

1. Check model name
2. Prevent duplicates
3. Validate schema


## File Safety

Before modifying files:

1. Create backup
2. Preserve existing production files


