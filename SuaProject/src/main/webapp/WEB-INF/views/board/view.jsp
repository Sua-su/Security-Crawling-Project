<%@ page import="com.model.Board" %> <%@ page import="com.model.Comment" %> <%@
page import="java.util.List" %> <%@ page contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <% Board post = (Board) request.getAttribute("board");
@SuppressWarnings("unchecked") List<Comment>
  comments = (List<Comment
    >) request.getAttribute("comments"); Integer currentUserId = (Integer)
    session.getAttribute("userId"); String role = (String)
    session.getAttribute("role"); boolean isAdmin = "admin".equals(role);
    boolean isAuthor = (post.getUserId() == currentUserId); int boardId =
    post.getBoardId(); %>

    <!DOCTYPE html>
    <html>
      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title><%= post.getTitle() %> - Security Crawling</title>

        <link
          rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/common.css"
        />
        <link
          rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/board.css"
        />
      </head>

      <body>
        <div class="container">
          <!-- 네비게이션 -->
          <div class="nav-links">
            <a href="<%= request.getContextPath() %>/index"> 홈</a>
            <a href="/board/list"> 게시판 목록</a>
          </div>

          <!-- 게시글 헤더 -->
          <div class="post-header">
            <h1 class="post-title"><%= post.getTitle() %></h1>

            <div class="post-meta">
              <span
                ><%= post.getName() != null ? post.getName() :
                post.getUsername() %></span
              >
              <span>
                <%= post.getCreatedAt().toString().substring(0, 16) %></span
              >
              <span> 조회 <%= post.getViews() %></span>
              <span> 댓글 <%= comments.size() %></span>
            </div>
          </div>

          <!-- 게시글 내용 -->
          <div class="post-content"><%= post.getContent() %></div>

          <!-- 게시글 하단 버튼 -->
          <div class="post-footer">
            <div class="button-group">
              <a href="/board/list" class="btn btn-secondary">목록</a>

              <% if (isAuthor || isAdmin) { %>
              <a
                href="<%= request.getContextPath() %>/board/edit?id=<%= boardId %>"
                class="btn btn-primary"
                >수정</a
              >

              <form
                action="<%= request.getContextPath() %>/board/delete"
                method="post"
                style="display: inline"
                onsubmit="return confirm('정말 삭제하시겠습니까?');"
              >
                <input type="hidden" name="boardId" value="<%= boardId %>" />
                <button type="submit" class="btn btn-danger">삭제</button>
              </form>
              <% } %>
            </div>
          </div>

          <!-- 댓글 영역 -->
          <div class="comments-section">
            <h2 class="comments-header">댓글 (<%= comments.size() %>)</h2>

            <!-- 댓글 작성 폼 -->
            <div class="comment-form">
              <form
                action="<%= request.getContextPath() %>/board/addComment"
                method="post"
                onsubmit="return validateComment()"
              >
                <input type="hidden" name="boardId" value="<%= boardId %>" />

                <textarea
                  name="content"
                  id="commentContent"
                  placeholder="댓글을 입력하세요"
                  required
                ></textarea>

                <button type="submit" class="btn btn-primary">댓글 작성</button>
              </form>
            </div>

            <!-- 댓글 목록 -->
            <% if (comments.isEmpty()) { %>

            <div class="empty-comments">
              <p>첫 번째 댓글을 작성해보세요!</p>
            </div>

            <% } else { %>

            <div class="comment-list">
              <% for (Comment comment : comments) { boolean isCommentAuthor =
              (comment.getUserId() == currentUserId); %>

              <div class="comment-item">
                <div class="comment-header">
                  <span class="comment-author">
                    <%= comment.getName() != null ? comment.getName() :
                    comment.getUsername() %>
                  </span>
                  <span class="comment-date">
                    <%= comment.getCreatedAt().toString().substring(0, 16) %>
                  </span>
                </div>

                <div class="comment-content"><%= comment.getContent() %></div>

                <% if (isCommentAuthor || isAdmin) { %>
                <div class="comment-actions">
                  <form
                    action="<%= request.getContextPath() %>/board/deleteComment"
                    method="post"
                    style="display: inline"
                    onsubmit="return confirm('댓글을 삭제하시겠습니까?');"
                  >
                    <input
                      type="hidden"
                      name="commentId"
                      value="<%= comment.getCommentId() %>"
                    />
                    <input
                      type="hidden"
                      name="boardId"
                      value="<%= boardId %>"
                    />

                    <button type="submit" class="btn btn-danger">삭제</button>
                  </form>
                </div>
                <% } %>
              </div>

              <% } %>
            </div>

            <% } %>
          </div>
        </div>

        <script>
          function validateComment() {
            const content = document
              .getElementById("commentContent")
              .value.trim();
            if (content.length < 2) {
              alert("댓글은 2자 이상 입력해주세요.");
              return false;
            }
            return true;
          }
        </script>
      </body>
    </html>
  </Comment></Comment
>
