<%@ page import="com.crawler.DatabaseUtil" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login");
        return;
    }

    String contextPath = request.getContextPath();
    String category = request.getParameter("category");
    String sort = request.getParameter("sort");
    String minPriceParam = request.getParameter("minPrice");
    String maxPriceParam = request.getParameter("maxPrice");

    Integer minPrice = null;
    Integer maxPrice = null;
    if (minPriceParam != null && minPriceParam.trim().length() > 0) {
        try { minPrice = Integer.parseInt(minPriceParam.trim()); } catch (NumberFormatException ignore) {}
    }
    if (maxPriceParam != null && maxPriceParam.trim().length() > 0) {
        try { maxPrice = Integer.parseInt(maxPriceParam.trim()); } catch (NumberFormatException ignore) {}
    }

    int pageSize = 9;
    int currentPage = 1;
    String pageParam = request.getParameter("page");
    if (pageParam != null) {
        try { currentPage = Math.max(1, Integer.parseInt(pageParam)); } catch (NumberFormatException ignore) {}
    }
    int offset = (currentPage - 1) * pageSize;

    StringBuilder filter = new StringBuilder(" WHERE 1=1 ");
    List<Object> params = new ArrayList<>();
    if (category != null && !category.trim().isEmpty()) {
        filter.append(" AND category = ?");
        params.add(category.trim());
    }
    if (minPrice != null) {
        filter.append(" AND price >= ?");
        params.add(minPrice);
    }
    if (maxPrice != null) {
        filter.append(" AND price <= ?");
        params.add(maxPrice);
    }

    String orderSql = " ORDER BY created_at DESC";
    if ("priceAsc".equals(sort)) {
        orderSql = " ORDER BY price ASC";
    } else if ("priceDesc".equals(sort)) {
        orderSql = " ORDER BY price DESC";
    } else if ("stock".equals(sort)) {
        orderSql = " ORDER BY stock DESC";
    }

    boolean productsReady = DatabaseUtil.tableExists("products");
    boolean newsReady = DatabaseUtil.tableExists("news");
    boolean crawlReady = DatabaseUtil.tableExists("crawl_log");
    List<String> integrationWarnings = new ArrayList<>();

    int totalCount = 0;
    int totalPages = 1;
    List<Map<String, Object>> productFeed = Collections.emptyList();
    List<Map<String, Object>> categoryStats = Collections.emptyList();
    long totalProducts = 0L;
    long inventoryStock = 0L;

    if (productsReady) {
        try {
            Object totalCountObj = DatabaseUtil.executeScalar(
                "SELECT COUNT(*) FROM products" + filter.toString(),
                params.toArray(new Object[0])
            );
            totalCount = totalCountObj instanceof Number ? ((Number) totalCountObj).intValue() : 0;
            totalPages = Math.max(1, (int) Math.ceil(totalCount / (double) pageSize));

            List<Object> dataParams = new ArrayList<>(params);
            dataParams.add(pageSize);
            dataParams.add(offset);

            productFeed = DatabaseUtil.executeQuery(
                "SELECT product_id, name, description, price, stock, category, file_path, created_at " +
                "FROM products" + filter.toString() + orderSql + " LIMIT ? OFFSET ?",
                dataParams.toArray(new Object[0])
            );

            categoryStats = DatabaseUtil.executeQuery(
                "SELECT category, COUNT(*) AS cnt FROM products GROUP BY category ORDER BY cnt DESC"
            );

            Object totalProductsObj = DatabaseUtil.executeScalar("SELECT COUNT(*) FROM products");
            totalProducts = totalProductsObj instanceof Number ? ((Number) totalProductsObj).longValue() : 0L;
            Object inventorySumObj = DatabaseUtil.executeScalar("SELECT IFNULL(SUM(stock), 0) FROM products");
            inventoryStock = inventorySumObj instanceof Number ? ((Number) inventorySumObj).longValue() : 0L;
        } catch (Exception e) {
            integrationWarnings.add("상품 정보를 불러오지 못했습니다: " + e.getMessage());
        }
    } else {
        integrationWarnings.add("products 테이블을 찾을 수 없습니다. database/init.sql을 실행해 주세요.");
    }

    long totalNews = 0L;
    long todayNews = 0L;
    long companyCount = 0L;
    List<Map<String, Object>> latestNews = Collections.emptyList();
    if (newsReady) {
        try {
            latestNews = DatabaseUtil.executeQuery(
                "SELECT title, company, created_at FROM news ORDER BY created_at DESC LIMIT 5"
            );

            Object totalNewsObj = DatabaseUtil.executeScalar("SELECT COUNT(*) FROM news");
            totalNews = totalNewsObj instanceof Number ? ((Number) totalNewsObj).longValue() : 0L;
            Object todayNewsObj = DatabaseUtil.executeScalar("SELECT COUNT(*) FROM news WHERE DATE(created_at) = CURDATE()");
            todayNews = todayNewsObj instanceof Number ? ((Number) todayNewsObj).longValue() : 0L;
            Object companyCountObj = DatabaseUtil.executeScalar("SELECT COUNT(DISTINCT company) FROM news WHERE company IS NOT NULL AND company <> ''");
            companyCount = companyCountObj instanceof Number ? ((Number) companyCountObj).longValue() : 0L;
        } catch (Exception e) {
            integrationWarnings.add("뉴스 데이터를 불러오지 못했습니다: " + e.getMessage());
        }
    } else {
        integrationWarnings.add("news 테이블이 없습니다. init 스크립트를 실행해 주세요.");
    }

    List<Map<String, Object>> crawlLogs = Collections.emptyList();
    if (crawlReady) {
        try {
            crawlLogs = DatabaseUtil.executeQuery(
                "SELECT status, items_count, crawled_at FROM crawl_log ORDER BY crawled_at DESC LIMIT 3"
            );
        } catch (Exception e) {
            integrationWarnings.add("크롤링 로그를 불러오지 못했습니다: " + e.getMessage());
        }
    } else {
        integrationWarnings.add("crawl_log 테이블이 없어 크롤링 이력을 표시할 수 없습니다.");
    }

    StringBuilder extraQuery = new StringBuilder();
    try {
        if (category != null && !category.isEmpty()) {
            extraQuery.append("&category=").append(URLEncoder.encode(category, "UTF-8"));
        }
        if (sort != null && !sort.isEmpty()) {
            extraQuery.append("&sort=").append(URLEncoder.encode(sort, "UTF-8"));
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
        <a href="<%= contextPath %>/board/list">💬 게시판</a>
        <a href="<%= contextPath %>/shop/products"> 쇼핑몰</a>
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

    <header class="product-board__header">
        <div>
            <p class="hero-badge">크롤링 데이터 → 상품화 → 판매/다운로드</p>
            <h1>크롤링 상품 게시판</h1>
            <p>뉴스/보안 데이터를 상품형태로 큐레이션하고 쇼핑몰, 게시판, 장바구니 플로우로 자연스럽게 연결합니다.</p>
        </div>
        <div class="header-actions">
            <a href="<%= contextPath %>/crawler" class="btn btn-secondary">크롤링 실행</a>
            <a href="<%= contextPath %>/shop/products" class="btn btn-primary">쇼핑몰 보기</a>
        </div>
    </header>

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

    <form class="filter-bar" method="get" action="/productBoard">
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
            <a href="/productBoard" class="btn btn-outline">초기화</a>
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
            <a class="chip <%= cat != null && cat.equals(category) ? "active" : "" %>" href="/productBoard?category=<%= cat %>">
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
            <a href="<%= contextPath %>/dbList.jsp" class="btn btn-secondary" style="text-decoration: none;">DB 초기화 가이드</a>
        </div>
        <% } else if (productFeed.isEmpty()) { %>
        <div class="empty">
            <p>📭 조건에 맞는 상품이 없습니다.</p>
            <a href="<%= contextPath %>/shop/products" class="btn btn-secondary" style="text-decoration: none;">쇼핑몰로 이동</a>
        </div>
        <% } else {
            for (Map<String, Object> row : productFeed) {
                Number productId = (Number) row.get("product_id");
                String name = (String) row.get("name");
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
        <a href="/productBoard?page=<%= currentPage - 1 %><%= extraParams %>">이전</a>
        <% } %>
        <span>Page <%= currentPage %> / <%= totalPages %></span>
        <% if (currentPage < totalPages) { %>
        <a href="/productBoard?page=<%= currentPage + 1 %><%= extraParams %>">다음</a>
        <% } %>
    </div>

    <section class="news-log">
        <div class="news-panel">
            <h3> 최신 뉴스</h3>
            <ul>
                <% if (!newsReady) { %>
                <li>news 테이블이 준비되지 않았습니다.</li>
                <% } else if (latestNews.isEmpty()) { %>
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
            <h3>🕒 최근 크롤링 로그</h3>
            <ul>
                <% if (!crawlReady) { %>
                <li>crawl_log 테이블이 준비되지 않았습니다.</li>
                <% } else if (crawlLogs.isEmpty()) { %>
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
