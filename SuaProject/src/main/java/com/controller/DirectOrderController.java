package com.controller;

import com.dao.ProductDAO;
import com.dao.UserDAO;
import com.model.Product;
import com.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/shop/directOrder")
public class DirectOrderController extends HttpServlet {

    private ProductDAO productDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.productDAO = new ProductDAO();
        this.userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        try {
            // 파라미터 가져오기
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            Integer userId = (Integer) session.getAttribute("userId");

            // 상품 정보 조회
            Product product = productDAO.getProductById(productId);
            if (product == null) {
                response.sendRedirect(request.getContextPath() + "/products");
                return;
            }

            // 재고 확인
            if (product.getStock() < quantity) {
                response.sendRedirect(request.getContextPath() +
                        "/shop/productDetail.jsp?id=" + productId + "&error=재고가 부족합니다");
                return;
            }

            // 사용자 정보 조회
            User user = userDAO.getUserById(userId);

            // 총 가격 계산
            int totalPrice = product.getPrice() * quantity;

            // 세션에 직접 구매 정보 저장
            session.setAttribute("directOrderProductId", productId);
            session.setAttribute("directOrderQuantity", quantity);
            session.setAttribute("directOrderTotalPrice", totalPrice);

            // 주문 정보를 request에 담아서 checkout 페이지로 전달
            request.setAttribute("isDirect", true);
            request.setAttribute("product", product);
            request.setAttribute("quantity", quantity);
            request.setAttribute("totalPrice", totalPrice);
            request.setAttribute("user", user);

            request.getRequestDispatcher("/WEB-INF/views/order/directCheckout.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/products");
    }
}
