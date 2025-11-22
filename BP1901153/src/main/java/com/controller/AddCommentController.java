package com.controller;

import com.dao.CommentDAO;
import com.model.Comment;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;

@WebServlet("/board/addComment")
public class AddCommentController extends HttpServlet {

    private CommentDAO commentDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.commentDAO = new CommentDAO();
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
            int boardId = Integer.parseInt(request.getParameter("boardId"));
            String content = request.getParameter("content");

            if (content == null || content.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/board/view?id=" + boardId +
                        "&error=" + URLEncoder.encode("댓글 내용을 입력해주세요.", "UTF-8"));
                return;
            }

            Comment comment = new Comment();
            comment.setBoardId(boardId);
            comment.setUserId(userId);
            comment.setContent(content.trim());

            boolean success = commentDAO.createComment(comment);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/board/view?id=" + boardId);
            } else {
                throw new Exception("댓글 작성 실패");
            }

        } catch (Exception e) {
            String boardId = request.getParameter("boardId");
            response.sendRedirect(request.getContextPath() + "/board/view?id=" + boardId +
                    "&error=" + URLEncoder.encode("댓글 작성 중 오류가 발생했습니다.", "UTF-8"));
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/board/list");
    }
}
