package com.controller;

import com.dto.CheckoutData;
import com.service.CheckoutService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/checkout")
public class CheckoutController extends HttpServlet {

    private CheckoutService checkoutService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.checkoutService = new CheckoutService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        CheckoutData checkoutData = checkoutService.getCheckoutData(userId);

        if (checkoutData == null || !checkoutData.hasItems()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        request.setAttribute("checkoutData", checkoutData);
        request.getRequestDispatcher("/WEB-INF/views/order/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
