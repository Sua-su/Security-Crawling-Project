package com.controller;

import com.service.NewsService;
import com.dto.NewsData;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/dbList")
public class DBListController extends HttpServlet {

    private NewsService newsService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.newsService = new NewsService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // 뉴스 데이터 조회
            NewsData newsData = newsService.getNewsData();

            // Request에 데이터 설정
            request.setAttribute("newsData", newsData);

            // JSP로 포워딩
            request.getRequestDispatcher("/WEB-INF/views/crawler/dbList.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("errorMessage", "뉴스 데이터를 불러오는 중 오류가 발생했습니다.");
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
}
