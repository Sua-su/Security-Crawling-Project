<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> 
<% String contextPath = request.getContextPath(); String message = (String) request.getAttribute("message");
String error = (String)request.getAttribute("error"); %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>로그인 - Security Crawling</title>
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/common.css" />
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/auth.css" />
  </head>
  <body>
    <div class="login-container">
      <h1>로그인</h1>
      <p class="subtitle">Security Crawling Project</p>

      <% if (message != null) { %>
      <div class="message success"><%= message %></div>
      <% } %> <% if (error != null) { %>
      <div class="message error"><%= error %></div>
      <% } %>

      <form action="<%= contextPath %>/auth/login" method="post">
        <div class="form-group">
          <label>아이디</label>
          <input
            type="text"
            name="username"
            required
            placeholder="아이디를 입력하세요"
            autofocus
          />
        </div>

        <div class="form-group">
          <label>비밀번호</label>
          <input
            type="password"
            name="password"
            required
            placeholder="비밀번호를 입력하세요"
          />
        </div>

        <div class="remember-me">
          <input type="checkbox" id="remember" name="remember" />
          <label for="remember">로그인 상태 유지</label>
        </div>

        <button type="submit" class="btn-login">로그인</button>
      </form>

      <div class="links">
        <a href="<%= contextPath %>/auth/signup">회원가입</a>
        <span class="divider">|</span>
        <a href="<%= contextPath %>/index">메인으로</a>
      </div>
    </div>
  </body>
</html>
