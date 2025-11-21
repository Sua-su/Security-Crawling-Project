package com.controller;

import com.dto.CartData;
import com.service.CartService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/cart")
public class CartController extends HttpServlet {

    private CartService cartService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.cartService = new CartService();
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
        System.out.println("🛒 장바구니 조회 요청 - userId: " + userId);

        CartData cartData = cartService.getCartData(userId);
        System.out.println("📦 장바구니 데이터 - items: " +
                (cartData.getCartItems() != null ? cartData.getCartItems().size() : 0) +
                "개, totalPrice: " + cartData.getTotalPrice());

        request.setAttribute("cartData", cartData);
        request.getRequestDispatcher("/WEB-INF/views/order/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        String action = request.getParameter("action");

        if ("updateQuantity".equals(action)) {
            handleUpdateQuantity(request, response);
        } else if ("remove".equals(action)) {
            handleRemove(request, response);
        } else if ("add".equals(action)) {
            handleAdd(request, response, session);
        } else {
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }

    private void handleUpdateQuantity(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int cartId = Integer.parseInt(request.getParameter("cartId"));
            String quantityAction = request.getParameter("quantityAction");

            cartService.updateCartQuantity(cartId, quantityAction);
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }

    private void handleRemove(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int cartId = Integer.parseInt(request.getParameter("cartId"));
            cartService.removeFromCart(cartId);
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }

    private void handleAdd(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws IOException {
        try {
            Integer userId = (Integer) session.getAttribute("userId");
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = 1; // 기본 수량

            String quantityParam = request.getParameter("quantity");
            if (quantityParam != null && !quantityParam.trim().isEmpty()) {
                quantity = Integer.parseInt(quantityParam);
            }

            cartService.addToCart(userId, productId, quantity);
            response.sendRedirect(request.getContextPath() + "/cart");
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }
}
