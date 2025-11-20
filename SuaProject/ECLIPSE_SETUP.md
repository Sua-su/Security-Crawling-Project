# Eclipse Maven 프로젝트 설정 가이드

## 🔧 수정된 내용

### 1. pom.xml 개선

- ✅ UTF-8 인코딩 설정 추가
- ✅ Maven properties 명시적 정의
- ✅ JSP API 의존성 추가
- ✅ 플러그인 버전 업데이트 및 설정 최적화
- ✅ 들여쓰기 및 포맷팅 정리

### 2. .classpath 수정

- ✅ 불필요한 하드코딩된 jar 경로 제거
- ✅ Maven 의존성이 WEB-INF/lib로 자동 복사되도록 설정
- ✅ 소스 경로 순서 최적화

### 3. Eclipse 설정 파일 정리

- ✅ `.settings/org.eclipse.wst.common.component` 간소화
- ✅ `.settings/org.eclipse.jdt.core.prefs` 컴파일러 설정 최적화

---

## 🚀 Eclipse에서 프로젝트 설정하기

### Step 1: 프로젝트 Clean

```
1. Eclipse 메뉴: Project → Clean...
2. "Clean projects selected below" 선택
3. SuaProject 체크
4. "Clean" 버튼 클릭
```

### Step 2: Maven 업데이트

```
1. 프로젝트 우클릭
2. Maven → Update Project... (Alt + F5)
3. ☑ Force Update of Snapshots/Releases 체크
4. OK 클릭
```

### Step 3: 프로젝트 Refresh

```
1. 프로젝트 우클릭
2. Refresh (F5)
```

### Step 4: Build Path 확인

```
1. 프로젝트 우클릭 → Properties
2. Java Build Path → Libraries 탭
3. 다음 항목들이 있어야 함:
   - JRE System Library [JavaSE-11]
   - Maven Dependencies (jsoup, mariadb, HikariCP 등)
   - Apache Tomcat v9.0
```

### Step 5: Server 설정

```
1. Servers 탭 열기 (Window → Show View → Servers)
2. Tomcat v9.0 Server 더블클릭
3. Modules 탭에서 SuaProject 추가 확인
   - Path: /SuaProject
   - Auto reloading enabled: ☑
4. 저장 (Ctrl + S)
```

---

## 📁 프로젝트 구조 확인

```
SuaProject/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   ├── com/
│   │   │   │   ├── crawler/
│   │   │   │   │   ├── DatabaseUtil.java
│   │   │   │   │   └── JsoupCrawler.java
│   │   │   │   ├── dao/
│   │   │   │   └── model/
│   │   │   └── db/
│   │   │       └── DBConnect.java
│   │   ├── resources/
│   │   └── webapp/
│   │       ├── assets/
│   │       │   └── css/
│   │       │       ├── common.css
│   │       │       ├── auth.css
│   │       │       ├── admin.css
│   │       │       ├── board.css
│   │       │       ├── shop.css
│   │       │       └── mypage.css
│   │       ├── auth/
│   │       ├── board/
│   │       ├── shop/
│   │       ├── admin/
│   │       ├── WEB-INF/
│   │       │   └── web.xml
│   │       └── index.jsp
│   └── test/
│       ├── java/
│       └── resources/
├── target/
│   ├── classes/
│   └── SuaProject/ (배포된 WAR 파일)
├── pom.xml
└── .settings/
```

---

## ⚠️ 문제 해결

### 문제 1: "The superclass javax.servlet.http.HttpServlet was not found" 오류

**해결방법:**

```
1. 프로젝트 Properties → Project Facets
2. Runtime 탭에서 "Apache Tomcat v9.0" 체크
3. Apply and Close
```

### 문제 2: JSP 파일이 인식되지 않음

**해결방법:**

```
1. .settings/org.eclipse.wst.common.project.facet.core.xml 확인
2. <installed facet="jst.web" version="4.0"/> 있어야 함
3. 없으면 프로젝트 우클릭 → Properties → Project Facets에서 설정
```

### 문제 3: Maven Dependencies가 WEB-INF/lib에 복사 안됨

**해결방법:**

