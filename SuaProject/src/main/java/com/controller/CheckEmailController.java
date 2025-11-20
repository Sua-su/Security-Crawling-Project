package com.controller;

import com.dao.UserDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/auth/checkEmail")
public class CheckEmailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            sendJson(response, false);
            return;
        }

        UserDAO userDAO = new UserDAO();
        boolean exists = userDAO.isEmailExists(email);

        sendJson(response, !exists);
    }

    private void sendJson(HttpServletResponse response, boolean available) throws IOException {
        PrintWriter out = response.getWriter();
        out.print("{\"available\": " + available + "}");
        out.flush();
    }
}
