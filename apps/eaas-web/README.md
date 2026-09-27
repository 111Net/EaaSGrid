# EaaSGrid EaaS Web

Public EaaSGrid Energy-as-a-Service website for `eaas.xaasgrid.com`.

## Current baseline

- Next.js 16.2.10
- Public port: 3003 behind Nginx
- HTTPS: Let's Encrypt
- Public contact: energy@xaasgrid.com
- Internal entry point: `/internal`
- Internal authentication: shared XaaSGrid `/api/auth/login` route
- National location model: 36 states + FCT represented from the first release
- Living documentation: `docs/eaas/`

## Development

```bash
npm install --workspaces=false
npm run build --workspaces=false
npm start --workspaces=false
```

## Rebuild

Follow `docs/eaas/EaaS-REBUILD-RUNBOOK-v0.1.md` and the documentation register.

## Important

Do not place passwords, API keys, private keys or customer secrets in this repository.
Human photography/assets must have an approved source and licence before production use;
the current local SVG human-centred illustrations are the initial visual baseline.
