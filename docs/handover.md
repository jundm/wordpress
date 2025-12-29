# 맥미니 코덱스 인수인계 메모 (그대로 전달)

- 레포 클론 후 루트에서 작업. AGENTS.md 준수, 스테이징/로컬 분리 없음.
- .env.example → .env 복사 후 값 채움. 이미지 태그는 패치 버전까지 핀.
- site.conf의 server_name을 lkkkorea.com/www.lkkkorea.com로 수정.
- Cloudflare Origin Cert 발급 → origin.crt/origin.key를 맥미니에 저장, .env의 SSL_CERT_DIR 경로 맞춤.
- 공유기 포트포워딩 80/443 → 맥미니 확인, 맥미니 방화벽 80/443 허용.
- 실행: docker compose up -d
- 확인: lkkkorea.com + docker compose logs -f nginx
- Cloudflare 규칙은 cloudflare.md 그대로 적용.
- 백업 경로(c, n) 확정되면 BACKUP_PATHS.txt에 기록하고 문서화.
- .env / volumes는 커밋 금지, 수정은 로컬에서만.
- 지금은이런상태임
