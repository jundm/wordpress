# AGENTS.md

## Project Overview
- 워드프레스 온프레미스 도커 레포
- 프로덕션: 맥미니 고정
- 로컬/스테이징 분리 없음(단일 프로덕션 기준)
- 개발은 맥북, 배포는 맥미니(SSH+git pull 기반)
- 웹서버: Nginx
- DB: MySQL 최신 안정 버전(태그는 작업 시점에 검증 후 고정)
- SSL 필수, 도메인 연동 필수
- 리버스 프록시 필요 가능성 있음(상황에 맞춰 설계)
- Cloudflare 캐싱 고려(프록시/캐시 규칙, 헤더, 퍼지 전략 포함)
- 데이터 볼륨은 레포 내부 폴더에 두고 gitignore 처리
- compose 파일에 `name: ${COMPOSE_PROJECT_NAME:-wp-dev}` 패턴 고정

## Coding Style Rules (Universal)
### Rewriting Philosophy
- Preserve original logic exactly.
- No functional changes, only structural improvements.
- No omission, simplification, or reinterpretation of existing behavior.

### Entry Point Pattern
- Entry scripts = thin wrapper that only invoke Tasks.
- All business logic lives in core/ directory.

### Abstraction Rules
- Identify repeated patterns and extract Base classes.
- Children classes only implement differences.
- Shared logic goes into BaseTask or utilities.
- Strict hierarchical design by category or responsibility.

### Code Structure
- Small files: aim for 40~80 lines per component.
- Single-responsibility principle for all functions.
- Clear readable naming, no hidden side effects.

### Prohibited
- No custom logic added during refactor.
- Infra/운영 신규 동작 추가는 feat 브랜치에서만 진행(리뷰 전제)
- No keeping original logic in entry-level files.
- No feature trimming or loss of behavior.
- 로컬 자동 테스트는 강제하지 않음(검증은 CI/리뷰 기준).

### Git Flow
- Do not commit directly.
- Use `feat:` for new structure or abstraction.
- Use `fix:` for correcting logic to match original behavior.
- Only commit after review approval.

### Communication
- Use short, direct responses (Korean DC board tone).
- Research unknown parts; avoid guessing.
- Report issues immediately without narrative.

## Repo Conventions
- 단일 compose로 프로덕션 운영
- `COMPOSE_PROJECT_NAME`로 충돌 방지
- 민감정보는 `.env`로 분리하고 gitignore
- DB 볼륨 경로는 레포 내부 폴더로 고정
- 버전 고정 정책(WordPress/PHP/MySQL/Nginx) + 업데이트 주기 명시
- 예시 핀: WordPress 6.7.x / PHP 8.3.x / MySQL 8.4.x / Nginx 1.26.x
- 업데이트 주기: 마이너 월 1회, 메이저는 스테이징 1주 검증 후 적용
- 백업/복구 정책(DB 덤프, `wp-content`) + 보관 위치 규정
- 백업 위치는 레포 클론과 분리(예: `/backup` 스냅샷)
- 시크릿 관리(.env 항목 목록, 권한, 공유 금지 규칙)
- 헬스체크/리스타트 정책(컨테이너 상태 기준)
- 로그 정책(`nginx/access`, `nginx/error`, WP debug) + 로테이션
- 보안 헤더/방어(WAF/Rate limit/robots/REST 제한) 기본값
- Cloudflare 캐시 규칙/퍼지 플로우(로그인·관리자·장바구니 제외 등)
- compose v2: 실행 디렉토리는 레포 루트, `.env` 사용

## Cache/SSL Defaults (Cloudflare)
- Cache Bypass: `/wp-admin/*`, `/wp-login.php`, `*preview=true*`, 장바구니/체크아웃 URL
- Cache Everything: `/*` (위 예외 후순위)
- 기본 TTL 예시: Edge 2h, Browser 30m (프로덕션 기준)
- 퍼지: 수동+자동 병행(게시물 퍼블리시 시 태그 단위 퍼지)
- 퍼지 구현: WP-CLI + CF API 또는 CF 캐시 플러그인 중 택1
- SSL: Cloudflare proxy + Origin에 인증서 + Full(Strict) 기본

## Security Headers (Default Set)
- Strict-Transport-Security
- X-Frame-Options
- X-Content-Type-Options
- Referrer-Policy
- Content-Security-Policy (스켈레톤)

## Healthcheck Examples
- Nginx: `curl -f http://127.0.0.1/health`
- PHP/WordPress: `wp core is-installed`

## Repo Layout (Example)
repo/
├── docker-compose.yml
├── .env.example
├── nginx/
│   ├── nginx.conf
│   ├── conf.d/
│   └── snippets/
├── .gitignore
├── docs/
└── volumes/
    ├── db_data/
    └── wp_data/
