# 멀티사이트: 새 사이트 추가 + 도메인 매핑

## 사전 확인
- 멀티사이트 설정값이 `wp-config.php`에 있어야 함  
  (`MULTISITE`, `SUBDOMAIN_INSTALL`, `DOMAIN_CURRENT_SITE` 등)
- 네트워크 관리자 접근 가능해야 함

## 새 사이트 추가 (기본)
1) 관리자 → **네트워크 관리자** → **사이트** → **새로 추가**
2) 사이트 주소(슬러그), 제목, 관리자 이메일 입력 → 생성

## 도메인 매핑 (다른 도메인 붙이기)
1) 네트워크 관리자 → **사이트** → 해당 사이트 **편집**
2) **사이트 주소(URL)** 를 원하는 도메인으로 변경  
   - 예: `blog2.example.com` 또는 `otherdomain.com`
3) 저장

## Cloudflare 설정 (도메인마다)
1) Cloudflare에 도메인 추가 → 네임서버 변경
2) DNS
   - `@` CNAME → `junbo.tplinkdns.com` (프록시 ON)
   - `www` CNAME → `@` (프록시 ON)
3) SSL/TLS: **Full (Strict)**
4) Origin Cert에 **해당 도메인 포함** → 서버에 반영

## Nginx 설정
둘 중 하나:
- 모든 도메인을 `server_name`에 나열  
- 또는 `server_name _;` 로 전체 수용

변경 후:
```
docker compose restart nginx
```

## 확인
```
curl -I https://<도메인>/
```
- `server: cloudflare` 확인
- `cf-cache-status` 확인
