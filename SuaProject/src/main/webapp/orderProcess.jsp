<%@ page import="com.dao.*" %>
<%@ page import="com.model.*" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    request.setCharacterEncoding("UTF-8");

    // 로그인 체크
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login");
        return;
    }

    Integer userId = (Integer) session.getAttribute("userId");
    String paymentMethod = request.getParameter("paymentMethod");

    if (paymentMethod == null) {
        response.sendRedirect("checkout.jsp");
        return;
    }

    try {
        CartDAO cartDAO = new CartDAO();
        ProductDAO productDAO = new ProductDAO();
        OrderDAO orderDAO = new OrderDAO();

        // 장바구니 조회
        List<Cart> cartItems = cartDAO.getCartByUserId(userId);

        if (cartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // 재고 확인
        for (Cart item : cartItems) {
            if (!productDAO.hasStock(item.getProductId(), item.getQuantity())) {
                response.sendRedirect(
                    request.getContextPath() + "/cart?error=" + java.net.URLEncoder.encode("재고가 부족한 상품이 있습니다.", "UTF-8")
                );
                return;
            }
        }

        // 주문 생성
        int totalAmount = cartDAO.getTotalPrice(userId);

        Order order = new Order();
        order.setUserId(userId);
        order.setTotalAmount(totalAmount);
        order.setPaymentMethod(paymentMethod);
        order.setStatus("PAID");

        boolean orderCreated = orderDAO.createOrder(order);

        if (!orderCreated) {
            throw new Exception("주문 생성 실패");
        }

        int orderId = order.getOrderId();

        // 주문 항목 추가 + 재고 감소
        for (Cart item : cartItems) {

            // 주문 항목 추가
            orderDAO.addOrderItem(
                orderId,
                item.getProductId(),
                item.getQuantity(),
                item.getPrice()
            );

            // 재고 감소
            productDAO.decreaseStock(item.getProductId(), item.getQuantity());
        }

        // 장바구니 비우기
        cartDAO.clearCart(userId);

        // 주문 완료 페이지 이동
        response.sendRedirect("orderComplete.jsp?orderId=" + orderId);

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect(
            "checkout.jsp?error=" +
            java.net.URLEncoder.encode("주문 처리 중 오류가 발생했습니다: " + e.getMessage(), "UTF-8")
        );
    }
%>
