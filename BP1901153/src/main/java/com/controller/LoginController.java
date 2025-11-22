package com.controller;

import com.dao.UserDAO;
import com.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;

@WebServlet("/auth/login")
public class LoginController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/index");
            return;
        }

        String message = request.getParameter("message");
        String error = request.getParameter("error");

        request.setAttribute("message", message);
        request.setAttribute("error", error);

        request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember");

        // 입력값 검증
        if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {

            String error = URLEncoder.encode("아이디와 비밀번호를 입력해주세요.", "UTF-8");
            response.sendRedirect(request.getContextPath() + "/auth/login?error=" + error);
            return;
        }

        UserDAO userDAO = new UserDAO();
        User user = userDAO.login(username, password);

        if (user != null) {
            // 로그인 성공
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("role", user.getRole());

            // 로그인 상태 유지
            if ("on".equals(remember)) {
                session.setMaxInactiveInterval(60 * 60 * 24 * 7); // 7일
            } else {
                session.setMaxInactiveInterval(60 * 30); // 30분
            }

            // 어드민 계정이면 어드민 대시보드로, 일반 사용자는 메인 페이지로
            if (user.isAdmin()) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/index");
            }
        } else {
            // 로그인 실패
            String error = URLEncoder.encode("아이디 또는 비밀번호가 올바르지 않습니다.", "UTF-8");
            response.sendRedirect(request.getContextPath() + "/auth/login?error=" + error);
        }
    }
}
