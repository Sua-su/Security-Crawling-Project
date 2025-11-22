# ✅ 크롤링 → DB 저장 완료!

## 🎉 구현 완료

크롤링한 MLB 뉴스 데이터가 **자동으로 MariaDB에 저장**되도록 모든 설정이 완료되었습니다!

---

## 📝 변경 사항

### 1. **JsoupCrawler.java** 🔧

```java
✅ DB 저장 기능 자동 활성화
✅ 중복 뉴스 체크 (동일 링크 방지)
✅ 저장 성공/실패 카운트
✅ 실시간 저장 상태 표시
```

**주요 기능:**

- `crawlNaverNews()` - 기본적으로 DB에 저장
- `crawlNaverNews(boolean saveToDb)` - 저장 여부 선택 가능
- 중복 링크 체크로 같은 뉴스 재저장 방지

### 2. **dbList.jsp** 📰

```
✅ 저장된 뉴스 목록 조회
✅ 통계 정보 (전체/오늘/언론사)
✅ 깔끔한 UI 디자인
✅ 에러 처리 가이드
```

### 3. **crawler.jsp** 🔍

```
✅ 크롤링 + DB 저장 자동 실행
✅ 저장 결과 실시간 표시
✅ 네비게이션 메뉴
```

### 4. **index.jsp** 🏠

```
✅ 메인 대시보드
✅ DB 연결 상태 확인
✅ 통계 요약
```

---

## 🚀 사용 방법

### Step 1: 테이블 생성

```bash
cd BP1901153
mysql -u root -p -P 13306 -h localhost < database/init.sql
```

또는 직접 실행:

```sql
USE BP1901153;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### Step 2: 빌드 & 배포

```bash
# 빌드
cd BP1901153
mvn clean package

# Tomcat에 배포
cp target/BP1901153-0.0.1-SNAPSHOT.war $CATALINA_HOME/webapps/

# Tomcat 시작
$CATALINA_HOME/bin/startup.sh
```

### Step 3: 접속 URL

```
메인 페이지:    http://localhost:8080/BP1901153/
뉴스 크롤링:    http://localhost:8080/BP1901153/WEB-INF/content/crawler.jsp
저장된 목록:    http://localhost:8080/BP1901153/dbList.jsp
```

---

## 🎯 동작 흐름

```
1. 사용자가 crawler.jsp 접속
   ↓
2. JsoupCrawler가 네이버 MLB 뉴스 크롤링
   ↓
3. 각 뉴스마다 중복 체크 (링크 기준)
   ↓
4. 중복이 아니면 → MariaDB에 저장 ✅
   중복이면 → 저장하지 않음 ⚠️
   ↓
5. 저장 결과를 화면에 표시
   - ✅ 성공: X개
   - ⚠️ 중복: Y개
   ↓
