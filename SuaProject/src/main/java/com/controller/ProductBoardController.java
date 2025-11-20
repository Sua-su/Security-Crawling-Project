package com.controller;

import com.model.User;
import com.service.ProductBoardService;
import com.service.ShopService;
import com.dto.ProductBoardData;
import com.dto.ShopProductsData;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/products")
public class ProductBoardController extends HttpServlet {

    private ProductBoardService productBoardService;
    private ShopService shopService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.productBoardService = new ProductBoardService();
        this.shopService = new ShopService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // 로그인 체크
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        // 필터 파라미터 수집
        String category = request.getParameter("category");
        String sort = request.getParameter("sort");
        String minPriceParam = request.getParameter("minPrice");
        String maxPriceParam = request.getParameter("maxPrice");
        String pageParam = request.getParameter("page");

        Integer minPrice = parseInteger(minPriceParam);
        Integer maxPrice = parseInteger(maxPriceParam);
        int currentPage = parseInteger(pageParam, 1);

        // 서비스 호출 - 상품 게시판 데이터와 쇼핑몰 데이터 모두 조회
        ProductBoardData data = productBoardService.getProductBoardData(
                category, sort, minPrice, maxPrice, currentPage);
        ShopProductsData shopData = shopService.getShopProducts(category);

        // Request에 데이터 설정
        request.setAttribute("productBoardData", data);
        request.setAttribute("shopData", shopData);
        request.setAttribute("category", category);
        request.setAttribute("sort", sort);
        request.setAttribute("minPrice", minPrice);
        request.setAttribute("maxPrice", maxPrice);
        request.setAttribute("currentPage", currentPage);

        // JSP로 포워딩
        request.getRequestDispatcher("/WEB-INF/views/productBoard.jsp").forward(request, response);
    }

    private Integer parseInteger(String value) {
        return parseInteger(value, null);
    }

    private Integer parseInteger(String value, Integer defaultValue) {
        if (value != null && !value.trim().isEmpty()) {
            try {
                return Integer.parseInt(value.trim());
            } catch (NumberFormatException e) {
                return defaultValue;
            }
        }
        return defaultValue;
    }
}
