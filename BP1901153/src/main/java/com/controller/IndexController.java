package com.controller;

import com.model.User;
import com.service.DashboardService;
import com.dto.DashboardData;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/index")
public class IndexController extends HttpServlet {

    private DashboardService dashboardService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.dashboardService = new DashboardService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("user");
        String username = (String) session.getAttribute("username");
        String role = (String) session.getAttribute("role");

        boolean isLoggedIn = (loggedInUser != null);
        boolean isAdmin = isLoggedIn && "admin".equals(role);

        // 대시보드 데이터 조회
        DashboardData dashboardData = dashboardService.getDashboardData();

        // Request에 데이터 설정
        request.setAttribute("isLoggedIn", isLoggedIn);
        request.setAttribute("isAdmin", isAdmin);
        request.setAttribute("username", username);
        request.setAttribute("dashboardData", dashboardData);

        // JSP로 포워딩
        request.getRequestDispatcher("/WEB-INF/views/main/mainPage.jsp").forward(request, response);
    }
}
