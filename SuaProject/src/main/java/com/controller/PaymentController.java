package com.controller;

import com.dao.CartDAO;
import com.dao.OrderDAO;
import com.model.Order;
import com.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;

@WebServlet("/payment/*")
public class PaymentController extends HttpServlet {

    private OrderDAO orderDAO;
    private CartDAO cartDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.orderDAO = new OrderDAO();
        this.cartDAO = new CartDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();

        if ("/success".equals(pathInfo)) {
            handlePaymentSuccess(request, response);
        } else if ("/fail".equals(pathInfo)) {
            handlePaymentFail(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/index");
        }
    }

    private void handlePaymentSuccess(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        // 토스페이먼츠에서 전달하는 파라미터
        String paymentKey = request.getParameter("paymentKey");
        String orderId = request.getParameter("orderId");
        String amount = request.getParameter("amount");

        System.out.println("✅ 결제 성공 - paymentKey: " + paymentKey + ", orderId: " + orderId + ", amount: " + amount);

        try {
            // 주문 정보 저장
            Order order = new Order();
            order.setUserId(user.getUserId());
            order.setTotalAmount(Integer.parseInt(amount));
            order.setPaymentMethod("toss"); // 토스페이먼츠
            order.setStatus("PAID"); // 결제 완료 상태
            order.setCreatedAt(new Timestamp(System.currentTimeMillis()));

            boolean orderCreated = orderDAO.createOrder(order);

            if (orderCreated) {
                // 장바구니 비우기
                cartDAO.clearCart(user.getUserId());

                System.out.println("✅ 주문 생성 완료 - userId: " + user.getUserId());

                // 성공 페이지로 리다이렉트
                request.setAttribute("orderId", orderId);
                request.setAttribute("amount", amount);
                request.setAttribute("paymentKey", paymentKey);
                request.getRequestDispatcher("/WEB-INF/views/payment/success.jsp").forward(request, response);
            } else {
                throw new Exception("주문 생성 실패");
            }

        } catch (Exception e) {
            System.out.println("❌ 결제 후 주문 생성 실패 - " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/payment/fail?message=" + e.getMessage());
        }
    }

    private void handlePaymentFail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String errorCode = request.getParameter("code");
        String errorMessage = request.getParameter("message");

        System.out.println("❌ 결제 실패 - code: " + errorCode + ", message: " + errorMessage);

        request.setAttribute("errorCode", errorCode);
        request.setAttribute("errorMessage", errorMessage);
        request.getRequestDispatcher("/WEB-INF/views/payment/fail.jsp").forward(request, response);
    }
}
