package com.controller.admin;

import com.model.User;
import com.service.AdminService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;

@WebServlet("/admin/dashboard")
public class AdminDashboardController extends HttpServlet {

    private AdminService adminService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.adminService = new AdminService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // 어드민 권한 체크
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/index");
            return;
        }

        // 대시보드 통계 조회
        Map<String, Object> stats = adminService.getDashboardStats();
        request.setAttribute("stats", stats);
        request.setAttribute("monthlyRevenue", adminService.getMonthlyRevenue());
        request.setAttribute("categoryStats", adminService.getCategoryStats());

        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }
}
