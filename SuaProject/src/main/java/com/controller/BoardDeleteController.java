package com.controller;

import com.dao.BoardDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;

@WebServlet("/board/delete")
public class BoardDeleteController extends HttpServlet {

    private BoardDAO boardDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.boardDAO = new BoardDAO();
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
            String role = (String) session.getAttribute("role");
            boolean isAdmin = "admin".equals(role);
            int boardId = Integer.parseInt(request.getParameter("boardId"));

            // 어드민은 모든 게시글 삭제 가능, 일반 유저는 자신의 게시글만 삭제 가능
            boolean success = boardDAO.deletePost(boardId, userId, isAdmin);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/board/list?success=" +
                        URLEncoder.encode("게시글이 삭제되었습니다.", "UTF-8"));
            } else {
                throw new Exception("게시글 삭제 실패");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/board/list?error=" +
                    URLEncoder.encode("게시글 삭제 중 오류가 발생했습니다.", "UTF-8"));
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/board/list");
    }
}
