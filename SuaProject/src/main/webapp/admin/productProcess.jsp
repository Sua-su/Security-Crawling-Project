<%@ page import="com.dao.ProductDAO" %>
<%@ page import="com.dao.UserDAO" %>
<%@ page import="com.model.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    request.setCharacterEncoding("UTF-8");
    
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
    
    String action = request.getParameter("action");
    ProductDAO productDAO = new ProductDAO();
    
    try {
        if ("create".equals(action)) {
            // 상품 추가
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            int price = Integer.parseInt(request.getParameter("price"));
            int stock = Integer.parseInt(request.getParameter("stock"));
            String category = request.getParameter("category");
            String filePath = request.getParameter("filePath");
            
            Product product = new Product();
            product.setName(name);
            product.setDescription(description);
            product.setPrice(price);
            product.setStock(stock);
            product.setCategory(category);
            product.setFilePath(filePath != null && !filePath.trim().isEmpty() ? filePath : null);
            
            boolean created = productDAO.createProduct(product);
            
            if (created) {
                response.sendRedirect("products.jsp?message=" + 
                    java.net.URLEncoder.encode("상품이 추가되었습니다.", "UTF-8"));
            } else {
                response.sendRedirect("products.jsp?message=" + 
                    java.net.URLEncoder.encode("상품 추가 실패", "UTF-8"));
            }
            
        } else if ("update".equals(action)) {
            // 상품 수정
            int productId = Integer.parseInt(request.getParameter("productId"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            int price = Integer.parseInt(request.getParameter("price"));
            int stock = Integer.parseInt(request.getParameter("stock"));
            String category = request.getParameter("category");
            String filePath = request.getParameter("filePath");
            
            Product product = productDAO.getProductById(productId);
            product.setName(name);
            product.setDescription(description);
            product.setPrice(price);
            product.setStock(stock);
            product.setCategory(category);
            product.setFilePath(filePath != null && !filePath.trim().isEmpty() ? filePath : null);
            
            boolean updated = productDAO.updateProduct(product);
            
            if (updated) {
                response.sendRedirect("products.jsp?message=" + 
                    java.net.URLEncoder.encode("상품이 수정되었습니다.", "UTF-8"));
            } else {
                response.sendRedirect("products.jsp?message=" + 
                    java.net.URLEncoder.encode("상품 수정 실패", "UTF-8"));
            }
            
        } else if ("delete".equals(action)) {
            // 상품 삭제
            int productId = Integer.parseInt(request.getParameter("productId"));
            boolean deleted = productDAO.deleteProduct(productId);
            
            if (deleted) {
                response.sendRedirect("products.jsp?message=" + 
                    java.net.URLEncoder.encode("상품이 삭제되었습니다.", "UTF-8"));
            } else {
                response.sendRedirect("products.jsp?message=" + 
                    java.net.URLEncoder.encode("상품 삭제 실패 (주문 내역이 있는 상품은 삭제할 수 없습니다)", "UTF-8"));
            }
        }
        
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("products.jsp?message=" + 
            java.net.URLEncoder.encode("오류가 발생했습니다: " + e.getMessage(), "UTF-8"));
    }
%>