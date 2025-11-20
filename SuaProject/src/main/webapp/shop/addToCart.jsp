<%@ page import="com.dao.CartDAO" %>
<%@ page import="com.model.Cart" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    request.setCharacterEncoding("UTF-8");

    // 로그인 체크
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login");
        return;
    }

    Integer userId = (Integer) session.getAttribute("userId");

    String productIdParam = request.getParameter("productId");
    String quantityParam  = request.getParameter("quantity");
    String returnUrl      = request.getParameter("returnUrl");

    // 상품 ID 체크
    if (productIdParam == null) {
        response.sendRedirect(request.getContextPath() + "/shop/products");
        return;
    }

    int productId = Integer.parseInt(productIdParam);
    int quantity = 1;    // 기본값

    if (quantityParam != null) {
        try {
            quantity = Integer.parseInt(quantityParam);
        } catch (NumberFormatException e) {
            // 수량 값이 잘못되면 기본값 1 유지
        }
    }

    try {
        Cart cart = new Cart();
        cart.setUserId(userId);
        cart.setProductId(productId);
        cart.setQuantity(quantity);

        CartDAO cartDAO = new CartDAO();
        boolean result = cartDAO.addToCart(cart);

        if (result) {
            // 장바구니 추가 성공
            if (returnUrl != null && !returnUrl.trim().isEmpty()) {
                response.sendRedirect(
                    returnUrl + "&message=" +
                    java.net.URLEncoder.encode("장바구니에 추가되었습니다.", "UTF-8")
                );
            } else {
                response.sendRedirect(request.getContextPath() + "/cart");
            }

        } else {
            // 장바구니 추가 실패
            response.sendRedirect(
                request.getContextPath() +
                "/shop/products?error=" +
                java.net.URLEncoder.encode("장바구니 추가에 실패했습니다.", "UTF-8")
            );
        }

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect(
            request.getContextPath() +
            "/shop/products?error=" +
            java.net.URLEncoder.encode("오류가 발생했습니다.", "UTF-8")
        );
    }
%>