6. dbList.jsp에서 저장된 뉴스 확인 가능
```

---

## 📊 화면 구성

### 1. 메인 페이지 (index.jsp)

```
┌───────────────────────────────────┐
│  🔍 Security Crawling             │
│  MLB 뉴스 크롤링 & 보안 분석 시스템│
├───────────────────────────────────┤
│  [🔍 뉴스 크롤링] [📰 뉴스 목록]  │
├───────────────────────────────────┤
│  📊 시스템 상태                    │
│  [150] 전체 뉴스                   │
│  [12] 오늘 저장                    │
│  ✅ DB 연결 성공 (포트: 13306)    │
└───────────────────────────────────┘
```

### 2. 크롤링 페이지 (crawler.jsp)

```
┌───────────────────────────────────┐
│  📰 크롤링 결과                    │
│  총 10개의 뉴스를 찾았습니다.      │
│  ✅ DB 저장 모드: ON               │
├───────────────────────────────────┤
│  제목: 오타니, 월드시리즈 우승!    │
│  요약: 다저스가 월드시리즈에서...  │
│  회사: 스포츠조선                  │
│  [기사 보기] ✅ DB 저장 완료       │
├───────────────────────────────────┤
│  💾 저장 결과                      │
│  ✅ 성공: 8개                      │
│  ⚠️ 중복: 2개                      │
└───────────────────────────────────┘
```

### 3. 뉴스 목록 (dbList.jsp)

```
┌───────────────────────────────────┐
│  📰 저장된 뉴스 목록               │
├───────────────────────────────────┤
│  [150]       [12]        [5]      │
│  전체 뉴스   오늘 저장   언론사   │
├───────────────────────────────────┤
│  오타니, 월드시리즈 우승!          │
│  다저스가 월드시리즈에서...        │
│  📰 스포츠조선 🕒 2025-11-12 10:30│
│  [기사 보기 →]                    │
└───────────────────────────────────┘
```

---

## 🔧 주요 기능

### ✨ 자동 저장

- 크롤링과 동시에 DB 저장
- 별도 작업 불필요

### 🛡️ 중복 방지

- 링크 기준으로 중복 체크
- UNIQUE KEY로 DB 레벨 중복 방지

### 📈 실시간 피드백

- 저장 성공/실패 개수 표시
- 각 뉴스별 저장 상태 표시

### 🎨 깔끔한 UI

- 그라데이션 디자인
- 반응형 레이아웃
- 통계 대시보드

---

## 🐛 문제 해결

### Q1: "Table 'news' doesn't exist" 오류

```bash
# init.sql 실행
mysql -u root -p -P 13306 -h localhost < database/init.sql
```

### Q2: 중복 뉴스가 계속 저장됨

```sql
-- UNIQUE KEY 확인
SHOW CREATE TABLE news;

-- 있어야 할 제약조건
UNIQUE KEY uk_link (link)
```

### Q3: DB 연결 실패

```bash
# MariaDB 상태 확인
sudo systemctl status mariadb  # Linux
brew services list             # Mac

# 포트 확인
lsof -i :13306
```

---

## 📁 파일 구조

```
BP1901153/
├── src/main/
│   ├── java/
│   │   ├── db/
│   │   │   └── DBConnect.java          # Connection Pool
│   │   └── com/crawler/
│   │       ├── JsoupCrawler.java       🔧 수정 (DB 저장 기능)
│   │       └── DatabaseUtil.java       # DB 유틸리티
│   └── webapp/
│       ├── index.jsp                   🆕 메인 페이지
│       ├── dbList.jsp                  🔧 수정 (뉴스 목록)
│       └── WEB-INF/content/
│           └── crawler.jsp             🔧 수정 (크롤링)
└── database/
    └── init.sql                        # DB 초기화
```

---

## 🎓 핵심 코드

### 중복 체크 + 저장

```java
// 중복 체크
String checkSql = "SELECT COUNT(*) FROM news WHERE link = ?";
Object count = DatabaseUtil.executeScalar(checkSql, link);

if (count != null && ((Number) count).intValue() > 0) {
    return false;  // 중복
}

// 저장
String sql = "INSERT INTO news (title, preview, company, link) VALUES (?, ?, ?, ?)";
int rows = DatabaseUtil.executeUpdate(sql, title, preview, company, link);
return rows > 0;
```

---

## 📚 추가 문서

- 📖 **CRAWLING_GUIDE.md** - 상세 사용 가이드
- 📖 **CHANGES.md** - 전체 변경 사항
- 📖 **README.md** - 프로젝트 개요

---

## ✅ 체크리스트

- [x] DB 저장 기능 구현
- [x] 중복 체크 로직 추가
- [x] UI 개선 (크롤링/목록/메인)
- [x] 통계 기능 추가
- [x] 에러 처리 강화
- [x] 사용 가이드 작성

---

## 🎉 완료!

이제 **크롤링한 뉴스가 자동으로 MariaDB에 저장**됩니다!

**바로 시작하기:**

```bash
# 1. 테이블 생성
mysql -u root -p -P 13306 < database/init.sql

# 2. 빌드
mvn clean package

# 3. 접속
http://localhost:8080/BP1901153/
```

질문이나 추가 기능이 필요하면 언제든지 말씀해주세요! 😊
