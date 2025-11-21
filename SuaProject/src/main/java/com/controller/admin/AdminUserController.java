package com.controller.admin;

import com.dao.UserDAO;
import com.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/users")
public class AdminUserController extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.userDAO = new UserDAO();
    }

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

        if ("search".equals(action)) {
            handleSearch(request, response);
        } else {
            handleList(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/index");
            return;
        }

        String action = request.getParameter("action");

        switch (action) {
            case "updateStatus":
                handleUpdateStatus(request, response);
                break;
            case "updateRole":
                handleUpdateRole(request, response);
                break;
            case "delete":
                handleDelete(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }

    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<User> users = userDAO.getAllUsers();
        request.setAttribute("users", users);
        request.setAttribute("totalUsers", users.size());

        request.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(request, response);
    }

    private void handleSearch(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        List<User> users = userDAO.searchUsers(keyword);

        request.setAttribute("users", users);
        request.setAttribute("keyword", keyword);
        request.setAttribute("totalUsers", users.size());

        request.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(request, response);
    }

    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int userId = Integer.parseInt(request.getParameter("userId"));
        String status = request.getParameter("status");
        boolean isActive = "ACTIVE".equals(status);

        boolean success = userDAO.updateUserStatus(userId, isActive);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/users?message=status_updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=update_failed");
        }
    }

    private void handleUpdateRole(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int userId = Integer.parseInt(request.getParameter("userId"));
        String role = request.getParameter("role");
        boolean isAdmin = "ADMIN".equals(role);

        boolean success = userDAO.updateUserRole(userId, isAdmin);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/users?message=role_updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=update_failed");
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int userId = Integer.parseInt(request.getParameter("userId"));
        boolean success = userDAO.updateUserStatus(userId, false);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/users?message=user_deactivated");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=update_failed");
        }
    }
}
