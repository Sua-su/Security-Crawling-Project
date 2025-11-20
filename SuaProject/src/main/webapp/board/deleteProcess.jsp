<%@ page import="com.dao.BoardDAO" %>
<%@ page import="com.model.Board" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
request.setCharacterEncoding("UTF-8");

// 로그인 체크
if (session.getAttribute("user") == null) {
    response.sendRedirect(request.getContextPath() + "/auth/login");
    return;
}

Integer userId = (Integer) session.getAttribute("userId");
String role = (String) session.getAttribute("role");
boolean isAdmin = "admin".equals(role);

String boardIdParam = request.getParameter("boardId");

// 파라미터 체크
if (boardIdParam == null) {
    response.sendRedirect("/board/list");
    return;
}

int boardId = Integer.parseInt(boardIdParam);

try {
    BoardDAO boardDAO = new BoardDAO();

    if (isAdmin) {
        // 관리자: 게시글 작성자를 조회해 userId 전달
        Board board = boardDAO.getPostById(boardId);
        if (board != null) {
            boardDAO.deletePost(boardId, board.getUserId());
        }
    } else {
        // 일반 사용자: 본인의 글만 삭제
        boardDAO.deletePost(boardId, userId);
    }

    response.sendRedirect("/board/list");

} catch (Exception e) {
    e.printStackTrace();
    response.sendRedirect("/board/list");
}
%>
