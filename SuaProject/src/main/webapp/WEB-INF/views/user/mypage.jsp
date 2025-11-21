<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.dto.MyPageData" %>
<%@ page import="com.model.*" %>
<%@ page import="com.dao.*" %>
<%
    String contextPath = request.getContextPath();
    MyPageData data = (MyPageData) request.getAttribute("myPageData");
    
    User user = data.getUser();
    List<Order> orders = data.getOrders();
    String activeTab = data.getActiveTab();
    int totalSpent = data.getTotalSpent();
    int completedOrders = data.getCompletedOrderCount();
    
    OrderDAO orderDAO = new OrderDAO();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지 - Security Crawling</title>
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/common.css" />
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/mypage.css" />
</head>
<body>
<div class="container">
    <div class="nav-links">
        <a href="<%= contextPath %>/index"> 홈</a>
        <a href="<%= contextPath %>/products"> 상품 게시판</a>
        <a href="<%= contextPath %>/board/list">게시판</a>
        <a href="<%= contextPath %>/products"> 상품구매</a>
        <a href="<%= contextPath %>/cart"> 장바구니</a>
    </div>
    
    <div class="header">
        <h1> 마이페이지</h1>
    </div>
    
    <div class="tabs">
        <button class="tab <%= "info".equals(activeTab) ? "active" : "" %>" 
                onclick="location.href='?tab=info'">내 정보</button>
        <button class="tab <%= "orders".equals(activeTab) ? "active" : "" %>" 
                onclick="location.href='?tab=orders'">주문내역</button>
    </div>
    
    <!-- 내 정보 탭 -->
    <div class="tab-content <%= "info".equals(activeTab) ? "active" : "" %>">
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number"><%= orders.size() %></div>
                <div class="stat-label">총 주문</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><%= String.format("%,d", totalSpent) %>원</div>
                <div class="stat-label">총 구매금액</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><%= completedOrders %></div>
                <div class="stat-label">완료된 주문</div>
            </div>
        </div>
        
        <div class="info-grid">
            <div class="info-card">
                <div class="info-label">이름</div>
                <div class="info-value"><%= user.getName() %></div>
            </div>
            <div class="info-card">
                <div class="info-label">아이디</div>
                <div class="info-value"><%= user.getUsername() %></div>
            </div>
            <div class="info-card">
                <div class="info-label">이메일</div>
                <div class="info-value"><%= user.getEmail() %></div>
            </div>
            <div class="info-card">
                <div class="info-label">가입일</div>
                <div class="info-value"><%= user.getCreatedAt().toString().substring(0, 10) %></div>
            </div>
            <div class="info-card">
                <div class="info-label">회원등급</div>
                <div class="info-value">
                    <%= user.isAdmin() ? "관리자" : "일반회원" %>
                </div>
            </div>
            <div class="info-card">
                <div class="info-label">계정상태</div>
                <div class="info-value">
                    <% if (user.isActive()) { %>
                        <span style="color: #28a745;"> 활성</span>
                    <% } else { %>
                        <span style="color: #dc3545;">비활성</span>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 주문내역 탭 -->
    <div class="tab-content <%= "orders".equals(activeTab) ? "active" : "" %>">
        <% if (orders.isEmpty()) { %>
        <div class="empty">
            <p style="font-size: 3em;"></p>
            <p style="font-size: 1.2em; margin-bottom: 20px;">주문 내역이 없습니다.</p>
            <a href="<%= contextPath %>/products" class="btn btn-primary">
                쇼핑하러 가기
            </a>
        </div>
        <% } else { %>
        <div class="order-list">
            <% 
            for (Order order : orders) {
                List<OrderItem> items = orderDAO.getOrderItems(order.getOrderId());
            %>
            <div class="order-card">
                <div class="order-header">
                    <div>
                        <div class="order-number">주문 #<%= String.format("%06d", order.getOrderId()) %></div>
                        <div class="order-date"><%= order.getCreatedAt().toString().substring(0, 16) %></div>
                    </div>
                    <span class="order-status status-paid">결제완료</span>
                </div>
                <div class="order-info">
                    <div class="order-detail">
                        <div class="detail-label">상품수</div>
                        <div class="detail-value"><%= items.size() %>개</div>
                    </div>
                    <div class="order-detail">
                        <div class="detail-label">결제수단</div>
                        <div class="detail-value">
                            <% 
                            String method = order.getPaymentMethod();
                            if ("card".equals(method)) out.print(" 카드");
                            else if ("bank".equals(method)) out.print(" 계좌");
                            else if ("phone".equals(method)) out.print(" 휴대폰");
                            else out.print(method);
                            %>
                        </div>
                    </div>
                    <div class="order-detail">
                        <div class="detail-label">결제금액</div>
                        <div class="detail-value" style="color: #000000;">
                            <%= String.format("%,d", order.getTotalAmount()) %>원
                        </div>
                    </div>
                </div>
                <div style="margin-top: 20px; padding-top: 20px; border-top: 1px solid #eee;">
                    <% for (OrderItem item : items) { %>
                    <div style="display: flex; justify-content: space-between; margin-bottom: 10px;">
                        <span style="color: #666;">
                            <%= item.getProductName() %> (x<%= item.getQuantity() %>)
                        </span>
                        <span style="color: #000000; font-weight: bold;">
                            <%= String.format("%,d", item.getTotalPrice()) %>원
                        </span>
                    </div>
                    <% } %>
                </div>
            </div>
            <% } %>
        </div>
        <% } %>
    </div>
</div>
</body>
</html>
