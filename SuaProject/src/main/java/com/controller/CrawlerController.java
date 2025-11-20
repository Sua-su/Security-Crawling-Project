package com.controller;

import com.crawler.JsoupCrawler;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/crawler")
public class CrawlerController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");

        // 키워드가 없으면 선택 화면 표시
        if (keyword == null || keyword.isEmpty()) {
            request.getRequestDispatcher("/WEB-INF/views/crawler.jsp").forward(request, response);
            return;
        }

        try {
            JsoupCrawler crawler = new JsoupCrawler();
            String result = crawler.crawlNaverNews(true, keyword);

            request.setAttribute("crawlerResult", result);
            request.setAttribute("selectedKeyword", keyword);
            request.getRequestDispatcher("/WEB-INF/views/crawler.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/crawler.jsp").forward(request, response);
        }
    }
}
