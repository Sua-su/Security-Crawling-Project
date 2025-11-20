package com.controller;

import com.dao.OrderDAO;
import com.dao.ProductDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/shop/directOrderProcess")
public class DirectOrderProcessController extends HttpServlet {

    private OrderDAO orderDAO;
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.orderDAO = new OrderDAO();
        this.productDAO = new ProductDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        try {
            Integer userId = (Integer) session.getAttribute("userId");
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String paymentMethod = request.getParameter("paymentMethod");

            // 상품 가격 조회
            com.model.Product product = productDAO.getProductById(productId);
            if (product == null) {
                throw new Exception("상품을 찾을 수 없습니다.");
            }

            int price = product.getPrice();
            int totalAmount = price * quantity;

            // 주문 생성
            com.model.Order order = new com.model.Order();
            order.setUserId(userId);
            order.setTotalAmount(totalAmount);
            order.setPaymentMethod(paymentMethod);
            order.setStatus("결제완료");

            boolean orderCreated = orderDAO.createOrder(order);

            if (orderCreated && order.getOrderId() > 0) {
                int orderId = order.getOrderId();

                // 주문 아이템 추가
                boolean itemAdded = orderDAO.addOrderItem(orderId, productId, quantity, price);

                if (itemAdded) {
                    // 재고 감소
                    productDAO.decreaseStock(productId, quantity);

                    // 주문 완료 페이지로 리다이렉트
                    response.sendRedirect(request.getContextPath() + "/orderComplete?orderId=" + orderId);
                } else {
                    throw new Exception("주문 항목 추가 실패");
                }
            } else {
                throw new Exception("주문 생성 실패");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "주문 처리 중 오류가 발생했습니다: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/products");
    }
}
