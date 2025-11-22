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
    <title>주문 관리 - Admin</title>
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/common.css" />
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/admin.css" />
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

        .admin-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
        }

        .admin-header {
            background: white;
            padding: 24px 32px;
            border-radius: 20px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.12);
            margin-bottom: 32px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border: 1px solid rgba(0,0,0,0.1);
        }

        .admin-header h1 {
            font-size: 2rem;
            font-weight: 900;
            background: linear-gradient(135deg, #000000 0%, #444444 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .filter-section {
            background: white;
            padding: 24px;
            border-radius: 20px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.12);
            margin-bottom: 32px;
            border: 1px solid rgba(0,0,0,0.1);
        }

        .filter-buttons {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        .filter-btn {
            padding: 10px 20px;
            border: 1px solid #d0d0d0;
            background: white;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            color: #6B7280;
            font-weight: 600;
        }

        .filter-btn:hover {
            background: linear-gradient(135deg, rgba(0,0,0,0.05) 0%, rgba(100,100,100,0.05) 100%);
            color: #000000;
        }

        .filter-btn.active {
            background: linear-gradient(135deg, #000000 0%, #333333 100%);
            color: white;
            border-color: transparent;
        }

        .orders-table-section {
            background: white;
            padding: 28px;
            border-radius: 20px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.12);
            border: 1px solid rgba(0,0,0,0.1);
        }

        .orders-table {
            width: 100%;
            border-collapse: collapse;
        }

        .orders-table thead {
            background: linear-gradient(135deg, rgba(0,0,0,0.05) 0%, rgba(100,100,100,0.05) 100%);
        }

        .orders-table th {
            padding: 16px;
            text-align: left;
            font-weight: 700;
            color: #374151;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 0.5px;
        }

        .orders-table td {
            padding: 16px;
            border-bottom: 1px solid rgba(0,0,0,0.05);
            color: #6B7280;
        }

        .orders-table tbody tr:hover {
            background: linear-gradient(135deg, rgba(0,0,0,0.02) 0%, rgba(100,100,100,0.02) 100%);
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
            background: linear-gradient(135deg, #BEBEBE 0%, #A0A0A0 100%);
            color: white;
        }

        .badge-delivered {
            background: linear-gradient(135deg, #000000 0%, #333333 100%);
            color: white;
        }

        .badge-cancelled {
            background: linear-gradient(135deg, #E0E0E0 0%, #CACACA 100%);
            color: #6B6B6B;
        }

        .action-btn {
            padding: 8px 16px;
            margin: 0 4px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 12px;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .btn-view {
            background: linear-gradient(135deg, #4A4A4A 0%, #2C2C2C 100%);
            color: white;
        }

        .btn-view:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.3);
        }

        .btn-update {
            background: linear-gradient(135deg, #000000 0%, #1a1a1a 100%);
            color: white;
        }

        .btn-update:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.4);
        }

        .message {
            padding: 12px 16px;
            border-radius: 12px;
            margin-bottom: 24px;
            font-weight: 600;
        }

        .message-success {
            background: #F0F0F0;
            color: #1a1a1a;
            border-left: 4px solid #000000;
        }

        .message-error {
            background: #F5F5F5;
            color: #4A4A4A;
            border-left: 4px solid #6B6B6B;
        }

        .no-data {
            text-align: center;
            padding: 60px;
            color: #9CA3AF;
            font-size: 1.1rem;
        }

        .status-form {
            display: inline-flex;
            gap: 8px;
            align-items: center;
        }

        .status-select {
            padding: 8px 12px;
            border: 1px solid #d0d0d0;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .status-select:focus {
            outline: none;
            border-color: #2c2c2c;
            box-shadow: 0 0 0 3px rgba(44,44,44,0.1);
        }
    </style>
</head>
<body>
<div class="admin-container">
    <!-- Header -->
    <div class="admin-header">
        <h1>주문 관리</h1>
        <div class="admin-nav">
            <a href="<%= contextPath %>/admin/dashboard">대시보드</a>
            <a href="<%= contextPath %>/admin/users">회원 관리</a>
            <a href="<%= contextPath %>/admin/orders" class="active">주문 관리</a>
            <a href="<%= contextPath %>/admin/products">상품 관리</a>
            <a href="<%= contextPath %>/admin/crawl">크롤링 관리</a>
            <a href="<%= contextPath %>/index">메인으로</a>
        </div>
    </div>

        <c:if test="${param.message == 'status_updated'}">
            <div class="message message-success">주문 상태가 성공적으로 업데이트되었습니다!</div>
        </c:if>
        <c:if test="${param.error == 'update_failed'}">
            <div class="message message-error">주문 상태 업데이트에 실패했습니다. 다시 시도해주세요.</div>
        </c:if>

        <div class="filter-section">
            <div class="filter-buttons">
                <a href="${pageContext.request.contextPath}/admin/orders" 
                   class="filter-btn ${empty param.status ? 'active' : ''}">전체 주문</a>
                <a href="${pageContext.request.contextPath}/admin/orders?status=PENDING" 
                   class="filter-btn ${param.status == 'PENDING' ? 'active' : ''}">대기중</a>
                <a href="${pageContext.request.contextPath}/admin/orders?status=PROCESSING" 
                   class="filter-btn ${param.status == 'PROCESSING' ? 'active' : ''}">처리중</a>
                <a href="${pageContext.request.contextPath}/admin/orders?status=SHIPPED" 
                   class="filter-btn ${param.status == 'SHIPPED' ? 'active' : ''}">배송중</a>
                <a href="${pageContext.request.contextPath}/admin/orders?status=DELIVERED" 
                   class="filter-btn ${param.status == 'DELIVERED' ? 'active' : ''}">배송완료</a>
                <a href="${pageContext.request.contextPath}/admin/orders?status=CANCELLED" 
                   class="filter-btn ${param.status == 'CANCELLED' ? 'active' : ''}">취소됨</a>
            </div>
        </div>

        <div class="orders-table-section">
            <c:choose>
                <c:when test="${not empty orders}">
                    <table class="orders-table">
                        <thead>
                            <tr>
                                <th>주문번호</th>
                                <th>회원</th>
                                <th>총 금액</th>
                                <th>상태</th>
                                <th>결제방법</th>
                                <th>배송지</th>
                                <th>주문일</th>
                                <th>작업</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${orders}" var="order">
                                <tr>
                                    <td>#${order.orderId}</td>
                                    <td>${order.userId}</td>
                                    <td><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₩"/></td>
                                    <td>
                                        <span class="badge badge-${order.status.toLowerCase()}">
                                            ${order.status}
                                        </span>
                                    </td>
                                    <td>${order.paymentMethod}</td>
                                    <td>${order.shippingAddress}</td>
                                    <td><fmt:formatDate value="${order.createdAt}" pattern="yyyy-MM-dd HH:mm"/></td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/admin/orders" method="post" class="status-form">
                                            <input type="hidden" name="action" value="updateStatus">
                                            <input type="hidden" name="orderId" value="${order.orderId}">
                                            <select name="status" class="status-select">
                                                <option value="PENDING" ${order.status == 'PENDING' ? 'selected' : ''}>대기중</option>
                                                <option value="PROCESSING" ${order.status == 'PROCESSING' ? 'selected' : ''}>처리중</option>
                                                <option value="SHIPPED" ${order.status == 'SHIPPED' ? 'selected' : ''}>배송중</option>
                                                <option value="DELIVERED" ${order.status == 'DELIVERED' ? 'selected' : ''}>배송완료</option>
                                                <option value="CANCELLED" ${order.status == 'CANCELLED' ? 'selected' : ''}>취소됨</option>
                                            </select>
                                            <button type="submit" class="action-btn btn-update">변경</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="no-data">주문이 없습니다</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
