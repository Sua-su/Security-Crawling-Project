<%@ page import="com.dao.*" %>
<%@ page import="com.model.*" %>
<%@ page import="java.util.List" %>
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
    
    ProductDAO productDAO = new ProductDAO();
    List<Product> products = productDAO.getAllProducts();
    
    String editIdParam = request.getParameter("edit");
    Product editProduct = null;
    if (editIdParam != null) {
        editProduct = productDAO.getProductById(Integer.parseInt(editIdParam));
    }
    
    String message = request.getParameter("message");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상품 관리 - Security Crawling</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/common.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css" />
</head>
<body>
<div class="sidebar">
    <h2>👑 관리자</h2>
    <ul class="sidebar-menu">
        <li><a href="dashboard.jsp"> 대시보드</a></li>
        <li><a href="products.jsp" class="active"> 상품 관리</a></li>
        <li><a href="users.jsp">👥 회원 관리</a></li>
        <li><a href="<%= request.getContextPath() %>/index"> 메인으로</a></li>
    </ul>
</div>

<div class="main-content">
    <div class="header">
        <h1> 상품 관리</h1>
        <div>
            <span style="color: #666;">관리자: <strong><%= user.getName() %></strong></span>
        </div>
    </div>
    
    <% if (message != null) { %>
    <div class="alert alert-success">
        <%= message %>
    </div>
    <% } %>
    
    <div class="card">
        <div class="card-title">
            <%= editProduct != null ? "상품 수정" : "새 상품 추가" %>
        </div>
        <form action="productProcess.jsp" method="post">
            <% if (editProduct != null) { %>
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="productId" value="<%= editProduct.getProductId() %>">
            <% } else { %>
            <input type="hidden" name="action" value="create">
            <% } %>
            
            <div class="form-grid">
                <div class="form-group">
                    <label>상품명 *</label>
                    <input type="text" name="name" required 
                           value="<%= editProduct != null ? editProduct.getName() : "" %>">
                </div>
                
                <div class="form-group">
                    <label>카테고리 *</label>
                    <select name="category" required>
                        <option value="news" <%= editProduct != null && "news".equals(editProduct.getCategory()) ? "selected" : "" %>>뉴스</option>
                        <option value="analysis" <%= editProduct != null && "analysis".equals(editProduct.getCategory()) ? "selected" : "" %>>분석</option>
                        <option value="report" <%= editProduct != null && "report".equals(editProduct.getCategory()) ? "selected" : "" %>>리포트</option>
                        <option value="data" <%= editProduct != null && "data".equals(editProduct.getCategory()) ? "selected" : "" %>>데이터</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label>가격 *</label>
                    <input type="number" name="price" required min="0" 
                           value="<%= editProduct != null ? editProduct.getPrice() : "1000" %>">
                </div>
                
                <div class="form-group">
                    <label>재고 *</label>
                    <input type="number" name="stock" required min="0" 
                           value="<%= editProduct != null ? editProduct.getStock() : "10" %>">
                </div>
                
                <div class="form-group full">
                    <label>설명</label>
                    <textarea name="description"><%= editProduct != null ? editProduct.getDescription() : "" %></textarea>
                </div>
                
                <div class="form-group full">
                    <label>파일 경로</label>
                    <input type="text" name="filePath" 
                           value="<%= editProduct != null ? (editProduct.getFilePath() != null ? editProduct.getFilePath() : "") : "" %>"
                           placeholder="/data/files/product.zip">
                </div>
            </div>
            
            <div class="btn-group">
                <button type="submit" class="btn btn-primary">
                    <%= editProduct != null ? "수정하기" : "추가하기" %>
                </button>
                <% if (editProduct != null) { %>
                <a href="products.jsp" class="btn btn-secondary">취소</a>
                <% } %>
            </div>
        </form>
    </div>
    
    <div class="card">
        <div class="card-title">전체 상품 목록 (<%= products.size() %>개)</div>
        <table class="product-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>상품명</th>
                    <th>카테고리</th>
                    <th>가격</th>
                    <th>재고</th>
                    <th>등록일</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody>
                <% for (Product product : products) { %>
                <tr>
                    <td><%= product.getProductId() %></td>
                    <td><strong><%= product.getName() %></strong></td>
                    <td><%= product.getCategory() %></td>
                    <td><%= String.format("%,d", product.getPrice()) %>원</td>
                    <td>
                        <% if (product.getStock() == 0) { %>
                        <span class="badge badge-danger">품절</span>
                        <% } else if (product.getStock() < 5) { %>
                        <span class="badge badge-warning"><%= product.getStock() %>개</span>
                        <% } else { %>
                        <span class="badge badge-success"><%= product.getStock() %>개</span>
                        <% } %>
                    </td>
                    <td><%= product.getCreatedAt().toString().substring(0, 10) %></td>
                    <td>
                        <div class="btn-group">
                            <a href="products.jsp?edit=<%= product.getProductId() %>" 
                               class="btn btn-primary" style="padding: 8px 15px;">수정</a>
                            <a href="productProcess.jsp?action=delete&productId=<%= product.getProductId() %>" 
                               class="btn btn-danger" style="padding: 8px 15px;"
                               onclick="return confirm('정말 삭제하시겠습니까?')">삭제</a>
                        </div>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
