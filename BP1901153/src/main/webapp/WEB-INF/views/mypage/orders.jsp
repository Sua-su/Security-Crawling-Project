<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>주문 내역 - Security Crawling</title>
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/common.css" />
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/shop.css" />
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #F1F1F1;
            color: #2c2c2c;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .page-header {
            background: white;
            padding: 32px;
            border-radius: 20px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.12);
            margin-bottom: 32px;
            border: 1px solid rgba(0,0,0,0.1);
        }

        .page-header h1 {
            font-size: 2rem;
            font-weight: 900;
            background: linear-gradient(135deg, #000000 0%, #444444 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 8px;
        }

        .nav-links {
            display: flex;
            gap: 16px;
            margin-bottom: 24px;
        }

        .nav-links a {
            color: #6B7280;
            text-decoration: none;
            font-weight: 600;
            padding: 8px 16px;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .nav-links a:hover {
            background: linear-gradient(135deg, rgba(0,0,0,0.05) 0%, rgba(100,100,100,0.05) 100%);
            color: #000000;
        }

        .orders-section {
            background: white;
            padding: 28px;
            border-radius: 20px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.12);
            border: 1px solid rgba(0,0,0,0.1);
        }

        .order-card {
            border: 1px solid rgba(0,0,0,0.1);
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 20px;
            transition: all 0.3s ease;
        }

        .order-card:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
            padding-bottom: 16px;
            border-bottom: 1px solid rgba(0,0,0,0.1);
        }

        .order-info {
            display: flex;
            gap: 24px;
            flex-wrap: wrap;
        }

        .order-info-item {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .order-info-label {
            font-size: 0.85rem;
            color: #6B7280;
            font-weight: 600;
        }

        .order-info-value {
            font-size: 1rem;
            color: #2c2c2c;
            font-weight: 700;
        }

        .order-items {
            margin-top: 16px;
        }

        .order-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid rgba(0,0,0,0.05);
        }

        .order-item:last-child {
            border-bottom: none;
        }

        .item-name {
            font-weight: 600;
            color: #2c2c2c;
        }

        .item-details {
            color: #6B7280;
            font-size: 0.9rem;
        }

        .item-price {
            font-weight: 700;
            color: #2c2c2c;
        }

        .badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 999px;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .badge-pending {
            background: linear-gradient(135deg, #F5F5F5 0%, #E8E8E8 100%);
            color: #4A4A4A;
        }

        .badge-processing {
            background: linear-gradient(135deg, #D8D8D8 0%, #C0C0C0 100%);
            color: #2C2C2C;
        }

        .badge-shipped {
            background: linear-gradient(135deg, #B8B8B8 0%, #A0A0A0 100%);
            color: #FFFFFF;
        }

        .badge-delivered {
            background: linear-gradient(135deg, #000000 0%, #333333 100%);
            color: white;
        }

        .badge-cancelled {
            background: linear-gradient(135deg, #505050 0%, #707070 100%);
            color: white;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #6B7280;
        }

        .empty-state h3 {
            font-size: 1.5rem;
            margin-bottom: 12px;
            color: #2c2c2c;
        }

        .btn {
            display: inline-block;
            padding: 12px 24px;
            border-radius: 12px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
        }

        .btn-primary {
            background: linear-gradient(135deg, #000000 0%, #333333 100%);
            color: white;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #1a1a1a 0%, #4a4a4a 100%);
            box-shadow: 0 4px 12px rgba(0,0,0,0.3);
        }

        .btn-secondary {
            background: linear-gradient(135deg, #ffffff 0%, #f8f8f8 100%);
            color: #2c2c2c;
            border: 1px solid #d0d0d0;
        }

        .btn-secondary:hover {
            background: linear-gradient(135deg, #f5f5f5 0%, #e8e8e8 100%);
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="nav-links">
            <a href="<%= contextPath %>/index">홈</a>
            <a href="<%= contextPath %>/products">상품구매</a>
            <a href="<%= contextPath %>/cart">장바구니</a>
        </div>

        <div class="page-header">
            <h1>주문 내역</h1>
            <p>지금까지의 주문 내역을 확인하실 수 있습니다.</p>
        </div>

        <div class="orders-section">
            <c:choose>
                <c:when test="${empty orders}">
                    <div class="empty-state">
                        <h3>주문 내역이 없습니다</h3>
                        <p>아직 주문하신 상품이 없습니다.</p>
                        <br>
                        <a href="<%= contextPath %>/products" class="btn btn-primary">쇼핑 시작하기</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="order" items="${orders}">
                        <div class="order-card">
                            <div class="order-header">
                                <div class="order-info">
                                    <div class="order-info-item">
                                        <span class="order-info-label">주문번호</span>
                                        <span class="order-info-value">#${order.orderId}</span>
                                    </div>
                                    <div class="order-info-item">
                                        <span class="order-info-label">주문일시</span>
                                        <span class="order-info-value">
                                            <fmt:formatDate value="${order.orderDate}" pattern="yyyy-MM-dd HH:mm" />
                                        </span>
                                    </div>
                                    <div class="order-info-item">
                                        <span class="order-info-label">총 금액</span>
                                        <span class="order-info-value">
                                            <fmt:formatNumber value="${order.totalPrice}" pattern="#,###" />원
                                        </span>
                                    </div>
                                </div>
                                <c:choose>
                                    <c:when test="${order.orderStatus == '대기중'}">
                                        <span class="badge badge-pending">대기중</span>
                                    </c:when>
                                    <c:when test="${order.orderStatus == '처리중'}">
                                        <span class="badge badge-processing">처리중</span>
                                    </c:when>
                                    <c:when test="${order.orderStatus == '배송중'}">
                                        <span class="badge badge-shipped">배송중</span>
                                    </c:when>
                                    <c:when test="${order.orderStatus == '배송완료'}">
                                        <span class="badge badge-delivered">배송완료</span>
                                    </c:when>
                                    <c:when test="${order.orderStatus == '취소됨'}">
                                        <span class="badge badge-cancelled">취소됨</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-pending">${order.orderStatus}</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="order-items">
                                <div class="order-item">
                                    <div>
                                        <div class="item-name">${order.productName}</div>
                                        <div class="item-details">수량: ${order.quantity}개</div>
                                    </div>
                                    <div class="item-price">
                                        <fmt:formatNumber value="${order.price}" pattern="#,###" />원
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
