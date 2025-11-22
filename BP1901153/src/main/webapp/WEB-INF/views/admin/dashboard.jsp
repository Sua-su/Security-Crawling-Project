<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.NumberFormat" %>
<%
    String contextPath = request.getContextPath();
    Map<String, Object> stats = (Map<String, Object>) request.getAttribute("stats");
    List<Map<String, Object>> monthlyRevenue = (List<Map<String, Object>>) request.getAttribute("monthlyRevenue");
    List<Map<String, Object>> categoryStats = (List<Map<String, Object>>) request.getAttribute("categoryStats");
    
    NumberFormat currencyFormat = NumberFormat.getInstance();
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>어드민 대시보드 - Security Crawling</title>
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/common.css" />
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/admin.css" />
</head>
<body>
<div class="admin-container">
    <!-- Header -->
    <div class="admin-header">
        <h1>어드민 대시보드</h1>
        <div class="admin-nav">
            <a href="<%= contextPath %>/admin/dashboard" class="active">대시보드</a>
            <a href="<%= contextPath %>/admin/users">회원 관리</a>
            <a href="<%= contextPath %>/admin/orders">주문 관리</a>
            <a href="<%= contextPath %>/admin/products">상품 관리</a>
            <a href="<%= contextPath %>/admin/crawl">크롤링 관리</a>
            <a href="<%= contextPath %>/index">메인으로</a>
        </div>
    </div>
    
    <!-- Stats Grid -->
    <div class="stats-grid">
        <div class="stat-card">
            <h3>전체 회원</h3>
            <p class="value"><%= stats.get("totalUsers") %></p>
            <p class="sub">활성: <%= stats.get("activeUsers") %> / 신규(오늘): <%= stats.get("newUsersToday") %></p>
        </div>
        
        <div class="stat-card">
            <h3>전체 주문</h3>
            <p class="value"><%= stats.get("totalOrders") %></p>
            <p class="sub">대기: <%= stats.get("pendingOrders") %> / 완료: <%= stats.get("completedOrders") %></p>
        </div>
        
        <div class="stat-card">
            <h3>총 매출</h3>
            <p class="value"><%= currencyFormat.format(stats.get("totalRevenue")) %>원</p>
            <p class="sub">오늘: <%= currencyFormat.format(stats.get("todayRevenue")) %>원</p>
        </div>
        
        <div class="stat-card">
            <h3>상품</h3>
            <p class="value"><%= stats.get("totalProducts") %></p>
            <p class="sub">활성: <%= stats.get("activeProducts") %> / 재고부족: <%= stats.get("lowStockProducts") %></p>
        </div>
        
        <div class="stat-card">
            <h3>뉴스 데이터</h3>
            <p class="value"><%= stats.get("totalNews") %></p>
            <p class="sub">오늘: <%= stats.get("todayNews") %> / 언론사: <%= stats.get("companyCount") %></p>
        </div>
        
        <div class="stat-card">
            <h3>관리자</h3>
            <p class="value"><%= stats.get("adminCount") %></p>
            <p class="sub">전체 회원 중</p>
        </div>
    </div>
    
    <!-- Charts -->
    <div class="charts-grid">
        <div class="chart-card">
            <h3>월별 매출 통계</h3>
            <% if (monthlyRevenue != null && !monthlyRevenue.isEmpty()) { %>
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>월</th>
                        <th>주문 수</th>
                        <th>매출액</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Map<String, Object> row : monthlyRevenue) { %>
                    <tr>
                        <td><%= row.get("month") %></td>
                        <td><%= row.get("order_count") %>건</td>
                        <td><%= currencyFormat.format(row.get("revenue")) %>원</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            <% } else { %>
            <p style="padding: 20px; text-align: center; color: #999;">데이터가 없습니다.</p>
            <% } %>
        </div>
        
        <div class="chart-card">
            <h3>카테고리별 상품 현황</h3>
            <% if (categoryStats != null && !categoryStats.isEmpty()) { %>
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>카테고리</th>
                        <th>상품 수</th>
                        <th>총 재고</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Map<String, Object> row : categoryStats) { %>
                    <tr>
                        <td><%= row.get("category") %></td>
                        <td><%= row.get("count") %>개</td>
                        <td><%= row.get("total_stock") %>개</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            <% } else { %>
            <p style="padding: 20px; text-align: center; color: #999;">데이터가 없습니다.</p>
            <% } %>
        </div>
    </div>
    
    <!-- Recent Activity -->
    <div class="admin-table-container">
        <div class="table-header">
            <h2>최근 주문</h2>
            <a href="<%= contextPath %>/admin/orders" class="view-all-link">전체 보기 →</a>
        </div>
        <%
            List<Map<String, Object>> recentOrders = (List<Map<String, Object>>) stats.get("recentOrders");
            if (recentOrders != null && !recentOrders.isEmpty()) {
        %>
        <table class="admin-table">
            <thead>
                <tr>
                    <th>주문번호</th>
                    <th>회원</th>
                    <th>금액</th>
                    <th>상태</th>
                    <th>주문일시</th>
                </tr>
            </thead>
            <tbody>
                <% for (Map<String, Object> order : recentOrders) { %>
                <tr>
                    <td>#<%= order.get("order_id") %></td>
                    <td><%= order.get("username") %></td>
                    <td><%= currencyFormat.format(order.get("total_amount")) %>원</td>
                    <td>
                        <span class="badge badge-<%= "COMPLETED".equals(order.get("status")) ? "completed" : "pending" %>">
                            <%= order.get("status") %>
                        </span>
                    </td>
                    <td><%= dateFormat.format(order.get("created_at")) %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <% } else { %>
        <p style="padding: 40px; text-align: center; color: #999;">최근 주문이 없습니다.</p>
        <% } %>
    </div>
    
    <div class="admin-table-container">
        <div class="table-header">
            <h2>최근 가입 회원</h2>
            <a href="<%= contextPath %>/admin/users" class="view-all-link">전체 보기 →</a>
        </div>
        <%
            List<Map<String, Object>> recentUsers = (List<Map<String, Object>>) stats.get("recentUsers");
            if (recentUsers != null && !recentUsers.isEmpty()) {
        %>
        <table class="admin-table">
            <thead>
                <tr>
                    <th>회원번호</th>
                    <th>아이디</th>
                    <th>이름</th>
                    <th>이메일</th>
                    <th>권한</th>
                    <th>가입일시</th>
                </tr>
            </thead>
            <tbody>
                <% for (Map<String, Object> user : recentUsers) { %>
                <tr>
                    <td>#<%= user.get("user_id") %></td>
                    <td><%= user.get("username") %></td>
                    <td><%= user.get("name") %></td>
                    <td><%= user.get("email") %></td>
                    <td>
                        <span class="badge badge-<%= "ADMIN".equals(user.get("role")) ? "admin" : "user" %>">
                            <%= user.get("role") %>
                        </span>
                    </td>
                    <td><%= dateFormat.format(user.get("created_at")) %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <% } else { %>
        <p style="padding: 40px; text-align: center; color: #999;">최근 가입 회원이 없습니다.</p>
        <% } %>
    </div>
</div>
</body>
</html>
