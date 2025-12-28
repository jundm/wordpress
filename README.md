# WordPress on-prem (Docker)

## Quick start (prod)
1) Copy `.env.example` to `.env` and fill values (pin exact tags)
2) Set your domain in `nginx/conf.d/site.conf`
3) Put `origin.crt` and `origin.key` under `SSL_CERT_DIR`
4) `docker compose up -d`

## Notes
- Data lives in `./volumes` (gitignored)
- Cloudflare rules: `docs/cloudflare.md`
- Deploy flow (MacBook -> Mac mini): `docs/deploy.md`
