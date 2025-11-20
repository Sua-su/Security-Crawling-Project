<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.dto.ShopProductsData" %>
<%@ page import="com.model.Product" %>
<%
    String contextPath = request.getContextPath();
    ShopProductsData shopData = (ShopProductsData) request.getAttribute("shopData");
    
    List<Product> products = shopData.getProducts();
    String category = shopData.getCategory();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>쇼핑몰 - Security Crawling</title>
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/common.css" />
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/shop.css" />
</head>
<body>
<div class="container">
    <div class="nav-links">
        <a href="<%= contextPath %>/index"> 홈</a>
        <a href="<%= contextPath %>/products"> 상품 게시판</a>
        <a href="<%= contextPath %>/board/list">💬 게시판</a>
        <a href="<%= contextPath %>/cart"> 장바구니</a>
        <a href="<%= contextPath %>/mypage"> 마이페이지</a>
    </div>
    
    <div class="header">
        <h1> 상품구매</h1>
    </div>
    
    <div class="info-box">
        <h3> 크롤링 데이터 상품</h3>
        <p>MLB 뉴스 크롤링 데이터를 ZIP 파일 형태로 판매합니다. 구매하신 데이터는 마이페이지에서 다운로드 가능합니다.</p>
    </div>
    
    <div class="category-filter">
        <a href="<%= contextPath %>/products" 
           class="category-btn <%= (category == null) ? "active" : "" %>">전체</a>
        <a href="<%= contextPath %>/products?category=news" 
           class="category-btn <%= "news".equals(category) ? "active" : "" %>">뉴스 데이터</a>
        <a href="<%= contextPath %>/products?category=analysis" 
           class="category-btn <%= "analysis".equals(category) ? "active" : "" %>">분석 데이터</a>
        <a href="<%= contextPath %>/products?category=report" 
           class="category-btn <%= "report".equals(category) ? "active" : "" %>">리포트</a>
    </div>
    
    <% if (products == null || products.isEmpty()) { %>
    <div class="empty">
        <p style="font-size: 3em;">📭</p>
        <p>등록된 상품이 없습니다.</p>
    </div>
    <% } else { %>
    <div class="products-grid">
        <% for (Product product : products) { 
            boolean hasStock = product.getStock() > 0;
            String stockClass = product.getStock() > 10 ? "stock-available" : 
                               product.getStock() > 0 ? "stock-low" : "stock-out";
        %>
        <div class="product-card">
            <div class="product-icon">
                <% 
                if ("news".equals(product.getCategory())) {
                    out.print("");
                } else if ("analysis".equals(product.getCategory())) {
                    out.print("");
                } else if ("report".equals(product.getCategory())) {
                    out.print("");
                } else {
                    out.print("");
                }
                %>
            </div>
            <div class="product-name"><%= product.getName() %></div>
            <div class="product-description"><%= product.getDescription() %></div>
            <div class="product-price"><%= String.format("%,d", product.getPrice()) %>원</div>
            <div class="product-stock <%= stockClass %>">
                <% if (hasStock) { %>
                재고: <%= product.getStock() %>개
                <% } else { %>
                품절
                <% } %>
            </div>
            <div class="product-actions">
                <a href="<%= contextPath %>/shop/productDetail?id=<%= product.getProductId() %>" 
                   class="btn btn-secondary">상세보기</a>
                <% if (hasStock) { %>
                <form action="<%= contextPath %>/cart" method="post" style="flex: 1; margin: 0;">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="productId" value="<%= product.getProductId() %>">
                    <button type="submit" class="btn btn-primary">장바구니</button>
                </form>
                <% } else { %>
                <button class="btn btn-primary" disabled>품절</button>
                <% } %>
            </div>
        </div>
        <% } %>
    </div>
    <% } %>
</div>
</body>
</html>
