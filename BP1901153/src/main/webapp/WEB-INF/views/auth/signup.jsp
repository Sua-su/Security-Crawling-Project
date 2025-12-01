<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> 
<% String contextPath = request.getContextPath(); String message = (String) request.getAttribute("message");
String error = (String)request.getAttribute("error"); %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>회원가입 - Security Crawling</title>
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/common.css" />
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/auth.css" />
  </head>
  <body>
    <div class="auth-container">
      <h1>회원가입</h1>

      <% if (message != null) { %>
      <div class="message success"><%= message %></div>
      <% } %> <% if (error != null) { %>
      <div class="message error"><%= error %></div>
      <% } %>

      <form
        action="<%= contextPath %>/auth/signup"
        method="post"
        onsubmit="return validateForm()"
      >
        <div class="form-group">
          <label>아이디 <span class="required">*</span></label>
          <div class="input-with-button">
            <input
              type="text"
              id="username"
              name="username"
              required
              placeholder="영문, 숫자 4-20자"
              maxlength="20"
            />
            <button type="button" class="btn-check" onclick="checkUsername()">
              중복확인
            </button>
          </div>
          <div class="help-text">영문자로 시작, 영문자와 숫자만 사용 가능</div>
          <div id="username-message"></div>
        </div>

        <div class="form-group">
          <label>비밀번호 <span class="required">*</span></label>
          <input
            type="password"
            id="password"
            name="password"
            required
            placeholder="8자 이상"
            minlength="8"
            maxlength="50"
          />
          <div class="help-text">8자 이상의 영문, 숫자 조합</div>
        </div>

        <div class="form-group">
          <label>비밀번호 확인 <span class="required">*</span></label>
          <input
            type="password"
            id="passwordConfirm"
            name="passwordConfirm"
            required
            placeholder="비밀번호 재입력"
          />
          <div id="password-message"></div>
        </div>

        <div class="form-group">
          <label>이름 <span class="required">*</span></label>
          <input
            type="text"
            id="name"
            name="name"
            required
            placeholder="실명 입력"
            maxlength="100"
          />
        </div>

        <div class="form-group">
          <label>이메일 <span class="required">*</span></label>
          <div class="input-with-button">
            <input
              type="email"
              id="email"
              name="email"
              required
              placeholder="example@email.com"
              maxlength="100"
            />
            <button type="button" class="btn-check" onclick="checkEmail()">
              중복확인
            </button>
          </div>
          <div id="email-message"></div>
        </div>

        <button type="submit" class="btn-submit" id="submitBtn" disabled>
          회원가입
        </button>
      </form>

      <div class="links">
        이미 계정이 있으신가요?
        <a href="<%= contextPath %>/auth/login">로그인</a>
      </div>
    </div>

    <script>
      let usernameChecked = false;
      let emailChecked = false;

      function checkUsername() {
        const username = document.getElementById("username").value;
        const messageDiv = document.getElementById("username-message");

        if (!username || username.length < 4) {
          messageDiv.innerHTML =
            '<div class="message error">아이디는 4자 이상이어야 합니다.</div>';
          return;
        }

        fetch(
          "<%= contextPath %>/auth/checkUsername?username=" +
            encodeURIComponent(username)
        )
          .then((response) => response.json())
          .then((data) => {
            if (data.available) {
              messageDiv.innerHTML =
                '<div class="message success">사용 가능한 아이디입니다.</div>';
              usernameChecked = true;
            } else {
              messageDiv.innerHTML =
                '<div class="message error">이미 사용 중인 아이디입니다.</div>';
              usernameChecked = false;
            }
            checkFormValid();
          });
      }

      function checkEmail() {
        const email = document.getElementById("email").value;
        const messageDiv = document.getElementById("email-message");

        if (!email || !email.includes("@")) {
          messageDiv.innerHTML =
            '<div class="message error">올바른 이메일을 입력하세요.</div>';
          return;
        }

        fetch(
          "<%= contextPath %>/auth/checkEmail?email=" +
            encodeURIComponent(email)
        )
          .then((response) => response.json())
          .then((data) => {
            if (data.available) {
              messageDiv.innerHTML =
                '<div class="message success">사용 가능한 이메일입니다.</div>';
              emailChecked = true;
            } else {
              messageDiv.innerHTML =
                '<div class="message error">이미 등록된 이메일입니다.</div>';
              emailChecked = false;
            }
            checkFormValid();
          });
      }

      document
        .getElementById("passwordConfirm")
        .addEventListener("input", function () {
          const password = document.getElementById("password").value;
          const passwordConfirm = this.value;
          const messageDiv = document.getElementById("password-message");

          if (passwordConfirm && password !== passwordConfirm) {
            messageDiv.innerHTML =
              '<div class="message error">비밀번호가 일치하지 않습니다.</div>';
          } else if (passwordConfirm && password === passwordConfirm) {
            messageDiv.innerHTML =
              '<div class="message success">비밀번호가 일치합니다.</div>';
          } else {
            messageDiv.innerHTML = "";
          }
        });

      function checkFormValid() {
        const submitBtn = document.getElementById("submitBtn");
        submitBtn.disabled = !(usernameChecked && emailChecked);
      }

      function validateForm() {
        if (!usernameChecked) {
          alert("아이디 중복확인을 해주세요.");
          return false;
        }
        if (!emailChecked) {
          alert("이메일 중복확인을 해주세요.");
          return false;
        }

        const password = document.getElementById("password").value;
        const passwordConfirm =
          document.getElementById("passwordConfirm").value;
        if (password !== passwordConfirm) {
          alert("비밀번호가 일치하지 않습니다.");
          return false;
        }

        return true;
      }
    </script>
  </body>
</html>
