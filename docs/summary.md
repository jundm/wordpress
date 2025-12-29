# 작업 요약 (간략)

## 인프라/운영
- 도메인: lkkkorea.com 공개 연결 완료
- Cloudflare: Full (Strict), 캐시 규칙 적용 및 HIT 확인
- 공유기: 80/443 포트포워딩, 원격관리 충돌 이슈 대응

## Nginx/WordPress
- nginx에서 `/wp-admin/*.php` fastcgi 처리 추가 (install.php 다운로드 문제 해결)
- `server_name`에 `lkkkorea.com`/`www.lkkkorea.com` 반영
- `wp-config.php`에 `WP_HOME`/`WP_SITEURL` 반영
- 멀티사이트 전환 준비: `WP_ALLOW_MULTISITE` 추가

## 백업
- 백업 경로 정리: `/Volumes/c/dev/wordpress_backup`
  - DB: `.../db`
  - wp-content: `.../wp-content`
- 주 1회 / 8주 보관 정책 기록
- 백업 스크립트 추가: `core/backup.sh`, `scripts/backup.sh`

## 자동 실행
- launchd 스크립트 추가: `core/auto-start.sh`, `core/launchd-install.sh`
- 사용 가이드: `docs/auto-start.md`

## 문서
- 인수인계 메모: `docs/handover.md`
- 멀티사이트 가이드: `docs/multisite.md`
- AWS(Lightsail) 이전 가이드: `docs/migration-aws.md`

## 남은 일
- 멀티사이트 네트워크 설정 화면에서 나온 설정값 반영
- 도메인 추가 운영 시 Origin Cert 재발급 및 DNS 매핑
- 커밋(리뷰 승인 후)
