package com.controller.admin;

import com.crawler.DatabaseUtil;
import com.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/crawl")
public class AdminCrawlController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/index");
            return;
        }

        String action = request.getParameter("action");

        if ("logs".equals(action)) {
            handleCrawlLogs(request, response);
        } else {
            handleNewsList(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/index");
            return;
        }

        String action = request.getParameter("action");

        if ("deleteNews".equals(action)) {
            handleDeleteNews(request, response);
        } else if ("clearLogs".equals(action)) {
            handleClearLogs(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/crawl");
        }
    }

    private void handleNewsList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String company = request.getParameter("company");
        int page = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
        int pageSize = 50;
        int offset = (page - 1) * pageSize;

        List<Map<String, Object>> newsList;
        long totalNews;

        if (company != null && !company.isEmpty()) {
            newsList = DatabaseUtil.executeQuery(
                    "SELECT * FROM news WHERE company = ? ORDER BY created_at DESC LIMIT ? OFFSET ?",
                    company, pageSize, offset);
            Object count = DatabaseUtil.executeScalar("SELECT COUNT(*) FROM news WHERE company = ?", company);
            totalNews = count instanceof Number ? ((Number) count).longValue() : 0;
        } else {
            newsList = DatabaseUtil.executeQuery(
                    "SELECT * FROM news ORDER BY created_at DESC LIMIT ? OFFSET ?",
                    pageSize, offset);
            Object count = DatabaseUtil.executeScalar("SELECT COUNT(*) FROM news");
            totalNews = count instanceof Number ? ((Number) count).longValue() : 0;
        }

        List<Map<String, Object>> companies = DatabaseUtil.executeQuery(
                "SELECT company, COUNT(*) as count FROM news GROUP BY company ORDER BY count DESC");

        int totalPages = (int) Math.ceil(totalNews / (double) pageSize);

        request.setAttribute("newsList", newsList);
        request.setAttribute("companies", companies);
        request.setAttribute("selectedCompany", company);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalNews", totalNews);

        request.getRequestDispatcher("/WEB-INF/views/admin/crawl.jsp").forward(request, response);
    }

    private void handleCrawlLogs(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Map<String, Object>> logs = DatabaseUtil.executeQuery(
                "SELECT * FROM crawl_log ORDER BY created_at DESC LIMIT 100");

        request.setAttribute("logs", logs);
        request.getRequestDispatcher("/WEB-INF/views/admin/crawlLogs.jsp").forward(request, response);
    }

    private void handleDeleteNews(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int newsId = Integer.parseInt(request.getParameter("newsId"));
        boolean success = DatabaseUtil.executeUpdate("DELETE FROM news WHERE news_id = ?", newsId) > 0;

        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/crawl?message=news_deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/crawl?error=delete_failed");
        }
    }

    private void handleClearLogs(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        boolean success = DatabaseUtil.executeUpdate("TRUNCATE TABLE crawl_log") > 0;

        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/crawl?action=logs&message=logs_cleared");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/crawl?action=logs&error=clear_failed");
        }
    }
}
