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
String role = (String) session.getAttribute("role");
boolean isAdmin = "admin".equals(role);

String commentIdParam = request.getParameter("commentId");
String boardIdParam = request.getParameter("boardId");

// 기본값 체크
if (commentIdParam == null || boardIdParam == null) {
    response.sendRedirect("/board/list");
    return;
}

int commentId = Integer.parseInt(commentIdParam);
int boardId = Integer.parseInt(boardIdParam);

try {
    CommentDAO commentDAO = new CommentDAO();

    if (isAdmin) {
        // 관리자: 작성자 확인 후 삭제
        Comment comment = commentDAO.getCommentById(commentId);
        if (comment != null) {
            commentDAO.deleteComment(commentId, comment.getUserId());
        }
    } else {
        // 일반 사용자: 본인 댓글만 삭제
        commentDAO.deleteComment(commentId, userId);
    }

    response.sendRedirect("view.jsp?id=" + boardId);

} catch (Exception e) {
    e.printStackTrace();
    response.sendRedirect("view.jsp?id=" + boardId);
}
%>
