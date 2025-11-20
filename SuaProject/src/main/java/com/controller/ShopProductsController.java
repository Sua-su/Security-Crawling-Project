package com.controller;

import com.dto.ShopProductsData;
import com.service.ShopService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/products")
public class ShopProductsController extends HttpServlet {

    private ShopService shopService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.shopService = new ShopService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        String category = request.getParameter("category");
        ShopProductsData shopData = shopService.getShopProducts(category);

        request.setAttribute("shopData", shopData);
        request.getRequestDispatcher("/WEB-INF/views/products.jsp").forward(request, response);
    }
}
