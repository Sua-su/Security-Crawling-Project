<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %> <%@ page
isErrorPage="true" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>오류 발생</title>
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/common.css"
    />
    <style>
      .error-container {
        max-width: 600px;
        margin: 100px auto;
        padding: 40px;
        text-align: center;
        background: #fff;
        border-radius: 10px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
      }
      .error-icon {
        font-size: 80px;
        margin-bottom: 20px;
      }
      .error-title {
        font-size: 28px;
        font-weight: bold;
        color: #333;
        margin-bottom: 15px;
      }
      .error-message {
        font-size: 16px;
        color: #666;
        margin-bottom: 30px;
        line-height: 1.6;
      }
      .error-actions {
        display: flex;
        gap: 10px;
        justify-content: center;
      }
      .btn {
        padding: 12px 24px;
        border-radius: 6px;
        text-decoration: none;
        font-weight: 500;
        transition: all 0.3s;
      }
      .btn-primary {
        background: #007bff;
        color: white;
      }
      .btn-primary:hover {
        background: #0056b3;
      }
      .btn-secondary {
        background: #6c757d;
        color: white;
      }
      .btn-secondary:hover {
        background: #545b62;
      }
    </style>
  </head>
  <body>
    <div class="error-container">
      <div class="error-icon">!</div>
      <div class="error-title">오류가 발생했습니다</div>
      <div class="error-message">
        <% String errorMessage = (String) request.getAttribute("errorMessage");
        if (errorMessage != null) { out.print(errorMessage); } else {
        out.print("요청을 처리하는 중 문제가 발생했습니다."); } %>
      </div>
      <div class="error-actions">
        <a href="javascript:history.back()" class="btn btn-secondary"
          >이전 페이지</a
        >
        <a href="<%= request.getContextPath() %>/index" class="btn btn-primary"
          >홈으로</a
        >
      </div>
    </div>
  </body>
</html>
