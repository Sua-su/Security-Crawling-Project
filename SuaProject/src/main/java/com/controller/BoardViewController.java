package com.controller;

import com.dao.BoardDAO;
import com.dao.CommentDAO;
import com.model.Board;
import com.model.Comment;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/board/view")
public class BoardViewController extends HttpServlet {

    private BoardDAO boardDAO;
    private CommentDAO commentDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.boardDAO = new BoardDAO();
        this.commentDAO = new CommentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/board/list");
            return;
        }

        try {
            int boardId = Integer.parseInt(idParam);

            // 조회수 증가
            boardDAO.increaseViews(boardId);

            // 게시글 조회
            Board board = boardDAO.getPostById(boardId);
            if (board == null) {
                response.sendRedirect(request.getContextPath() + "/board/list");
                return;
            }

            // 댓글 조회
            List<Comment> comments = commentDAO.getCommentsByBoardId(boardId);

            request.setAttribute("board", board);
            request.setAttribute("comments", comments);
            request.getRequestDispatcher("/WEB-INF/views/board/view.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/board/list");
        }
    }
}
