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
      <span><%= username %>님</span>
      <% if (isAdmin) { %>
      <span class="badge badge-warning">관리자</span>
      <% } %>
    </div>
    <div class="user-actions">
      <% if (isAdmin) { %>
      <a href="<%= contextPath %>/admin/dashboard" class="link">어드민</a>
      <% } %>
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
      <p class="hero-badge">정보 수집 사이트 SCCC</p>
      <h1>Security Crawling Control Center</h1>
      <p>
        뉴스 크롤링, 커뮤니티, 상품 판매, 장바구니·결제, 마이페이지까지 제공하는 허브입니다.
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
    <h2>제공 서비스</h2>
    <div class="journey-grid">
      <div class="journey-card">
        <span class="journey-icon">로그인</span>
        <h3>회원가입 · 로그인</h3>
        <p>회원 가입, 로그인 서비스 제공합니다.</p>
      </div>
      <div class="journey-card">
        <span class="journey-icon"> 상품</span>
        <h3>크롤링 상품 게시판</h3>
        <p>실시간 네이버 뉴스 크롤링을 결과를 제공합니다.</p>
      </div>
      <div class="journey-card">
        <span class="journey-icon"> 게시판</span>
        <h3>게시판 & 댓글</h3>
        <p>게시글 작성, 검색, 댓글 서비스를 제공합니다.</p>
      </div>
      <div class="journey-card">
        <span class="journey-icon"> 쇼핑</span>
        <h3>쇼핑몰</h3>
        <p>크롤링 데이터 상품 구매 서비스를 제공합니다.</p>
      </div>
      <div class="journey-card">
        <span class="journey-icon"> 결제 </span>
        <h3>결제 & 주문</h3>
        <p>토스연동으로 결제 기능 서비스를 제공합니다.</p>
      </div>
      <div class="journey-card">
        <span class="journey-icon"> 개인정보 </span>
        <h3>마이페이지</h3>
        <p>회원 정보, 다운로드, 주문 이력 및 상태 확인 서비스를 제공합니다.</p>
      </div>
    </div>
  </section>

<h2>제공 서비스 바로가기</h2>
  <section class="quick-menu">
      
    <a href="<%= contextPath %>/crawler" class="menu-item">
      <div class="icon">크롤링</div>
      <div class="title">크롤링 실행</div>
      <div class="desc">Jsoup</div>
    </a>
    <a href="<%= contextPath %>/dbList" class="menu-item">
      <div class="icon"> 뉴스 </div>
      <div class="title">뉴스 데이터</div>
      <div class="desc">크롤링 저장 리스트</div>
    </a>
    <a href="<%= contextPath %>/products" class="menu-item primary">
      <div class="icon">쇼핑몰</div>
      <div class="title">상품</div>
      <div class="desc">크롤링 상품 구매</div>
    </a>
    <a href="<%= contextPath %>/board/list" class="menu-item">
      <div class="icon"> 게시판 </div>
      <div class="title">커뮤니티</div>
      <div class="desc">게시글·댓글</div>
    </a>
    <a href="<%= contextPath %>/cart" class="menu-item">
      <div class="icon"> 장바구니 </div>
      <div class="title">장바구니 관리</div>
      <div class="desc">상품 수량 및 관리</div>
    </a>
    <a href="<%= contextPath %>/mypage" class="menu-item">
      <div class="icon">개인</div>
      <div class="title">마이페이지</div>
      <div class="desc">주문·파일 다운로드</div>
    </a>
    <% if (isAdmin) { %>
    <a href="<%= contextPath %>/admin/dashboard" class="menu-item">
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
        <a href="<%= contextPath %>/dbList" class="link">전체 보기 →</a>
      </div>
      <ul class="insight-list">
        <% if (dashboardData.getLatestNews() == null || dashboardData.getLatestNews().isEmpty()) { %>
        <li class="empty">저장된 뉴스가 없습니다.</li>
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
        <li class="empty">작성된 게시글이 없습니다.</li>
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
              <span>댓글 <%= commentCnt != null ? commentCnt.longValue() : 0 %></span>
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
        <h3> Todo</h3>
      </div>
      <ul class="next-actions">
        <li> 크롤링 정보수집 자동화</li>
        <li> 크롤링 텍스트 데이터 자동 판단</li>
        <li> 특정 단어 위험도 측정 </li>
        <li> 위험도에 따른 분류 자동화 </li>
        <li> 게시글 작성자의 데이터 수집 및 관리</li>
        <li> 작성자가 높은 위험도의 게시글 작성 시 따로 분류</li>
        <li> NFT 상품 처리 기획 </li>
      </ul>
    </div>
  </section>

  <div class="cta-panel">
    <div>
      <h3>1901153 Su </h3>
    </div>
    <div class="cta-meta">

    </div>
  </div>
</div>
</body>
</html>
