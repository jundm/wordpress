# 자동 실행 (launchd)

## 전제
- Docker Desktop 자동 실행 ON
- 유저 로그인 시 자동으로 `docker compose up -d` 실행

## 설치
```
scripts/launchd-install.sh install
```

## 확인
```
scripts/launchd-install.sh status
```

## 설치되는 항목/경로 (기본값)
- launchd plist: `~/Library/LaunchAgents/com.lkkkorea.wp-compose.plist`
- 실행 스크립트: `<repo>/core/auto-start.sh`
- 로그(표준출력): `/tmp/wp-compose.out`
- 로그(표준에러): `/tmp/wp-compose.err`
- launchd 라벨: `com.lkkkorea.wp-compose`
- PATH: `/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin`

## 수동 확인 (체크리스트)
```
ls -l "$HOME/Library/LaunchAgents/com.lkkkorea.wp-compose.plist"
cat "$HOME/Library/LaunchAgents/com.lkkkorea.wp-compose.plist"
launchctl list | grep -F "com.lkkkorea.wp-compose"
ls -l /tmp/wp-compose.out /tmp/wp-compose.err
```

## 제거
```
scripts/launchd-install.sh uninstall
```

## 환경 변수 (선택)
- `WAIT_SECONDS` / `SLEEP_SECONDS`: Docker 준비 대기
- `LABEL`: launchd 라벨 변경
- `AGENT_DIR`: LaunchAgents 디렉토리 변경
- `PLIST_PATH`: plist 파일 경로 직접 지정
- `AUTO_START_SCRIPT`: 실행 스크립트 경로 변경
- `PATH_VALUE`: launchd PATH 값 변경
- `STDOUT_PATH` / `STDERR_PATH`: 로그 경로 변경
