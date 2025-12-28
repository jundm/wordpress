# Deploy (MacBook -> Mac mini)

## One-time setup on Mac mini
1) Clone repo
2) Create `.env` and fill prod values
3) Put origin certs under the path set in `.env` (`SSL_CERT_DIR`)
4) `docker compose up -d`

## One-time setup on MacBook
1) Copy `.env.deploy.example` to `.env.deploy` and fill values
2) Ensure SSH access to Mac mini works (key-based recommended)

## Deploy
- Run: `scripts/deploy-prod.sh`

## Notes
- Deploy uses `git pull` + `docker compose pull` + `docker compose up -d`
- MacBook is for code 작업만 (로컬 런 필요하면 별도 compose 추가)
