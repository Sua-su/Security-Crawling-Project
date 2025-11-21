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
    <title>상품 관리 - Admin</title>
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

        .header-actions {
            display: flex;
            gap: 10px;
        }

        .back-link,
        .add-btn {
            color: #3498db;
            text-decoration: none;
            font-size: 14px;
            padding: 8px 16px;
            border: 1px solid #3498db;
            border-radius: 5px;
            transition: all 0.3s;
            display: inline-block;
            background: white;
            cursor: pointer;
        }

        .add-btn {
            background: #27ae60;
            color: white;
            border-color: #27ae60;
        }

        .back-link:hover {
            background: #3498db;
            color: white;
        }

        .add-btn:hover {
            background: #229954;
        }

        .products-table-section {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .products-table {
            width: 100%;
            border-collapse: collapse;
        }

        .products-table thead {
            background: #34495e;
            color: white;
        }

        .products-table th,
        .products-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ecf0f1;
        }

        .products-table tbody tr:hover {
            background: #f8f9fa;
        }

        .product-img {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 5px;
        }

        .badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }

        .badge-active {
            background: #d4edda;
            color: #155724;
        }

        .badge-inactive {
            background: #f8d7da;
            color: #721c24;
        }

        .badge-low-stock {
            background: #fff3cd;
            color: #856404;
        }

        .action-btn {
            padding: 5px 10px;
            margin: 0 2px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            transition: all 0.3s;
        }

        .btn-edit {
            background: #3498db;
            color: white;
        }

        .btn-edit:hover {
            background: #2980b9;
        }

        .btn-delete {
            background: #e74c3c;
            color: white;
        }

        .btn-delete:hover {
            background: #c0392b;
        }

        .stock-form {
            display: inline-flex;
            gap: 5px;
            align-items: center;
        }

        .stock-input {
            width: 60px;
            padding: 5px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 12px;
        }

        .btn-update-stock {
            background: #f39c12;
            color: white;
        }

        .btn-update-stock:hover {
            background: #e67e22;
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
    </style>
</head>
<body>
<div class="admin-container">
    <!-- Header -->
    <div class="admin-header">
        <h1>상품 관리</h1>
        <div class="admin-nav">
            <a href="<%= contextPath %>/admin/dashboard">대시보드</a>
            <a href="<%= contextPath %>/admin/users">회원 관리</a>
            <a href="<%= contextPath %>/admin/orders">주문 관리</a>
            <a href="<%= contextPath %>/admin/products" class="active">상품 관리</a>
            <a href="<%= contextPath %>/admin/crawl">크롤링 관리</a>
            <a href="<%= contextPath %>/index">메인으로</a>
        </div>
    </div>
    
    <!-- Keep the add-btn action separately -->
    <div class="page-actions">
        <a href="<%= contextPath %>/admin/products?action=create" class="add-btn">+ 상품 추가</a>
    </div>

        <c:if test="${param.message == 'created'}">
            <div class="message message-success">Product created successfully!</div>
        </c:if>
        <c:if test="${param.message == 'updated'}">
            <div class="message message-success">Product updated successfully!</div>
        </c:if>
        <c:if test="${param.message == 'deleted'}">
            <div class="message message-success">Product deleted successfully!</div>
        </c:if>
        <c:if test="${param.message == 'stock_updated'}">
            <div class="message message-success">Stock updated successfully!</div>
        </c:if>
        <c:if test="${param.error != null}">
            <div class="message message-error">Operation failed. Please try again.</div>
        </c:if>

        <div class="products-table-section">
            <c:choose>
                <c:when test="${not empty products}">
                    <table class="products-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Image</th>
                                <th>Name</th>
                                <th>Category</th>
                                <th>Price</th>
                                <th>Stock</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${products}" var="product">
                                <tr>
                                    <td>${product.productId}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty product.imageUrl}">
                                                <img src="${product.imageUrl}" alt="${product.productName}" class="product-img">
                                            </c:when>
                                            <c:otherwise>
                                                <div style="width: 50px; height: 50px; background: #ddd; border-radius: 5px;"></div>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${product.productName}</td>
                                    <td>${product.category}</td>
                                    <td><fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₩"/></td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/admin/products" method="post" class="stock-form">
                                            <input type="hidden" name="action" value="updateStock">
                                            <input type="hidden" name="productId" value="${product.productId}">
                                            <input type="number" name="stock" value="${product.stock}" 
                                                   class="stock-input" min="0">
                                            <button type="submit" class="action-btn btn-update-stock">Update</button>
                                        </form>
                                        <c:if test="${product.stock < 10}">
                                            <span class="badge badge-low-stock">Low Stock</span>
                                        </c:if>
                                    </td>
                                    <td>
                                        <span class="badge ${product.active ? 'badge-active' : 'badge-inactive'}">
                                            ${product.active ? 'Active' : 'Inactive'}
                                        </span>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/products?action=edit&productId=${product.productId}" 
                                           class="action-btn btn-edit">Edit</a>
                                        <form action="${pageContext.request.contextPath}/admin/products" method="post" style="display: inline;">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="productId" value="${product.productId}">
                                            <button type="submit" class="action-btn btn-delete" 
                                                    onclick="return confirm('Are you sure you want to delete this product?')">
                                                Delete
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="no-data">No products found</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
