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
            background: #f5f6fa;
            color: #2c3e50;
        }

        .admin-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
        }

        .admin-header {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .admin-header h1 {
            color: #2c3e50;
            font-size: 28px;
        }

        .back-link {
            color: #3498db;
            text-decoration: none;
            font-size: 14px;
            padding: 8px 16px;
            border: 1px solid #3498db;
            border-radius: 5px;
            transition: all 0.3s;
        }

        .back-link:hover {
            background: #3498db;
            color: white;
        }

        .filter-section {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        .filter-buttons {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .filter-btn {
            padding: 10px 20px;
            border: 1px solid #ddd;
            background: white;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            color: #2c3e50;
        }

        .filter-btn:hover,
        .filter-btn.active {
            background: #3498db;
            color: white;
            border-color: #3498db;
        }

        .orders-table-section {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .orders-table {
            width: 100%;
            border-collapse: collapse;
        }

        .orders-table thead {
            background: #34495e;
            color: white;
        }

        .orders-table th,
        .orders-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ecf0f1;
        }

        .orders-table tbody tr:hover {
            background: #f8f9fa;
        }

        .badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }

        .badge-pending {
            background: #fff3cd;
            color: #856404;
        }

        .badge-processing {
            background: #cce5ff;
            color: #004085;
        }

        .badge-shipped {
            background: #d1ecf1;
            color: #0c5460;
        }

        .badge-delivered {
            background: #d4edda;
            color: #155724;
        }

        .badge-cancelled {
            background: #f8d7da;
            color: #721c24;
        }

        .action-btn {
            padding: 5px 10px;
            margin: 0 2px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }

        .btn-view {
            background: #3498db;
            color: white;
        }

        .btn-view:hover {
            background: #2980b9;
        }

        .btn-update {
            background: #27ae60;
            color: white;
        }

        .btn-update:hover {
            background: #229954;
        }

        .message {
            padding: 10px 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }

        .message-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .message-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .no-data {
            text-align: center;
            padding: 40px;
            color: #7f8c8d;
        }

        .status-form {
            display: inline-flex;
            gap: 5px;
            align-items: center;
        }

        .status-select {
            padding: 5px 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 12px;
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
            <div class="message message-success">Order status updated successfully!</div>
        </c:if>
        <c:if test="${param.error == 'update_failed'}">
            <div class="message message-error">Failed to update order status. Please try again.</div>
        </c:if>

        <div class="filter-section">
            <div class="filter-buttons">
                <a href="${pageContext.request.contextPath}/admin/orders" 
                   class="filter-btn ${empty param.status ? 'active' : ''}">All Orders</a>
                <a href="${pageContext.request.contextPath}/admin/orders?status=PENDING" 
                   class="filter-btn ${param.status == 'PENDING' ? 'active' : ''}">Pending</a>
                <a href="${pageContext.request.contextPath}/admin/orders?status=PROCESSING" 
                   class="filter-btn ${param.status == 'PROCESSING' ? 'active' : ''}">Processing</a>
                <a href="${pageContext.request.contextPath}/admin/orders?status=SHIPPED" 
                   class="filter-btn ${param.status == 'SHIPPED' ? 'active' : ''}">Shipped</a>
                <a href="${pageContext.request.contextPath}/admin/orders?status=DELIVERED" 
                   class="filter-btn ${param.status == 'DELIVERED' ? 'active' : ''}">Delivered</a>
                <a href="${pageContext.request.contextPath}/admin/orders?status=CANCELLED" 
                   class="filter-btn ${param.status == 'CANCELLED' ? 'active' : ''}">Cancelled</a>
            </div>
        </div>

        <div class="orders-table-section">
            <c:choose>
                <c:when test="${not empty orders}">
                    <table class="orders-table">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>User</th>
                                <th>Total Amount</th>
                                <th>Status</th>
                                <th>Payment</th>
                                <th>Shipping</th>
                                <th>Order Date</th>
                                <th>Actions</th>
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
                                                <option value="PENDING" ${order.status == 'PENDING' ? 'selected' : ''}>Pending</option>
                                                <option value="PROCESSING" ${order.status == 'PROCESSING' ? 'selected' : ''}>Processing</option>
                                                <option value="SHIPPED" ${order.status == 'SHIPPED' ? 'selected' : ''}>Shipped</option>
                                                <option value="DELIVERED" ${order.status == 'DELIVERED' ? 'selected' : ''}>Delivered</option>
                                                <option value="CANCELLED" ${order.status == 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
                                            </select>
                                            <button type="submit" class="action-btn btn-update">Update</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="no-data">No orders found</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
