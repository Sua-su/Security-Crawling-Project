<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> <%
//로그인 체크 
if (session.getAttribute("user") == null) {
response.sendRedirect(request.getContextPath() + "/auth/login"); return; }
String username = (String) session.getAttribute("username"); %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>글쓰기 - Security Crawling</title>
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
      <div class="nav-links">
        <a href="<%= request.getContextPath() %>/index"> 홈</a>
        <a href="/board/list"> 게시판</a>
      </div>

      <div class="header">
        <h1> 글쓰기</h1>
      </div>

      <div class="info"> 작성자: <strong><%= username %></strong></div>

      <form
        action="writeProcess.jsp"
        method="post"
        onsubmit="return validateForm()"
      >
        <div class="form-group">
          <label>제목 <span style="color: red">*</span></label>
          <input
            type="text"
            name="title"
            id="title"
            placeholder="제목을 입력하세요"
            required
          />
        </div>

        <div class="form-group">
          <label>내용 <span style="color: red">*</span></label>
          <textarea
            name="content"
            id="content"
            placeholder="내용을 입력하세요"
            required
          ></textarea>
        </div>

        <div class="button-group">
          <button type="submit" class="btn btn-primary">작성완료</button>
          <a href="/board/list" class="btn btn-secondary">취소</a>
        </div>
      </form>
    </div>

    <script>
      function validateForm() {
        const title = document.getElementById("title").value.trim();
        const content = document.getElementById("content").value.trim();

        if (title.length < 2) {
          alert("제목은 2자 이상 입력해주세요.");
          return false;
        }

        if (content.length < 5) {
          alert("내용은 5자 이상 입력해주세요.");
          return false;
        }

        return true;
      }
    </script>
  </body>
</html>
