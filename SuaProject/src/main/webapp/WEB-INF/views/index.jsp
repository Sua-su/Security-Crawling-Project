<%@ page import="com.model.User" %>
<%@ page import="com.dto.DashboardData" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  // Controller에서 설정한 속성 가져오기
  Boolean isLoggedIn = (Boolean) request.getAttribute("isLoggedIn");
  Boolean isAdmin = (Boolean) request.getAttribute("isAdmin");
  String username = (String) request.getAttribute("username");
  DashboardData dashboardData = (DashboardData) request.getAttribute("dashboardData");
  
  String contextPath = request.getContextPath();
  SimpleDateFormat dateFormat = new SimpleDateFormat("MM/dd HH:mm");
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <title> Security Crawling Project</title>
  <link rel="stylesheet" href="<%= contextPath %>/assets/css/common.css" />
</head>
<body>
<div class="container dashboard">
  <% if (isLoggedIn) { %>
  <div class="user-info-bar">
    <div>
      <span>🌟 <%= username %>님</span>
      <% if (isAdmin) { %>
      <span class="badge badge-warning">관리자</span>
      <% } %>
    </div>
    <div class="user-actions">
      <a href="<%= contextPath %>/mypage" class="link">마이페이지</a>
      <a href="<%= contextPath %>/auth/logout" class="link">로그아웃</a>
    </div>
  </div>
  <% } else { %>
  <div class="user-info-bar guest">
    <span> 로그인 후 가능.</span>
    <div class="user-actions">
      <a href="<%= contextPath %>/auth/login" class="btn btn-primary">로그인</a>
      <a href="<%= contextPath %>/auth/signup" class="btn btn-secondary">회원가입</a>
    </div>
  </div>
  <% } %>

  <section class="hero">
    <div class="hero-left">
      <p class="hero-badge">회원 → 메인 → 게시판/쇼핑/마이페이지 플로우</p>
      <h1>Security Crawling Control Center</h1>
      <p>
        MLB 뉴스 크롤링, 커뮤니티, 상품 판매, 장바구니·결제, 마이페이지까지 한 번에 연결된 운영 허브입니다.
      </p>
      <div class="hero-actions">
        <a href="<%= contextPath %>/crawler" class="btn btn-primary">크롤링 실행</a>
        <a href="<%= contextPath %>/products" class="btn btn-secondary">상품 게시판 보기</a>
      </div>
      <ul class="flow-steps">
        <li class="flow-step">
          <span class="flow-step-number">1</span>
          회원가입 / 로그인
        </li>
        <li class="flow-step">
          <span class="flow-step-number">2</span>
          메인 대시보드 확인
        </li>
        <li class="flow-step">
          <span class="flow-step-number">3</span>
          상품 게시판 · 자유게시판 탐색
        </li>
        <li class="flow-step">
          <span class="flow-step-number">4</span>
          쇼핑몰 → 장바구니 → 결제
        </li>
        <li class="flow-step">
          <span class="flow-step-number">5</span>
          마이페이지에서 주문/다운로드 확인
        </li>
      </ul>
    </div>
    <div class="hero-right">
      <div class="status-card">
        <div class="status-item">
          <span class="status-label">DB 연결</span>
          <span class="status-value <%= dashboardData.isConnected() ? "online" : "offline" %>">
            <%= dashboardData.isConnected() ? " 연결됨" : " 확인 필요" %>
          </span>
        </div>
        <div class="status-item">
          <span class="status-label">오늘 수집</span>
          <span class="status-value"><%= dashboardData.getTodayCount() %>건</span>
        </div>
        <div class="status-item">
          <span class="status-label">상품 수</span>
          <span class="status-value"><%= dashboardData.getProductCount() %>개</span>
        </div>
        <div class="status-item">
          <span class="status-label">주문 누적</span>
          <span class="status-value"><%= dashboardData.getOrderCount() %>건</span>
        </div>
        <% if (!dashboardData.isConnected() && dashboardData.getErrorMsg() != null) { %>
        <p class="status-hint"> 에러 메세지 <%= dashboardData.getErrorMsg() %></p>
        <% } %>
      </div>
    </div>
  </section>

  <section class="journey-section">
    <h2>확인용</h2>
    <div class="journey-grid">
      <div class="journey-card">
        <span class="journey-icon">🔐 로그인</span>
        <h3>회원가입 · 로그인</h3>
        <p>auth 모듈에서 회원 등록 및 권한(관리자/일반) 부여.</p>
      </div>
      <div class="journey-card">
        <span class="journey-icon"> 상품</span>
        <h3>크롤링 상품 게시판</h3>
        <p>실시간 크롤링 결과를 카드형으로 제공, 상품 구매와 연계.</p>
      </div>
      <div class="journey-card">
        <span class="journey-icon"> 게시판</span>
        <h3>게시판 & 댓글</h3>
        <p>게시글 작성, 검색, 댓글/조회수 집계, 커뮤니티 운영.</p>
      </div>
      <div class="journey-card">
        <span class="journey-icon"> 쇼핑</span>
        <h3>쇼핑몰 → 장바구니</h3>
        <p>크롤링 데이터 상품 구매, 장바구니 수량/재고 검증.</p>
      </div>
      <div class="journey-card">
        <span class="journey-icon"> 결제 </span>
        <h3>결제 & 주문</h3>
        <p>checkout.jsp에서 결제 수단 선택, 주문 테이블에 기록.</p>
      </div>
      <div class="journey-card">
        <span class="journey-icon"> 마이페이지 </span>
        <h3>마이페이지</h3>
        <p>회원 정보, 다운로드, 주문 이력 및 상태 확인.</p>
      </div>
    </div>
  </section>

  <section class="quick-menu">
    <a href="<%= contextPath %>/crawler" class="menu-item">
      <div class="icon">가동</div>
      <div class="title">크롤링 실행</div>
      <div class="desc">Jsoup + HikariCP</div>
    </a>
    <a href="dbList.jsp" class="menu-item">
      <div class="icon"> 뉴스 </div>
      <div class="title">뉴스 데이터</div>
      <div class="desc">DB 저장 리스트</div>
    </a>
    <a href="<%= contextPath %>/products" class="menu-item primary">
      <div class="icon"> 🛒 </div>
      <div class="title">상품</div>
      <div class="desc">크롤링 상품 구매</div>
    </a>
    <a href="<%= contextPath %>/board/list" class="menu-item">
      <div class="icon"> 게시판 </div>
      <div class="title">커뮤니티</div>
      <div class="desc">게시글·댓글</div>
    </a>
    <a href="<%= contextPath %>/cart" class="menu-item">
      <div class="icon"> 쇼핑몰 </div>
      <div class="title">장바구니</div>
      <div class="desc">수량 & 재고 관리</div>
    </a>
    <a href="<%= contextPath %>/mypage" class="menu-item">
      <div class="icon">개인</div>
      <div class="title">마이페이지</div>
      <div class="desc">주문·파일 다운로드</div>
    </a>
    <% if (isAdmin) { %>
    <a href="<%= contextPath %>/admin/dashboard.jsp" class="menu-item">
      <div class="icon"> 관리자 </div>
      <div class="title">관리자 센터</div>
      <div class="desc">상품·회원 관리</div>
    </a>
    <% } %>
  </section>

  <section class="stats-panel">
    <div class="stat-card">
      <span class="label">전체 뉴스</span>
      <span class="value"><%= dashboardData.getNewsCount() %></span>
    </div>
    <div class="stat-card">
      <span class="label">게시글 수</span>
      <span class="value"><%= dashboardData.getBoardCount() %></span>
    </div>
    <div class="stat-card">
      <span class="label">상품 수</span>
      <span class="value"><%= dashboardData.getProductCount() %></span>
    </div>
    <div class="stat-card">
      <span class="label">주문 누적</span>
      <span class="value"><%= dashboardData.getOrderCount() %></span>
    </div>
  </section>

  <section class="insight-panels">
    <div class="insight-card">
      <div class="insight-header">
        <h3> 최신 크롤링 뉴스</h3>
        <a href="dbList.jsp" class="link">전체 보기 →</a>
      </div>
      <ul class="insight-list">
        <% if (dashboardData.getLatestNews() == null || dashboardData.getLatestNews().isEmpty()) { %>
        <li class="empty">📭 저장된 뉴스가 없습니다.</li>
        <% } else {
          for (Map<String, Object> row : dashboardData.getLatestNews()) {
            String title = (String) row.get("title");
            String company = (String) row.get("company");
            Object created = row.get("created_at");
        %>
        <li>
          <div>
            <strong><%= title != null ? title : "제목 없음" %></strong>
            <div class="insight-meta">
              <span><%= company != null ? company : "언론사 미지정" %></span>
              <% if (created != null) { %>
              <span><%= dateFormat.format((java.util.Date) created) %></span>
              <% } %>
            </div>
          </div>
        </li>
        <%
          }
        } %>
      </ul>
    </div>

    <div class="insight-card">
      <div class="insight-header">
        <h3> 상품 미리보기</h3>
        <a href="<%= contextPath %>/products" class="link">상품 보기 →</a>
      </div>
      <ul class="insight-list">
        <% if (dashboardData.getLatestProducts() == null || dashboardData.getLatestProducts().isEmpty()) { %>
        <li class="empty"> 등록된 상품이 없습니다.</li>
        <% } else {
          for (Map<String, Object> row : dashboardData.getLatestProducts()) {
            String productName = (String) row.get("product_name");
            String description = (String) row.get("description");
            String status = (String) row.get("status");
            Object created = row.get("created_at");
            Number price = (Number) row.get("price");
        %>
        <li>
          <div>
            <strong><%= productName != null ? productName : "상품명 없음" %></strong>
            <div class="insight-meta">
              <span><%= description != null && description.length() > 30 ? description.substring(0, 30) + "..." : (description != null ? description : "설명 없음") %></span>
            </div>
            <div class="insight-meta">
              <span><%= price != null ? String.format("%,d원", price.longValue()) : "가격 미정" %></span>
              <% if (status != null) { %>
              <span><%= "ACTIVE".equals(status) ? "판매중" : "판매중지" %></span>
              <% } %>
            </div>
            <% if (created != null) { %>
            <div class="insight-meta">
              <span><%= dateFormat.format((java.util.Date) created) %></span>
            </div>
            <% } %>
          </div>
        </li>
        <%
          }
        } %>
      </ul>
    </div>
  </section>

  <section class="insight-panels">
    <div class="insight-card">
      <div class="insight-header">
        <h3> 최신 게시글</h3>
        <a href="<%= contextPath %>/board/list" class="link">게시판 이동 →</a>
      </div>
      <ul class="insight-list">
        <% if (dashboardData.getLatestBoardPosts() == null || dashboardData.getLatestBoardPosts().isEmpty()) { %>
        <li class="empty">📭 작성된 게시글이 없습니다.</li>
        <% } else {
          for (Map<String, Object> row : dashboardData.getLatestBoardPosts()) {
            String title = (String) row.get("title");
            String author = (String) row.get("author");
            Number commentCnt = (Number) row.get("comment_count");
            Object created = row.get("created_at");
        %>
        <li>
          <div>
            <strong><%= title %></strong>
            <div class="insight-meta">
              <span>by <%= author %></span>
              <span>💬 <%= commentCnt != null ? commentCnt.longValue() : 0 %></span>
              <% if (created != null) { %>
              <span><%= dateFormat.format((java.util.Date) created) %></span>
              <% } %>
            </div>
          </div>
        </li>
        <%
          }
        } %>
      </ul>
    </div>

    <div class="insight-card">
      <div class="insight-header">
        <h3> 다음 액션</h3>
      </div>
      <ul class="next-actions">
        <li> 크롤링 완료 후 <strong>상품 게시판</strong>에 노출</li>
        <li> 게시판 공지 등록 및 댓글 모니터링</li>
        <li> 쇼핑몰 재고/가격 최신화</li>
        <li> 장바구니 → 결제 테스트</li>
        <li> 마이페이지 주문·다운로드 검증</li>
      </ul>
    </div>
  </section>

  <div class="cta-panel">
    <div>
      <h3>MariaDB + Tomcat + Eclipse test </h3>
      <div class="cta-actions">
        <a href="<%= contextPath %>/products" class="btn btn-primary">상품 게시판 확인</a>
        <a href="<%= contextPath %>/products" class="btn btn-secondary">상품 보러가기</a>
      </div>
    </div>
    <div class="cta-meta">

    </div>
  </div>
</div>
</body>
</html>
