<%@ page import="com.dao.CommentDAO" %>
<%@ page import="com.model.Comment" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
request.setCharacterEncoding("UTF-8");

// 로그인 체크
if (session.getAttribute("user") == null) {
    response.sendRedirect(request.getContextPath() + "/auth/login");
    return;
}

Integer userId = (Integer) session.getAttribute("userId");

String boardIdParam = request.getParameter("boardId");
String content = request.getParameter("content");

// 필수값 검증
if (boardIdParam == null || content == null || content.trim().isEmpty()) {
    response.sendRedirect("/board/list");
    return;
}

int boardId = Integer.parseInt(boardIdParam);

try {
    Comment comment = new Comment();
    comment.setBoardId(boardId);
    comment.setUserId(userId);
    comment.setContent(content.trim());

    CommentDAO commentDAO = new CommentDAO();
    commentDAO.createComment(comment);

    // 댓글 등록 후 게시글 보기 페이지로 이동
    response.sendRedirect("view.jsp?id=" + boardId);

} catch (Exception e) {
    e.printStackTrace();
    response.sendRedirect("view.jsp?id=" + boardId);
}
%>
