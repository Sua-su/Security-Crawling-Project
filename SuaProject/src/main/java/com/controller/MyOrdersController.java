package com.controller;

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
import java.util.List;

@WebServlet("/mypage/orders")
public class MyOrdersController extends HttpServlet {

    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        int userId = user.getUserId();

        try {
            // 사용자의 주문 내역 조회
            List<Order> orders = orderDAO.getOrdersByUserId(userId);

            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/WEB-INF/views/mypage/orders.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/index?error=" +
                    java.net.URLEncoder.encode("주문 내역을 불러오는 중 오류가 발생했습니다.", "UTF-8"));
        }
    }
}
