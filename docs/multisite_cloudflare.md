네, 여기 다른 사이트에 동일한 캐싱 설정을 하는 방법을 정리해드립니다:

```markdown
# Cloudflare 새 도메인 Cache Rules 설정 가이드

## 1. 도메인 추가

1. Cloudflare 대시보드 접속 (https://dash.cloudflare.com)
2. 상단 **Add Site** 버튼 클릭
3. 도메인명 입력 (예: example.com)
4. **Free** 플랜 선택
5. DNS 레코드 스캔 및 확인
6. 네임서버 변경 (도메인 등록업체에서 네임서버를 Cloudflare 제공 네임서버로 변경)
7. 활성화 대기 (보통 몇 분~24시간)

## 2. Cache Rules 설정

### 도메인 선택 후 경로
Cloudflare Dashboard → 해당 도메인 선택 → **Caching** → **Cache Rules** → **Create rule**

---

## Rule #1: Cache Everything

### 기본 정보
- **Rule name**: `Cache Everything`
- **Template**: "Cache Everything" 선택

### 조건 (When)
**Custom filter expression** 선택:
```
http.host in {"example.com" "www.example.com"}
```
> 💡 `example.com`을 실제 도메인명으로 변경

### 동작 (Then)
- **Cache eligibility**: `Eligible for cache`
- **Cache level**: `Cache Everything`

### TTL 설정
- **Edge Cache TTL**: `2 hours` (7200초)
- **Browser Cache TTL**: `30 minutes` (1800초)

### 배치
- **Place at**: `First` (첫 번째)

**Deploy** 버튼 클릭

---

## Rule #2: Bypass (관리자/동적 페이지)

### 기본 정보
- **Rule name**: `Bypass`
- **Template**: "Bypass cache for everything" 선택

### 조건 (When)
**Custom filter expression** 선택 후 Expression Editor에 입력:
```
(http.request.uri.path wildcard "/wp-admin/*") or (http.request.uri.path eq "/wp-login.php") or (http.request.uri.query contains "preview=true") or (http.request.uri.path wildcard "/cart/*") or (http.request.uri.path wildcard "/checkout/*") or (http.request.uri.path wildcard "/my-account/*")
```

> ⚠️ **중요**: Expression Builder를 사용하지 말고, 직접 텍스트로 입력하세요.
> `starts_with` 키워드는 작동하지 않으며, `wildcard` 연산자를 사용해야 합니다.

### 동작 (Then)
- **Cache eligibility**: `Bypass cache` (자동 선택됨)

### 배치
- **Place at**: `Last` (Rule #1 아래)

**Deploy** 버튼 클릭

---

## 3. 설정 확인

1. **Rules** → **Overview** 이동
2. **Cache Rules** 필터 선택
3. 두 규칙이 다음 순서로 표시되는지 확인:
   - Order 1: `Cache Everything` - Active
   - Order 2: `Bypass` - Active

---

## 추가 팁

### 비용
- **Free 플랜**: 완전 무료, 도메인 개수 제한 없음
- 대역폭, CDN, DDoS 방어 모두 무료

### 반복 작업
- 여러 도메인에 동일 설정 적용 시, 각 도메인마다 위 과정 반복
- Rule #1의 `http.host` 값만 해당 도메인명으로 변경
- Rule #2는 모든 도메인에 동일하게 적용 가능

### WordPress 외 다른 CMS
- **Rule #2** 경로를 CMS에 맞게 수정:
  - **Shopify**: `/admin`, `/cart`, `/checkout`, `/account`
  - **Magento**: `/admin`, `/customer/account`, `/checkout`
  - **Laravel**: `/admin`, `/dashboard`
  - **Django**: `/admin`, `/accounts`

### 캐시 제외 경로 추가
Rule #2 expression에 `or` 조건으로 추가:
```
or (http.request.uri.path wildcard "/custom-path/*")
```

---

## 문제 해결

### Expression 에러 발생 시
- `starts_with` 사용 금지 → `wildcard` 사용
- 따옴표 확인 (큰따옴표 `"` 사용)
- 괄호 닫기 확인

### 캐시가 작동하지 않을 때
1. Cloudflare 대시보드 → **Caching** → **Configuration**
2. **Purge Everything** 클릭 (캐시 전체 삭제)
3. 브라우저 캐시 삭제 후 재확인

### DNS 전파 확인
```
# 터미널에서 확인
nslookup example.com
```
또는 https://www.whatsmydns.net 에서 확인
```

이 설정을 따라하시면 lkkkorea.com처럼 다른 도메인에도 동일한 캐싱 최적화를 적용할 수 있습니다.[1]

[1](https://dash.cloudflare.com/0bf694531de681a325d32c8aecc534a9/lkkkorea.com/caching/cache-rules/458af34f59eb41e59519d600a9394942)