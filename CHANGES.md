# 🔧 MariaDB 포트 13306 설정 완료

## ✅ 수정된 파일들

### 1. **핵심 설정 파일**

#### `db/DBConnect.java` ⭐

- **HikariCP Connection Pool** 도입
- 포트 13306으로 MariaDB 연결
- 성능 최적화 설정 (최대 연결 10개, 최소 유휴 2개)
- Connection Pool 상태 모니터링 기능

#### `com/crawler/DatabaseUtil.java` ⭐

- **새로 구현된** DB 유틸리티 클래스
- 주요 기능:
  - `executeQuery()` - SELECT 쿼리 실행
  - `executeUpdate()` - INSERT/UPDATE/DELETE
  - `executeInsertWithKey()` - INSERT 후 auto_increment 키 반환
  - `executeScalar()` - 단일 값 조회 (COUNT, SUM 등)
  - `executeTransaction()` - 트랜잭션 처리
  - `tableExists()` - 테이블 존재 확인

#### `com/crawler/JsoupCrawler.java`

- DBConnect 사용으로 변경
- Connection Pool 활용
- try-with-resources로 자동 연결 해제

### 2. **의존성 업데이트**

#### `pom.xml`

```xml
✅ MariaDB JDBC Driver: 3.1.4 → 3.3.3
✅ HikariCP 추가: 5.1.0
✅ JSTL 추가: 1.2
```

### 3. **새로 생성된 파일**

#### `com/crawler/DBTest.java` 🆕

- 종합 DB 연결 테스트 클래스
- 테스트 항목:
  1. 기본 연결 테스트
  2. Connection Pool 상태 확인
  3. 테이블 자동 생성
  4. CRUD 작업 테스트
  5. DatabaseUtil 고급 기능 테스트

#### `resources/db.properties` 🆕

- DB 연결 설정 외부화
- Connection Pool 파라미터 관리

#### `database/init.sql` 🆕

- 데이터베이스 초기화 스크립트
- 3개 테이블 생성:
  - `news` - 크롤링한 뉴스
  - `security_keywords` - 보안 키워드
  - `crawl_log` - 크롤링 이력
- 샘플 데이터 포함

#### `test-connection.sh` / `test-connection.ps1` 🆕

- 자동화된 연결 테스트 스크립트
- Mac/Linux, Windows 각각 지원

## 🚀 빠른 테스트 방법

### 1️⃣ DB 연결 테스트 (추천)

```bash
cd BP1901153
mvn exec:java -Dexec.mainClass="com.crawler.DBTest"
```

### 2️⃣ 쉘 스크립트로 테스트

```bash
cd BP1901153
./test-connection.sh
```

### 3️⃣ 데이터베이스 초기화

```bash
mysql -u root -p -P 13306 -h localhost < database/init.sql
```

## 📊 Connection Pool 설정

| 설정              | 값   | 설명                |
| ----------------- | ---- | ------------------- |
| maximumPoolSize   | 10   | 최대 연결 수        |
| minimumIdle       | 2    | 최소 유휴 연결      |
| connectionTimeout | 30초 | 연결 대기 시간      |
| idleTimeout       | 10분 | 유휴 연결 유지 시간 |
| maxLifetime       | 30분 | 연결 최대 수명      |

## 💡 사용 예제

### 기본 연결

```java
try (Connection conn = DBConnect.getConnection()) {
    // DB 작업
}
```

### DatabaseUtil 사용

```java
// SELECT
List<Map<String, Object>> news =
    DatabaseUtil.executeQuery("SELECT * FROM news WHERE company = ?", "보안뉴스");

// INSERT
DatabaseUtil.executeUpdate(
    "INSERT INTO news (title, preview, company, link) VALUES (?, ?, ?, ?)",
    "제목", "요약", "언론사", "링크"
);

// COUNT
Long count = (Long) DatabaseUtil.executeScalar("SELECT COUNT(*) FROM news");
```

### 트랜잭션

```java
boolean success = DatabaseUtil.executeTransaction(conn -> {
    String sql = "INSERT INTO news (title, preview, company, link) VALUES (?, ?, ?, ?)";
    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
        // 여러 INSERT 작업...
    }
});
```

## 📝 주요 개선 사항

### ✨ 성능

- ✅ HikariCP로 Connection Pool 도입
- ✅ PreparedStatement 캐싱
- ✅ 자동 재연결

### 🔒 안정성

- ✅ try-with-resources로 자동 리소스 해제
- ✅ 트랜잭션 지원
- ✅ 에러 핸들링 강화

### 🛠️ 개발 편의성

- ✅ DatabaseUtil로 CRUD 간소화
- ✅ Connection Pool 모니터링
- ✅ 자동화된 테스트 스크립트

## 🔍 트러블슈팅

### Connection 실패 시

1. MariaDB 서비스 확인

   ```bash
   sudo systemctl status mariadb
   # 또는
   brew services list | grep mariadb
   ```

2. 포트 확인

   ```bash
   lsof -i :13306
   netstat -an | grep 13306
   ```

3. DB 사용자 권한
   ```sql
   GRANT ALL PRIVILEGES ON BP1901153.* TO 'root'@'localhost';
   FLUSH PRIVILEGES;
   ```

### Maven 빌드 실패 시

```bash
mvn clean install -U
```

## 📂 파일 구조

```
BP1901153/
├── src/main/
│   ├── java/
│   │   ├── db/
│   │   │   └── DBConnect.java          ⭐ Connection Pool
│   │   └── com/crawler/
│   │       ├── JsoupCrawler.java       🔄 수정됨
│   │       ├── DatabaseUtil.java       🆕 새로 생성
│   │       └── DBTest.java             🆕 테스트 클래스
│   └── resources/
│       └── db.properties               🆕 설정 파일
├── database/
│   └── init.sql                        🆕 초기화 스크립트
├── test-connection.sh                  🆕 테스트 스크립트 (Mac/Linux)
├── test-connection.ps1                 🆕 테스트 스크립트 (Windows)
└── pom.xml                             🔄 의존성 추가
```

## 🎯 다음 단계

1. **DB 테스트 실행**

   ```bash
   mvn exec:java -Dexec.mainClass="com.crawler.DBTest"
   ```

2. **Maven 빌드**

   ```bash
   mvn clean package
   ```

3. **Tomcat 배포**
   - `target/BP1901153-0.0.1-SNAPSHOT.war` → Tomcat webapps
   - 브라우저에서 `http://localhost:8080/BP1901153` 접속

## ✅ 체크리스트

- [x] MariaDB 포트 13306으로 설정
- [x] HikariCP Connection Pool 구현
- [x] DatabaseUtil 유틸리티 클래스 생성
- [x] DB 테스트 클래스 생성
- [x] SQL 초기화 스크립트 생성
- [x] 자동화 테스트 스크립트 생성
- [x] README 업데이트
- [x] pom.xml 의존성 업데이트

---

**모든 설정이 완료되었습니다! 🎉**

질문이나 추가 수정이 필요하면 말씀해주세요.
