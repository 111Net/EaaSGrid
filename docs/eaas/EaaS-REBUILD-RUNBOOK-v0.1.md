# EaaSGrid EaaS Rebuild Runbook

Version: 0.1 | Status: LIVING

## Target

Rebuild the EaaS web application and supporting services from the Git repository,
using the documented environment, database, DNS, certificates and deployment process.

## Current website build

Repository path: /opt/XaaSGrid/projects/eaasgrid-platform
Application: apps/eaas-web
Runtime port: 3003
Public hostname: eaas.xaasgrid.com
Server IP: 2.24.131.84

## Rebuild sequence

1. Obtain the approved repository and verify Git revision.
2. Install the documented Node.js version and dependencies.
3. Configure environment variables from the secure environment source.
4. Build apps/eaas-web with Next.js.
5. Run automated tests and UAT.
6. Start the application on its assigned service port.
7. Configure Nginx reverse proxy for eaas.xaasgrid.com.
8. Validate TLS certificate and HTTP-to-HTTPS redirect.
9. Validate website, forms, CRM integrations and monitoring.
10. Record evidence and update the documentation register.

## Operational rule

No secret, password or private key is stored in this runbook or Git. Secrets are supplied
through the approved secret-management/environment process.

## Continuous documentation rule

Every material implementation change updates the relevant BRD, functional specification,
test/UAT evidence, deployment notes and rebuild instructions before release acceptance.
