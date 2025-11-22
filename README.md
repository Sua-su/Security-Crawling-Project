# Security Crawling Project

JSOUP을 사용하여 특정 사이트 크롤링하여 특정 단어가 들어간 문장을 크롤링해 위험도를 분석해서 위험도에 따라 분류 후 웹페이지에 표시

## 🛠️ 기술 스택

- **Java**: 11
- **Build Tool**: Maven
- **Database**: MariaDB (포트: **13306**)
- **Connection Pool**: HikariCP
- **Crawler**: Jsoup 1.17.1
- **Web**: JSP + Servlet (Tomcat 9.0)

## 📦 주요 의존성

- `org.jsoup:jsoup:1.17.1` - 웹 크롤링
- `org.mariadb.jdbc:mariadb-java-client:3.3.3` - MariaDB 드라이버
- `com.zaxxer:HikariCP:5.1.0` - Connection Pool

## 🗄️ 데이터베이스 설정

### MariaDB 연결 정보

```
Host: localhost
Port: 13306
Database: BP1901153
Username: root
Password: 1234
```

### 테이블 생성 SQL

```sql
CREATE TABLE news (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(500) NOT NULL,
    preview TEXT,
    company VARCHAR(100),
    link VARCHAR(1000),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_created_at (created_at),
    INDEX idx_company (company)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

## 🚀 시작하기

### 1. MariaDB 실행 확인

```bash
mysql -u root -p -P 13306 -h localhost
USE BP1901153;
SHOW TABLES;
```

### 2. Maven 빌드

```bash
cd BP1901153
mvn clean package
```

### 3. DB 연결 테스트

```bash
mvn exec:java -Dexec.mainClass="com.crawler.DBTest"
```

### 4. Tomcat 배포

1. `target/BP1901153-0.0.1-SNAPSHOT.war` 파일 생성 확인
2. Tomcat webapps 폴더에 복사
3. Tomcat 시작 후 `http://localhost:8080/BP1901153` 접속

## 📂 주요 클래스

### `db.DBConnect`

- HikariCP Connection Pool 사용
- MariaDB 포트 13306 연결
- 자동 재연결 및 성능 최적화

### `com.crawler.DatabaseUtil`

- `executeQuery()` - SELECT 쿼리 실행
- `executeUpdate()` - INSERT/UPDATE/DELETE
- `executeTransaction()` - 트랜잭션 처리
- `tableExists()` - 테이블 존재 확인

### `com.crawler.JsoupCrawler`

- 네이버 MLB 뉴스 크롤링
- DB 저장 기능 포함

### `com.crawler.DBTest`

- DB 연결 테스트
- CRUD 작업 테스트
- Connection Pool 상태 확인

## 💡 사용 예제

### DB 연결

```java
try (Connection conn = DBConnect.getConnection()) {
    // DB 작업
}
```

### 쿼리 실행

```java
// SELECT
List<Map<String, Object>> results =
    DatabaseUtil.executeQuery("SELECT * FROM news WHERE company = ?", "언론사");

// INSERT
DatabaseUtil.executeUpdate(
    "INSERT INTO news (title, preview, company, link) VALUES (?, ?, ?, ?)",
    "제목", "요약", "언론사", "링크"
);

// COUNT
Object count = DatabaseUtil.executeScalar("SELECT COUNT(*) FROM news");
```

## ⚙️ Connection Pool 설정

```
최대 연결: 10
최소 유휴: 2
연결 타임아웃: 30초
유휴 타임아웃: 10분
최대 수명: 30분
```

## 🐛 트러블슈팅

### 연결 오류 시

1. MariaDB 서비스 실행 확인
2. 포트 13306 확인: `netstat -an | grep 13306`
3. 방화벽 설정 확인
4. DB 권한 확인

### 빌드 오류 시

```bash
mvn clean install -U
```

## 👤 작성자

Sua-su
