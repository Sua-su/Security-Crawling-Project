<%@ page import="com.dao.BoardDAO" %>
<%@ page import="com.model.Board" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    request.setCharacterEncoding("UTF-8");

    // 로그인 체크
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login");
        return;
    }

    Integer userId = (Integer) session.getAttribute("userId");

    String title = request.getParameter("title");
    String content = request.getParameter("content");

    // 빈 값 체크
    if (title == null || content == null ||
        title.trim().isEmpty() || content.trim().isEmpty()) {

        response.sendRedirect("write.jsp");
        return;
    }

    try {
        Board board = new Board();
        board.setUserId(userId);
        board.setTitle(title.trim());
        board.setContent(content.trim());

        BoardDAO boardDAO = new BoardDAO();
        boolean result = boardDAO.createPost(board);

        if (result) {
            // 작성 성공 - 목록으로 이동
            response.sendRedirect("/board/list");
        } else {
            // 작성 실패
            response.sendRedirect(
                "write.jsp?error=" +
                java.net.URLEncoder.encode("게시글 작성에 실패했습니다.", "UTF-8")
            );
        }

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect(
            "write.jsp?error=" +
            java.net.URLEncoder.encode("오류가 발생했습니다: " + e.getMessage(), "UTF-8")
        );
    }
%>
