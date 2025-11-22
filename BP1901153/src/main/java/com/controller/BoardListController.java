package com.controller;

import com.dto.BoardListData;
import com.service.BoardService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/board/list")
public class BoardListController extends HttpServlet {

    private BoardService boardService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.boardService = new BoardService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        // 페이지 파라미터
        int currentPage = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                // 기본값 유지 함; ㅣ
            }
        }

        // 검색 키워드 (빈 문자열이면 null로 처리)
        String keyword = request.getParameter("keyword");
        if (keyword != null && keyword.trim().isEmpty()) {
            keyword = null;
        }

        BoardListData boardData = boardService.getBoardList(currentPage, keyword);

        request.setAttribute("boardData", boardData);
        request.getRequestDispatcher("/WEB-INF/views/board/list.jsp").forward(request, response);
    }
}
