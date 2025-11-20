package com.controller;

import com.dao.CartDAO;
import com.dao.ProductDAO;
import com.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;

@WebServlet("/shop/addToCart")
public class AddToCartController extends HttpServlet {

    private CartDAO cartDAO;
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.cartDAO = new CartDAO();
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
            String returnUrl = request.getParameter("returnUrl");

            // 상품 정보 조회
            Product product = productDAO.getProductById(productId);
            if (product == null) {
                response.sendRedirect(request.getContextPath() + "/products?error=" +
                        URLEncoder.encode("상품을 찾을 수 없습니다.", "UTF-8"));
                return;
            }

            // 재고 확인
            if (product.getStock() < quantity) {
                String redirectUrl = returnUrl != null ? returnUrl : "/products";
                response.sendRedirect(request.getContextPath() + redirectUrl +
                        (redirectUrl.contains("?") ? "&" : "?") + "error=" +
                        URLEncoder.encode("재고가 부족합니다.", "UTF-8"));
                return;
            }

            // 장바구니에 추가
            com.model.Cart cart = new com.model.Cart();
            cart.setUserId(userId);
            cart.setProductId(productId);
            cart.setQuantity(quantity);

            boolean success = cartDAO.addToCart(cart);
            System.out.println("🛒 장바구니 추가 - userId: " + userId + ", productId: " + productId +
                    ", quantity: " + quantity + ", success: " + success);

            if (success) {
                String redirectUrl = returnUrl != null ? returnUrl : "/cart";
                response.sendRedirect(request.getContextPath() + redirectUrl +
                        (redirectUrl.contains("?") ? "&" : "?") + "success=" +
                        URLEncoder.encode("장바구니에 추가되었습니다.", "UTF-8"));
            } else {
                throw new Exception("장바구니 추가 실패");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/products?error=" +
                    URLEncoder.encode("장바구니 추가 중 오류가 발생했습니다.", "UTF-8"));
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/products");
    }
}
