package com.controller;

import com.dao.CommentDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;

@WebServlet("/board/deleteComment")
public class DeleteCommentController extends HttpServlet {

    private CommentDAO commentDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.commentDAO = new CommentDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        try {
            Integer userId = (Integer) session.getAttribute("userId");
            int commentId = Integer.parseInt(request.getParameter("commentId"));
            int boardId = Integer.parseInt(request.getParameter("boardId"));

            // deleteComment 메서드가 권한 체크를 포함하고 있음
            boolean success = commentDAO.deleteComment(commentId, userId);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/board/view?id=" + boardId);
            } else {
                throw new Exception("댓글 삭제 실패");
            }

        } catch (Exception e) {
            String boardId = request.getParameter("boardId");
            response.sendRedirect(request.getContextPath() + "/board/view?id=" + boardId +
                    "&error=" + URLEncoder.encode("댓글 삭제 중 오류가 발생했습니다.", "UTF-8"));
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/board/list");
    }
}
