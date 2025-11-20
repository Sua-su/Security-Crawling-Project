package com.controller;

import com.dao.BoardDAO;
import com.model.Board;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;

@WebServlet("/board/write")
public class BoardWriteController extends HttpServlet {

    private BoardDAO boardDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.boardDAO = new BoardDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/board/write.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        try {
            Integer userId = (Integer) session.getAttribute("userId");
            String title = request.getParameter("title");
            String content = request.getParameter("content");

            if (title == null || title.trim().isEmpty() ||
                    content == null || content.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/board/write?error=" +
                        URLEncoder.encode("제목과 내용을 입력해주세요.", "UTF-8"));
                return;
            }

            Board board = new Board();
            board.setUserId(userId);
            board.setTitle(title.trim());
            board.setContent(content.trim());

            boolean success = boardDAO.createPost(board);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/board/list");
            } else {
                throw new Exception("게시글 작성 실패");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/board/write?error=" +
                    URLEncoder.encode("게시글 작성 중 오류가 발생했습니다.", "UTF-8"));
        }
    }
}
