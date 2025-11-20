<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.dto.BoardListData" %>
<%@ page import="com.model.Board" %>
<%
    String contextPath = request.getContextPath();
    BoardListData boardData = (BoardListData) request.getAttribute("boardData");
    
    List<Board> posts = boardData.getPosts();
    int totalCount = boardData.getTotalCount();
    int currentPage = boardData.getCurrentPage();
    int totalPages = boardData.getTotalPages();
    int pageSize = boardData.getPageSize();
    String keyword = boardData.getKeyword();
    boolean isSearch = boardData.isSearch();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시판 - Security Crawling</title>
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/common.css" />
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/board.css" />
</head>
<body>
<div class="container">
    <div class="nav-links">
        <a href="<%= contextPath %>/index"> 홈</a>
        <a href="<%= contextPath %>/products"> 상품 게시판</a>
        <a href="<%= contextPath %>/products"> 상품구매</a>
        <a href="<%= contextPath %>/mypage"> 마이페이지</a>
    </div>
    
    <div class="header">
        <h1>💬 게시판</h1>
        <a href="<%= contextPath %>/board/write" class="btn btn-primary"> 글쓰기</a>
    </div>
    
    <form action="<%= contextPath %>/board/list" method="get" class="search-box">
        <input type="text" name="keyword" placeholder="제목 또는 내용 검색" 
               value="<%= isSearch ? keyword : "" %>">
        <button type="submit"> 검색</button>
        <% if (isSearch) { %>
        <a href="<%= contextPath %>/board/list" class="btn btn-secondary">전체보기</a>
        <% } %>
    </form>
    
    <% if (isSearch) { %>
    <p style="color: #666; margin-bottom: 15px;">
        "<%= keyword %>" 검색 결과: <strong><%= totalCount %>개</strong>
    </p>
    <% } %>
    
    <% if (posts == null || posts.isEmpty()) { %>
    <div class="empty">
        <p style="font-size: 3em;">📭</p>
        <p><%= isSearch ? "검색 결과가 없습니다." : "첫 번째 글을 작성해보세요!" %></p>
    </div>
    <% } else { %>
    <table class="board-table">
        <thead>
            <tr>
                <th width="8%">번호</th>
                <th width="50%">제목</th>
                <th width="12%">작성자</th>
                <th width="10%">조회수</th>
                <th width="20%">작성일</th>
            </tr>
        </thead>
        <tbody>
            <% 
            int displayNum = totalCount - (currentPage - 1) * pageSize;
            for (Board post : posts) { 
            %>
            <tr>
                <td><%= displayNum-- %></td>
                <td class="title">
                    <a href="<%= contextPath %>/board/view?id=<%= post.getBoardId() %>">
                        <%= post.getTitle() %>
                        <% if (post.getCommentCount() > 0) { %>
                        <span class="comment-badge"><%= post.getCommentCount() %></span>
                        <% } %>
                    </a>
                </td>
                <td><%= post.getName() != null ? post.getName() : post.getUsername() %></td>
                <td><%= post.getViews() %></td>
                <td><%= post.getCreatedAt().toString().substring(0, 16) %></td>
            </tr>
            <% } %>
        </tbody>
    </table>
    
    <!-- 페이징 -->
    <div class="pagination">
        <% if (currentPage > 1) { %>
        <a href="?page=<%= currentPage - 1 %><%= isSearch ? "&keyword=" + java.net.URLEncoder.encode(keyword, "UTF-8") : "" %>">이전</a>
        <% } %>
        
        <% 
        int startPage = Math.max(1, currentPage - 5);
        int endPage = Math.min(totalPages, startPage + 9);
        
        for (int i = startPage; i <= endPage; i++) { 
            if (i == currentPage) { 
        %>
        <span class="active"><%= i %></span>
        <% } else { %>
        <a href="?page=<%= i %><%= isSearch ? "&keyword=" + java.net.URLEncoder.encode(keyword, "UTF-8") : "" %>"><%= i %></a>
        <% 
            } 
        } 
        %>
        
        <% if (currentPage < totalPages) { %>
        <a href="?page=<%= currentPage + 1 %><%= isSearch ? "&keyword=" + java.net.URLEncoder.encode(keyword, "UTF-8") : "" %>">다음</a>
        <% } %>
    </div>
    <% } %>
</div>
</body>
</html>