```
1. .classpath 파일 확인
2. MAVEN2_CLASSPATH_CONTAINER에 다음 속성 있어야 함:
   <attribute name="org.eclipse.jst.component.dependency" value="/WEB-INF/lib"/>
3. 없으면 위에서 수정한 .classpath 파일로 교체
```

### 문제 4: CSS 파일이 로드되지 않음

**해결방법:**

```
1. 프로젝트 Clean
2. Tomcat Server Clean (Servers 탭에서 서버 우클릭 → Clean...)
3. 서버 재시작
4. 브라우저 캐시 삭제 (Ctrl + Shift + Delete)
```

### 문제 5: 한글이 깨짐

**해결방법:**

```
1. 프로젝트 우클릭 → Properties
2. Resource → Text file encoding
3. "UTF-8" 선택
4. Apply and Close
```

---

## 🔄 터미널에서 Maven 빌드 (선택사항)

Eclipse 외부에서도 빌드 가능:

```bash
# 프로젝트 디렉토리로 이동
cd /Users/su/Documents/Security-Crawling-Project-test/SuaProject

# Clean & Compile
mvn clean compile

# WAR 파일 생성
mvn clean package

# 생성된 WAR 파일 위치
# → target/SuaProject.war
```

---

## ✅ 실행 확인

### 1. 서버 시작

```
1. Servers 탭에서 Tomcat v9.0 Server 우클릭
2. Start (또는 Debug)
3. Console에서 "Server startup in [xxx] milliseconds" 확인
```

### 2. 브라우저 접속

```
http://localhost:8080/SuaProject/index.jsp
```

### 3. 주요 페이지 확인

- 로그인: http://localhost:8080/SuaProject/auth/login.jsp
- 회원가입: http://localhost:8080/SuaProject/auth/signup.jsp
- 게시판: http://localhost:8080/SuaProject/board/list.jsp
- 쇼핑몰: http://localhost:8080/SuaProject/shop/products.jsp
- 관리자: http://localhost:8080/SuaProject/admin/dashboard.jsp

---

## 📊 데이터베이스 연결 확인

### MariaDB 연결 테스트

```sql
-- MariaDB 접속
mysql -u root -p -P 13306

-- 데이터베이스 확인
USE BP1901153;

-- 테이블 확인
SHOW TABLES;

-- 사용자 확인
SELECT * FROM users;
```

### 연결 실패 시

1. MariaDB가 포트 13306에서 실행 중인지 확인
2. `com.crawler.DatabaseUtil.java`에서 연결 정보 확인
3. HikariCP 설정 확인

---

## 🎯 성능 최적화 팁

### 1. Eclipse 메모리 설정

`eclipse.ini` 파일 수정:

```
-Xms512m
-Xmx2048m
-XX:+UseG1GC
```

### 2. Tomcat 메모리 설정

Servers 탭 → 서버 더블클릭 → "Open launch configuration"

```
VM arguments:
-Xms256m -Xmx512m -XX:MaxPermSize=256m
```

### 3. 자동 빌드 끄기

대용량 프로젝트의 경우:

```
Project → Build Automatically (체크 해제)
```

---

## 📝 개발 시 주의사항

1. **JSP 수정 후**: 자동 재배포됨 (저장만 하면 됨)
2. **Java 수정 후**: Clean & Build 권장
3. **CSS 수정 후**: 브라우저 캐시 삭제 필요
4. **pom.xml 수정 후**: 반드시 Maven Update
5. **web.xml 수정 후**: 서버 재시작 필요

---

## 🆘 추가 도움말

### Eclipse Marketplace에서 유용한 플러그인

```
Help → Eclipse Marketplace 검색:
- SonarLint (코드 품질 검사)
- Eclipse Color Theme (테마)
- Checkstyle (코딩 스타일 검사)
```

### 단축키

- `Ctrl + Shift + R`: 파일 빠른 검색
- `Ctrl + Shift + T`: 클래스 빠른 검색
- `Ctrl + Space`: 자동완성
- `Alt + F5`: Maven Update
- `F5`: Refresh
- `Ctrl + F11`: Run

---

**수정 완료! Eclipse에서 프로젝트를 Clean하고 Maven Update하면 정상 작동합니다.** 🎉
