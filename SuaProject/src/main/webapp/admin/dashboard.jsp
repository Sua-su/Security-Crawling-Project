<%@ page import="com.dao.*" %>
<%@ page import="com.model.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // 관리자 체크
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login");
        return;
    }

    Integer userId = (Integer) session.getAttribute("userId");

    UserDAO userDAO = new UserDAO();
    User user = userDAO.getUserById(userId);

    if (!user.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    // 통계 DAO
    OrderDAO orderDAO = new OrderDAO();
    ProductDAO productDAO = new ProductDAO();
    BoardDAO boardDAO = new BoardDAO();

    List<User> users = userDAO.getAllUsers();
    List<Order> orders = orderDAO.getAllOrders();
    List<Product> products = productDAO.getAllProducts();

    // 기본 통계
    int totalUsers = users.size();
    int activeUsers = 0;
    for (User u : users) {
        if (u.isActive()) activeUsers++;
    }

    int totalOrders = orders.size();
    int totalRevenue = 0;
    for (Order o : orders) {
        totalRevenue += o.getTotalAmount();
    }

    int totalProducts = products.size();
    int lowStockProducts = 0;
    for (Product p : products) {
        if (p.getStock() < 5) lowStockProducts++;
    }

    // 최근 주문 5개
    List<Order> recentOrders = orders.size() > 5 ? orders.subList(0, 5) : orders;
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>관리자 대시보드 - Security Crawling</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/common.css" />
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/admin.css" />
</head>

<body>
<div class="sidebar">
    <h2>관리자</h2>
    <ul class="sidebar-menu">
        <li><a href="dashboard.jsp" class="active"> 대시보드</a></li>
        <li><a href="products.jsp"> 상품 관리</a></li>
        <li><a href="users.jsp">👥 회원 관리</a></li>
        <li><a href="<%= request.getContextPath() %>/index">메인으로</a></li>
    </ul>
</div>

<div class="main-content">

    <div class="header">
        <h1>관리자 대시보드</h1>
        <div>
            <span style="color:#666;">
                관리자: <strong><%= user.getName() %></strong>
            </span>
        </div>
    </div>

    <!-- 상단 통계 -->
    <div class="stats-grid">
        <div class="stat-card primary">
            <div class="stat-icon">👥</div>
            <div class="stat-label">전체 회원</div>
            <div class="stat-value"><%= totalUsers %></div>
            <div class="stat-detail">활성 회원: <%= activeUsers %>명</div>
        </div>

        <div class="stat-card success">
            <div class="stat-icon"></div>
            <div class="stat-label">총 매출</div>
            <div class="stat-value"><%= String.format("%,d", totalRevenue) %>원</div>
            <div class="stat-detail">총 주문: <%= totalOrders %>건</div>
        </div>

        <div class="stat-card info">
            <div class="stat-icon"></div>
            <div class="stat-label">전체 상품</div>
            <div class="stat-value"><%= totalProducts %></div>
            <div class="stat-detail">재고 부족: <%= lowStockProducts %>개</div>
        </div>
    </div>

    <!-- 게시판 통계 -->
    <div class="stats-grid">

        <div class="stat-card">
            <div class="stat-icon"></div>
            <div class="stat-label">게시글</div>
            <div class="stat-value"><%= boardDAO.getTotalPosts() %></div>
        </div>

        <div class="stat-card">
            <div class="stat-icon">💬</div>
            <div class="stat-label">댓글</div>
            <div class="stat-value">
                <%
                    CommentDAO commentDAO = new CommentDAO();
                    int totalComments = 0;

                    for (Board b : boardDAO.getAllBoards()) {
                        totalComments += commentDAO
                                .getCommentsByBoardId(b.getBoardId()).size();
                    }
                %>
                <%= totalComments %>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon"></div>
            <div class="stat-label">평균 주문 금액</div>
            <div class="stat-value">
                <%= (totalOrders > 0)
                        ? String.format("%,d", totalRevenue / totalOrders)
                        : "0" %>원
            </div>
        </div>
    </div>

    <!-- 최근 주문 -->
    <div class="card">
        <div class="card-title">최근 주문 내역</div>

        <% if (recentOrders.isEmpty()) { %>

            <p style="text-align:center;color:#999;padding:40px;">
                주문 내역이 없습니다.
            </p>

        <% } else { %>

            <table class="order-table">
                <thead>
                <tr>
                    <th>주문번호</th>
                    <th>회원</th>
                    <th>결제금액</th>
                    <th>결제수단</th>
                    <th>상태</th>
                    <th>주문일시</th>
                </tr>
                </thead>

                <tbody>
                <% for (Order order : recentOrders) {
                    User orderUser = userDAO.getUserById(order.getUserId());
                %>
                    <tr>
                        <td><strong>#<%= String.format("%06d", order.getOrderId()) %></strong></td>
                        <td><%= orderUser.getName() %> (<%= orderUser.getUsername() %>)</td>
                        <td><strong style="color:#667eea;">
                                <%= String.format("%,d", order.getTotalAmount()) %>원
                        </strong></td>
                        <td>
                            <%
                                switch (order.getPaymentMethod()) {
                                    case "card": out.print("카드"); break;
                                    case "bank": out.print("계좌"); break;
                                    case "phone": out.print("휴대폰"); break;
                                }
                            %>
                        </td>
                        <td><span class="badge badge-success">결제완료</span></td>
                        <td><%= order.getCreatedAt().toString().substring(0, 16) %></td>
                    </tr>
                <% } %>
                </tbody>
            </table>

        <% } %>
    </div>

    <!-- 재고 부족 상품 -->
    <div class="card">
        <div class="card-title">재고 부족 상품 (<%= lowStockProducts %>개)</div>

        <%
            List<Product> lowStockList = new ArrayList<>();
            for (Product p : products) {
                if (p.getStock() < 5) lowStockList.add(p);
            }

            lowStockList.sort((a, b) -> Integer.compare(a.getStock(), b.getStock()));
        %>

        <% if (lowStockList.isEmpty()) { %>

            <p style="text-align:center;color:#999;padding:40px;">재고 소진</p>

        <% } else { %>

            <table class="order-table">
                <thead>
                <tr>
                    <th>상품명</th>
                    <th>카테고리</th>
                    <th>재고</th>
                    <th>가격</th>
                    <th>관리</th>
                </tr>
                </thead>

                <tbody>
                <% for (Product product : lowStockList) { %>
                <tr>
                    <td><strong><%= product.getName() %></strong></td>
                    <td><%= product.getCategory() %></td>
                    <td>
                        <span class="badge badge-warning"><%= product.getStock() %>개</span>
                    </td>
                    <td><%= String.format("%,d", product.getPrice()) %>원</td>
                    <td>
                        <a href="products.jsp?edit=<%= product.getProductId() %>"
                           class="btn btn-primary">
                            재고 추가
                        </a>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>

        <% } %>
    </div>

</div>
</body>
</html>
