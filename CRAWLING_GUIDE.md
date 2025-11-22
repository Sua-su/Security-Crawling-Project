# 🚀 크롤링 → DB 저장 가이드

## ✅ 완료된 작업

### 1. **JsoupCrawler.java** 수정

- ✅ DB 저장 기능 자동 활성화
- ✅ 중복 뉴스 체크 (동일 링크 저장 방지)
- ✅ 저장 성공/실패 카운트
- ✅ 상세한 결과 표시

### 2. **dbList.jsp** - 뉴스 목록 조회 페이지

- ✅ 저장된 뉴스 목록 표시
- ✅ 통계 정보 (전체 뉴스, 오늘 뉴스, 언론사 수)
- ✅ 깔끔한 UI 디자인
- ✅ 에러 처리 및 해결 가이드

### 3. **crawler.jsp** - 크롤링 실행 페이지

- ✅ 자동으로 DB에 저장
- ✅ 실시간 저장 결과 표시
- ✅ 네비게이션 메뉴 추가

## 🎯 사용 방법

### Step 1: 데이터베이스 테이블 생성

먼저 MariaDB에서 news 테이블을 생성하세요:

```bash
# MariaDB 접속
mysql -u root -p -P 13306 -h localhost

# 데이터베이스 선택
USE BP1901153;

# 테이블 생성
CREATE TABLE news (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(500) NOT NULL,
    preview TEXT,
    company VARCHAR(100),
    link VARCHAR(1000),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_created_at (created_at),
    INDEX idx_company (company),
    UNIQUE KEY uk_link (link)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

또는 init.sql 스크립트 실행:

```bash
cd BP1901153
mysql -u root -p -P 13306 -h localhost < database/init.sql
```

### Step 2: 프로젝트 빌드

```bash
cd BP1901153
mvn clean package
```

### Step 3: Tomcat에 배포

1. `target/BP1901153-0.0.1-SNAPSHOT.war` 파일을 Tomcat의 `webapps` 폴더에 복사
2. Tomcat 시작

```bash
# Tomcat 시작 (경로는 환경에 따라 다를 수 있음)
$CATALINA_HOME/bin/startup.sh     # Linux/Mac
$CATALINA_HOME/bin/startup.bat    # Windows
```

### Step 4: 크롤링 실행

브라우저에서 다음 URL 접속:

```
http://localhost:8080/BP1901153/WEB-INF/content/crawler.jsp
```

크롤링이 실행되면서 자동으로 DB에 저장됩니다!

### Step 5: 저장된 뉴스 확인

```
http://localhost:8080/BP1901153/dbList.jsp
```

## 📊 주요 기능

### 🔍 크롤링 + DB 저장

- 네이버 MLB 뉴스 자동 크롤링
- MariaDB에 자동 저장
- 중복 체크 (같은 링크는 한 번만 저장)
- 저장 결과 실시간 표시

### 📰 뉴스 목록 조회

- 최신 뉴스 50개 표시
- 통계 정보 (전체/오늘/언론사)
- 언론사별 분류
- 기사 링크 제공

### ⚡ 성능 최적화

- HikariCP Connection Pool 사용
- PreparedStatement로 SQL Injection 방지
- 자동 리소스 관리 (try-with-resources)

## 🎨 화면 구성

### 1. 크롤링 페이지 (crawler.jsp)

```
┌─────────────────────────────────────┐
│  🔍 MLB 뉴스 크롤러                  │
├─────────────────────────────────────┤
│  [📰 저장된 뉴스 보기] [🔄 다시 크롤링]│
├─────────────────────────────────────┤
│  📰 크롤링 결과                      │
│  총 10개의 뉴스를 찾았습니다.        │
│  ✅ DB 저장 모드: ON                 │
├─────────────────────────────────────┤
│  제목: MLB 뉴스 1                    │
│  요약: ...                           │
│  회사: 스포츠조선                    │
│  링크: [기사 보기] ✅ DB 저장 완료   │
├─────────────────────────────────────┤
│  💾 저장 결과                        │
│  ✅ 성공: 8개                        │
│  ❌ 실패: 0개 (중복 2개)             │
└─────────────────────────────────────┘
```

### 2. 뉴스 목록 페이지 (dbList.jsp)

```
┌─────────────────────────────────────┐
│  📰 저장된 뉴스 목록                 │
├─────────────────────────────────────┤
│  [150]      [12]        [5]         │
│  전체 뉴스  오늘 저장   언론사 수   │
├─────────────────────────────────────┤
│  [🔄 새로 크롤링하기] [🔃 새로고침] │
├─────────────────────────────────────┤
│  뉴스 제목                           │
│  뉴스 요약...                        │
│  📰 언론사  🕒 2025-11-12 10:30:00  │
│  [기사 보기 →]                      │
└─────────────────────────────────────┘
```

## 🔧 커스터마이징

### 크롤링 대상 변경

`JsoupCrawler.java`에서 URL 수정:

```java
// 현재: MLB 뉴스
String url = "https://search.naver.com/search.naver?where=news&query=MLB";

// 변경 예시: 야구 뉴스
String url = "https://search.naver.com/search.naver?where=news&query=야구";
```

### DB 저장 끄기/켜기

```java
// DB 저장 활성화
String result = crawler.crawlNaverNews(true);

// DB 저장 비활성화 (조회만)
String result = crawler.crawlNaverNews(false);
```

### 조회 개수 변경

`dbList.jsp`에서 LIMIT 수정:

```java
// 현재: 최신 50개
List<Map<String, Object>> newsList = DatabaseUtil.executeQuery(
    "SELECT * FROM news ORDER BY created_at DESC LIMIT 50"
);

// 변경: 최신 100개
List<Map<String, Object>> newsList = DatabaseUtil.executeQuery(
    "SELECT * FROM news ORDER BY created_at DESC LIMIT 100"
);
```

## 🐛 문제 해결

### 1. DB 저장 실패

```sql
-- news 테이블 확인
USE BP1901153;
SHOW TABLES;
DESC news;

-- 테이블 재생성
DROP TABLE IF EXISTS news;
-- (위의 CREATE TABLE 문 실행)
```

### 2. 중복 저장 방지 확인

```sql
-- 링크별 중복 확인
SELECT link, COUNT(*) as cnt
FROM news
GROUP BY link
HAVING cnt > 1;
```

### 3. Connection Pool 상태 확인

```bash
cd BP1901153
mvn exec:java -Dexec.mainClass="com.crawler.DBTest"
```

## 📈 다음 단계

### 추가 기능 제안

1. **스케줄링** - 주기적으로 자동 크롤링

   - Spring Scheduler 또는 Quartz 사용

2. **검색 기능** - 저장된 뉴스 검색

   - 제목, 내용, 언론사로 검색

3. **카테고리 분류** - 뉴스 자동 분류

   - 키워드 기반 카테고리 자동 할당

4. **알림 기능** - 새 뉴스 알림

   - 이메일 또는 Slack 알림

5. **통계 대시보드** - 시각화
   - 일별 뉴스 추이 그래프
   - 언론사별 분포 차트

## 🎉 완료!

이제 크롤링한 데이터가 자동으로 MariaDB에 저장됩니다!

**접속 URL:**

- 크롤링: `http://localhost:8080/BP1901153/WEB-INF/content/crawler.jsp`
- 목록: `http://localhost:8080/BP1901153/dbList.jsp`

질문이나 추가 기능이 필요하면 언제든지 말씀해주세요! 😊
