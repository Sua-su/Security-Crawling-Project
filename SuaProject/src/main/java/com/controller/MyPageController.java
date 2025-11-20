package com.controller;

import com.dto.MyPageData;
import com.service.MyPageService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/mypage")
public class MyPageController extends HttpServlet {

    private MyPageService myPageService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.myPageService = new MyPageService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        String activeTab = request.getParameter("tab");

        MyPageData myPageData = myPageService.getMyPageData(userId, activeTab);

        if (myPageData == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        request.setAttribute("myPageData", myPageData);
        request.getRequestDispatcher("/WEB-INF/views/mypage.jsp").forward(request, response);
    }
}
