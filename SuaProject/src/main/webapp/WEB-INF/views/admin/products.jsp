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
            background: linear-gradient(135deg, #000000 0%, #333333 100%);
            color: white;
            border: none;
            box-shadow: 0 4px 12px rgba(0,0,0,0.3);
        }

        .back-link:hover {
            background: linear-gradient(135deg, #2c2c2c 0%, #1a1a1a 100%);
            color: white;
        }

        .add-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.4);
        }

        .products-table-section {
            background: white;
            padding: 28px;
            border-radius: 20px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.12);
            border: 1px solid rgba(0,0,0,0.1);
        }

        .products-table {
            width: 100%;
            border-collapse: collapse;
        }

        .products-table thead {
            background: linear-gradient(135deg, rgba(0,0,0,0.05) 0%, rgba(100,100,100,0.05) 100%);
        }

        .products-table th {
            padding: 16px;
            text-align: left;
            font-weight: 700;
            color: #374151;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 0.5px;
        }

        .products-table td {
            padding: 16px;
            border-bottom: 1px solid rgba(0,0,0,0.05);
            color: #6B7280;
        }

        .products-table tbody tr:hover {
            background: linear-gradient(135deg, rgba(0,0,0,0.02) 0%, rgba(100,100,100,0.02) 100%);
        }

        .product-img {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 5px;
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

        .badge-active {
            background: linear-gradient(135deg, #000000 0%, #333333 100%);
            color: white;
        }

        .badge-inactive {
            background: linear-gradient(135deg, #E0E0E0 0%, #CACACA 100%);
            color: #6B6B6B;
        }

        .badge-low-stock {
            background: linear-gradient(135deg, #F5F5F5 0%, #E8E8E8 100%);
            color: #4A4A4A;
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

        .btn-edit {
            background: linear-gradient(135deg, #4A4A4A 0%, #2C2C2C 100%);
            color: white;
        }

        .btn-edit:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.3);
        }

        .btn-delete {
            background: linear-gradient(135deg, #6B6B6B 0%, #4A4A4A 100%);
            color: white;
        }

        .btn-delete:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.3);
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
            background: linear-gradient(135deg, #000000 0%, #1a1a1a 100%);
            color: white;
        }

        .btn-update-stock:hover {
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
            <div class="message message-success">상품이 성공적으로 등록되었습니다!</div>
        </c:if>
        <c:if test="${param.message == 'updated'}">
            <div class="message message-success">상품이 성공적으로 수정되었습니다!</div>
        </c:if>
        <c:if test="${param.message == 'deleted'}">
            <div class="message message-success">상품이 성공적으로 삭제되었습니다!</div>
        </c:if>
        <c:if test="${param.message == 'stock_updated'}">
            <div class="message message-success">재고가 성공적으로 업데이트되었습니다!</div>
        </c:if>
        <c:if test="${param.error != null}">
            <div class="message message-error">작업에 실패했습니다. 다시 시도해주세요.</div>
        </c:if>

        <div class="products-table-section">
            <c:choose>
                <c:when test="${not empty products}">
                    <table class="products-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>이미지</th>
                                <th>상품명</th>
                                <th>카테고리</th>
                                <th>가격</th>
                                <th>재고</th>
                                <th>상태</th>
                                <th>작업</th>
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
                                            <button type="submit" class="action-btn btn-update-stock">변경</button>
                                        </form>
                                        <c:if test="${product.stock < 10}">
                                            <span class="badge badge-low-stock">낮은 재고</span>
                                        </c:if>
                                    </td>
                                    <td>
                                        <span class="badge ${product.active ? 'badge-active' : 'badge-inactive'}">
                                            ${product.active ? '활성' : '비활성'}
                                        </span>
                                    </td>
                                    <td>
                                        <div style="display: flex; gap: 8px; align-items: center;">
                                            <a href="${pageContext.request.contextPath}/admin/products?action=edit&productId=${product.productId}" 
                                               class="action-btn btn-edit">수정</a>
                                            <form action="${pageContext.request.contextPath}/admin/products" method="post" style="display: inline; margin: 0;">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="productId" value="${product.productId}">
                                                <button type="submit" class="action-btn btn-delete" 
                                                        onclick="return confirm('이 상품을 삭제하시겠습니까?')">
                                                    삭제
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="no-data">상품이 없습니다</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
