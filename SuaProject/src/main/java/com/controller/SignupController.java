package com.controller;

import com.dao.UserDAO;
import com.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;

@WebServlet("/auth/signup")
public class SignupController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String message = request.getParameter("message");
        String error = request.getParameter("error");

        request.setAttribute("message", message);
        request.setAttribute("error", error);

        request.getRequestDispatcher("/WEB-INF/views/auth/signup.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String passwordConfirm = request.getParameter("passwordConfirm");
        String name = request.getParameter("name");
        String email = request.getParameter("email");

        // 입력값 검증
        if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                name == null || name.trim().isEmpty() ||
                email == null || email.trim().isEmpty()) {

            String error = URLEncoder.encode("모든 필드를 입력해주세요.", "UTF-8");
            response.sendRedirect(request.getContextPath() + "/auth/signup?error=" + error);
            return;
        }

        // 비밀번호 확인
        if (!password.equals(passwordConfirm)) {
            String error = URLEncoder.encode("비밀번호가 일치하지 않습니다.", "UTF-8");
            response.sendRedirect(request.getContextPath() + "/auth/signup?error=" + error);
            return;
        }

        UserDAO userDAO = new UserDAO();

        // 아이디 중복 확인
        if (userDAO.isUsernameExists(username)) {
            String error = URLEncoder.encode("이미 사용 중인 아이디입니다.", "UTF-8");
            response.sendRedirect(request.getContextPath() + "/auth/signup?error=" + error);
            return;
        }

        // 이메일 중복 확인
        if (userDAO.isEmailExists(email)) {
            String error = URLEncoder.encode("이미 사용 중인 이메일입니다.", "UTF-8");
            response.sendRedirect(request.getContextPath() + "/auth/signup?error=" + error);
            return;
        }

        // User 객체 생성
        User user = new User();
        user.setUsername(username);
        user.setPassword(password); // 실제로는 암호화 필요
        user.setName(name);
        user.setEmail(email);
        user.setPhone(null); // 선택 필드는 null
        user.setAddress(null);
        user.setAddressDetail(null);
        user.setZipcode(null);

        // 회원가입 처리
        boolean success = userDAO.registerUser(user);

        if (success) {
            String message = URLEncoder.encode("회원가입이 완료되었습니다.", "UTF-8");
            response.sendRedirect(request.getContextPath() + "/auth/login?message=" + message);
        } else {
            String error = URLEncoder.encode("회원가입 중 오류가 발생했습니다.", "UTF-8");
            response.sendRedirect(request.getContextPath() + "/auth/signup?error=" + error);
        }
    }
}
