# MVC 패턴 적용 완료

## 구조 변경사항

### Before (기존)

```
idnex.jsp (모든 비즈니스 로직 포함)
```

### After (MVC 패턴)

```
Controller Layer:
├── IndexController.java (요청 처리, 데이터 흐름 제어)

Service Layer:
├── DashboardService.java (비즈니스 로직)

DTO Layer:
├── DashboardData.java (데이터 전송 객체)

View Layer:
└── WEB-INF/views/index.jsp (화면 표시만 담당)
```

## 파일 설명

### 1. Controller (com.controller.IndexController)

- **역할**: HTTP 요청 처리, Service 호출, View로 데이터 전달
- **URL**: `/index`
- **주요 기능**:
  - 세션에서 사용자 정보 추출
  - DashboardService를 통해 대시보드 데이터 조회
  - Request에 데이터 설정 후 JSP로 포워딩

### 2. Service (com.service.DashboardService)

- **역할**: 비즈니스 로직 처리
- **주요 기능**:
  - 뉴스, 게시판, 상품, 주문 데이터 조회
  - DB 테이블 존재 여부 확인
  - 에러 처리 및 연결 상태 판단

### 3. DTO (com.dto.DashboardData)

- **역할**: 계층 간 데이터 전송
- **포함 데이터**:
  - 통계 데이터 (뉴스, 게시판, 상품, 주문 수)
  - 최신 항목 리스트
  - DB 연결 상태 및 에러 메시지

### 4. View (WEB-INF/views/index.jsp)

- **역할**: 화면 표시만 담당 (비즈니스 로직 제거)
- **특징**:
  - Controller에서 전달받은 데이터만 표시
  - JSTL/EL 표현식 사용 가능

## 사용 방법

### 접속 URL 변경

```
Before: http://localhost:8080/BP1901153/idnex.jsp
After:  http://localhost:8080/BP1901153/index
```

### web.xml 설정 (필요시)

```xml
<servlet>
    <servlet-name>IndexController</servlet-name>
    <servlet-class>com.controller.IndexController</servlet-class>
</servlet>
<servlet-mapping>
    <servlet-name>IndexController</servlet-name>
    <url-pattern>/index</url-pattern>
</servlet-mapping>
```

## 장점

1. **유지보수성 향상**: 각 계층이 명확히 분리되어 수정 용이
2. **테스트 용이**: Service 계층을 독립적으로 테스트 가능
3. **재사용성**: Service와 DTO는 다른 Controller에서도 사용 가능
4. **확장성**: 새로운 기능 추가 시 해당 계층만 수정

## 다음 단계

다른 JSP 파일들도 같은 방식으로 MVC 패턴을 적용할 수 있습니다:

- productBoard.jsp → ProductBoardController
- board/list.jsp → BoardController
- shop/products.jsp → ShopController
