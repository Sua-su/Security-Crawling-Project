<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.dto.ProductBoardData" %>
<%
    String contextPath = request.getContextPath();
    ProductBoardData data = (ProductBoardData) request.getAttribute("productBoardData");
    String category = (String) request.getAttribute("category");
    String sort = (String) request.getAttribute("sort");
    Integer minPrice = (Integer) request.getAttribute("minPrice");
    Integer maxPrice = (Integer) request.getAttribute("maxPrice");
    int currentPage = (Integer) request.getAttribute("currentPage");
    
    // 데이터 추출
    List<Map<String, Object>> productFeed = data != null ? data.getProductFeed() : Collections.emptyList();
    List<Map<String, Object>> categoryStats = data != null ? data.getCategoryStats() : Collections.emptyList();
    List<String> integrationWarnings = data != null ? data.getIntegrationWarnings() : Collections.emptyList();
    List<Map<String, Object>> latestNews = data != null ? data.getLatestNews() : Collections.emptyList();
    List<Map<String, Object>> crawlLogs = data != null ? data.getCrawlLogs() : Collections.emptyList();
    
    boolean productsReady = data != null && data.isProductsReady();
    boolean newsReady = data != null && data.isNewsReady();
    boolean crawlReady = data != null && data.isCrawlReady();
    
    int totalPages = data != null ? data.getTotalPages() : 1;
    long totalProducts = data != null ? data.getTotalProducts() : 0;
    long inventoryStock = data != null ? data.getInventoryStock() : 0;
    long totalNews = data != null ? data.getTotalNews() : 0;
    long todayNews = data != null ? data.getTodayNews() : 0;
    long companyCount = data != null ? data.getCompanyCount() : 0;
    
    // URL 파라미터 생성
    StringBuilder extraQuery = new StringBuilder();
    try {
        if (category != null && !category.trim().isEmpty()) {
            extraQuery.append("&category=").append(java.net.URLEncoder.encode(category, "UTF-8"));
        }
        if (sort != null && !sort.trim().isEmpty()) {
            extraQuery.append("&sort=").append(sort);
        }
        if (minPrice != null) {
            extraQuery.append("&minPrice=").append(minPrice);
        }
        if (maxPrice != null) {
            extraQuery.append("&maxPrice=").append(maxPrice);
        }
    } catch (Exception ignore) {}
    String extraParams = extraQuery.toString();

    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title> 크롤링 상품 게시판</title>
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/common.css" />
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/product-board.css" />
</head>
<body>
<div class="container product-board">
    <div class="nav-links">
        <a href="<%= contextPath %>/index"> 홈</a>
        <a href="<%= contextPath %>/board/list">게시판</a>
        <a href="<%= contextPath %>/products"> 상품구매</a>
        <a href="<%= contextPath %>/cart"> 장바구니</a>
        <a href="<%= contextPath %>/mypage"> 마이페이지</a>
    </div>

    <% if (!integrationWarnings.isEmpty()) { %>
    <div class="alert alert-warning">
        <strong> 데이터 점검 필요</strong>
        <ul style="margin-top: 8px; margin-left: 20px;">
            <% for (String warning : integrationWarnings) { %>
            <li><%= warning %></li>
            <% } %>
        </ul>
    </div>
    <% } %>

    <section class="product-board__header">
        <div>
            <p class="hero-badge">크롤링 데이터 → 상품화 → 판매/다운로드</p>
            <h1>크롤링 상품 게시판</h1>
            <p>뉴스/보안 데이터를 상품형태로 큐레이션하고 쇼핑몰, 게시판, 장바구니 플로우로 자연스럽게 연결합니다.</p>
        </div>
        <div class="header-actions">
            <a href="<%= contextPath %>/crawler" class="btn btn-secondary">크롤링 실행</a>
            <a href="<%= contextPath %>/products" class="btn btn-primary">상품 구매하기</a>
        </div>
    </section>

    <section class="summary-row">
        <div class="summary-card">
            <span class="label">등록 상품</span>
            <span class="value"><%= totalProducts %>개</span>
        </div>
        <div class="summary-card">
            <span class="label">재고 합계</span>
            <span class="value"><%= inventoryStock %>건</span>
        </div>
        <div class="summary-card">
            <span class="label">전체 뉴스</span>
            <span class="value"><%= totalNews %>건</span>
        </div>
        <div class="summary-card">
            <span class="label">오늘 수집</span>
            <span class="value"><%= todayNews %>건</span>
        </div>
        <div class="summary-card">
            <span class="label">언론사 수</span>
            <span class="value"><%= companyCount %>곳</span>
        </div>
    </section>

    <form class="filter-bar" method="get" action="<%= contextPath %>/products">
        <div class="filter-group">
            <label>카테고리</label>
            <select name="category">
                <option value="">전체</option>
                <option value="news" <%= "news".equals(category) ? "selected" : "" %>>뉴스 데이터</option>
                <option value="analysis" <%= "analysis".equals(category) ? "selected" : "" %>>분석 데이터</option>
                <option value="report" <%= "report".equals(category) ? "selected" : "" %>>리포트</option>
            </select>
        </div>
        <div class="filter-group">
            <label>가격 범위</label>
            <div class="price-inputs">
                <input type="number" name="minPrice" placeholder="최소" value="<%= minPrice != null ? minPrice : "" %>">
                <span>~</span>
                <input type="number" name="maxPrice" placeholder="최대" value="<%= maxPrice != null ? maxPrice : "" %>">
            </div>
        </div>
        <div class="filter-group">
            <label>정렬</label>
            <select name="sort">
                <option value="">최신순</option>
                <option value="priceAsc" <%= "priceAsc".equals(sort) ? "selected" : "" %>>가격 오름차순</option>
                <option value="priceDesc" <%= "priceDesc".equals(sort) ? "selected" : "" %>>가격 내림차순</option>
                <option value="stock" <%= "stock".equals(sort) ? "selected" : "" %>>재고 많은 순</option>
            </select>
        </div>
        <div class="filter-actions">
            <button type="submit" class="btn btn-primary">필터 적용</button>
            <a href="<%= contextPath %>/products" class="btn btn-outline">초기화</a>
        </div>
    </form>

    <section class="chip-section">
        <h3>카테고리 현황</h3>
        <div class="chips">
            <% if (!productsReady) { %>
            <span class="chip">products 테이블 준비 필요</span>
            <% } else if (categoryStats.isEmpty()) { %>
            <span class="chip">등록된 상품이 없습니다.</span>
            <% } else {
                for (Map<String, Object> row : categoryStats) {
                    String cat = (String) row.get("category");
                    Number cnt = (Number) row.get("cnt");
            %>
            <a class="chip <%= cat != null && cat.equals(category) ? "active" : "" %>" href="<%= contextPath %>/products?category=<%= cat %>">
                <%= cat != null ? cat : "미분류" %> (<%= cnt != null ? cnt.intValue() : 0 %>)
            </a>
            <% }
            } %>
        </div>
    </section>

    <section class="product-grid">
        <% if (!productsReady) { %>
        <div class="empty">
            <p>products 테이블을 생성한 뒤 페이지를 새로고침하세요.</p>
            <a href="<%= contextPath %>/dbList" class="btn btn-secondary" style="text-decoration: none;">DB 초기화 가이드</a>
        </div>
        <% } else if (productFeed.isEmpty()) { %>
        <div class="empty">
            <p>조건에 맞는 상품이 없습니다.</p>
            <a href="<%= contextPath %>/products" class="btn btn-secondary" style="text-decoration: none;">상품 보러가기</a>
        </div>
        <% } else {
            for (Map<String, Object> row : productFeed) {
                Number productId = (Number) row.get("product_id");
                String name = (String) row.get("product_name");
                String desc = (String) row.get("description");
                Number price = (Number) row.get("price");
                Number stock = (Number) row.get("stock");
                String cat = (String) row.get("category");
                Object created = row.get("created_at");
                boolean hasStock = stock != null && stock.longValue() > 0;
                String icon = "";
                if ("news".equals(cat)) icon = "";
                else if ("analysis".equals(cat)) icon = "";
                else if ("report".equals(cat)) icon = "";
        %>
        <article class="product-card">
            <div class="product-icon"><%= icon %></div>
            <h3><%= name %></h3>
            <p class="product-desc"><%= desc != null ? desc : "설명이 없습니다." %></p>
            <div class="product-meta">
                <span class="badge badge-primary"><%= cat != null ? cat : "미분류" %></span>
                <span><%= price != null ? String.format("%,d원", price.longValue()) : "가격 미정" %></span>
                <span class="stock <%= hasStock ? "stock-ok" : "stock-out" %>">
                    <%= hasStock ? "재고 " + stock.longValue() + "개" : "품절" %>
                </span>
            </div>
            <% if (created != null) { %>
            <div class="product-date">등록: <%= dateFormat.format((java.util.Date) created) %></div>
            <% } %>
            <div class="product-actions">
                <a class="btn btn-secondary" href="<%= contextPath %>/shop/productDetail?id=<%= productId %>">상세보기</a>
                <% if (hasStock) { %>
                <form action="<%= contextPath %>/shop/addToCart" method="post">
                    <input type="hidden" name="productId" value="<%= productId %>">
                    <button type="submit" class="btn btn-primary">장바구니</button>
                </form>
                <% } else { %>
                <button class="btn btn-outline" disabled>품절</button>
                <% } %>
            </div>
        </article>
        <% }
        } %>
    </section>

    <div class="pagination">
        <% if (currentPage > 1) { %>
        <a href="<%= contextPath %>/products?page=<%= currentPage - 1 %><%= extraParams %>">이전</a>
        <% } %>
        <span>Page <%= currentPage %> / <%= totalPages %></span>
        <% if (currentPage < totalPages) { %>
        <a href="<%= contextPath %>/products?page=<%= currentPage + 1 %><%= extraParams %>">다음</a>
        <% } %>
    </div>

    <section class="news-log">
        <div class="news-panel">
            <h3> 최신 뉴스</h3>
            <ul>
                <% if (!newsReady) { %>
                <li>news 테이블이 준비되지 않았습니다.</li>
                <% } else if (latestNews == null || latestNews.isEmpty()) { %>
                <li>데이터가 없습니다.</li>
                <% } else {
                    for (Map<String, Object> row : latestNews) {
                        String title = (String) row.get("title");
                        String company = (String) row.get("company");
                        Object created = row.get("created_at");
                %>
                <li>
                    <strong><%= title %></strong>
                    <span><%= company != null ? company : "언론사 미지정" %></span>
                    <% if (created != null) { %>
                    <span><%= dateFormat.format((java.util.Date) created) %></span>
                    <% } %>
                </li>
                <% }
                } %>
            </ul>
        </div>
        <div class="log-panel">
            <h3>최근 크롤링 로그</h3>
            <ul>
                <% if (!crawlReady) { %>
                <li>crawl_log 테이블이 준비되지 않았습니다.</li>
                <% } else if (crawlLogs == null || crawlLogs.isEmpty()) { %>
                <li>기록이 없습니다.</li>
                <% } else {
                    for (Map<String, Object> row : crawlLogs) {
                        String status = (String) row.get("status");
                        Number count = (Number) row.get("items_count");
                        Object created = row.get("crawled_at");
                %>
                <li>
                    <span class="status <%= "SUCCESS".equals(status) ? "success" : "danger" %>">
                        <%= status %>
                    </span>
                    <span>수집 <%= count != null ? count.intValue() : 0 %>건</span>
                    <% if (created != null) { %>
                    <span><%= dateFormat.format((java.util.Date) created) %></span>
                    <% } %>
                </li>
                <% }
                } %>
            </ul>
        </div>
    </section>

    <div class="cta-panel">
        <div>
            <h3>다음 단계</h3>
            <p>상품이 업데이트되면 쇼핑몰·게시판·마이페이지를 순서대로 점검해보세요.</p>
        </div>
        <div class="cta-actions">
            <a href="<%= contextPath %>/cart" class="btn btn-secondary">장바구니 테스트</a>
            <a href="<%= contextPath %>/board/list" class="btn btn-outline">게시판 이동</a>
        </div>
    </div>
</div>
</body>
</html>
