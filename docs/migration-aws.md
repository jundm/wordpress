# 온프레미스 → AWS 이전 (Docker Compose)

## 목표 환경 결정
AWS 대상 선택 필요:
- Lightsail (간단)
- EC2 (직접 설치/운영)
- ECS (운영 복잡)

아래는 **Lightsail 기준**.

## 준비
1) Lightsail 인스턴스 생성 (Ubuntu 권장)
2) Static IP 생성 후 인스턴스에 연결
3) 네트워킹: 22/80/443 허용
4) Docker + Docker Compose 설치

## 데이터 백업 (온프레미스)
DB 덤프 + wp-content 백업:
```
/Volumes/c/dev/wordpress/scripts/backup.sh
```

## 데이터 전송 (온프레미스 → AWS)
예시(Lightsail):
```
scp /Volumes/c/dev/wordpress_backup/db/*.sql ubuntu@<LIGHTSAIL_IP>:/tmp/
rsync -a /Volumes/c/dev/wordpress_backup/wp-content/ ubuntu@<LIGHTSAIL_IP>:/tmp/wp-content/
```

## AWS에서 복원
1) 레포 클론 후 `.env` 설정 (태그 고정)
2) origin.crt/origin.key 배치 + `SSL_CERT_DIR` 지정
3) 컨테이너 기동:
```
docker compose up -d
```
4) DB 복원:
```
docker compose exec -T db sh -lc 'mysql -u root -p"$MYSQL_ROOT_PASSWORD" wordpress' < /tmp/<dump.sql>
```
5) wp-content 복원:
```
rsync -a /tmp/wp-content/ /path/to/repo/volumes/wp_data/wp-content/
```

## DNS 전환 (Cloudflare)
1) DNS 레코드:
   - `@` A → Lightsail Static IP (프록시 ON)
   - `www` CNAME → `@` (프록시 ON)
2) SSL/TLS: **Full (Strict)**
3) 캐시 규칙: `docs/cloudflare.md` 그대로 적용

## 점검
- `https://<도메인>/health` 200 확인
- 관리자 로그인 확인
- 캐시 HIT 확인

## 컷오버 팁
- 전환 직전 최종 백업 후 DNS 변경
- 정상 확인 후 온프레미스 종료
