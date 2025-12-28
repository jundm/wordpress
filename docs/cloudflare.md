# Cloudflare rules (baseline)

## Cache Rules (order matters)
1) Bypass (no cache)
- /wp-admin/*
- /wp-login.php
- *preview=true*
- /cart/*
- /checkout/*
- /my-account/*

2) Cache Everything
- /* (after bypass rules)

## TTL defaults
- Edge Cache TTL: 2h
- Browser Cache TTL: 30m

## Purge strategy
- Manual purge: zone purge on deploy
- Auto purge: post publish -> tag-based purge
- Implementation: WP-CLI + CF API or Cloudflare cache plugin (pick one)

## SSL
- Mode: Full (Strict)
- Proxy: ON (orange cloud)
- Origin cert required (origin.crt / origin.key)
- Always Use HTTPS: ON
