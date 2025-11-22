<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <% String contextPath = request.getContextPath(); String
errorCode = (String) request.getAttribute("errorCode"); String errorMessage =
(String) request.getAttribute("errorMessage"); %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>결제 실패 - Security Crawling</title>
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/common.css" />
    <style>
      .fail-container {
        max-width: 600px;
        margin: 100px auto;
        padding: 40px;
        text-align: center;
        background: white;
        border-radius: 10px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
      }

      .fail-icon {
        font-size: 80px;
        margin-bottom: 20px;
      }

      .fail-title {
        font-size: 28px;
        font-weight: bold;
        color: #e74c3c;
        margin-bottom: 10px;
      }

      .fail-message {
        font-size: 16px;
        color: #666;
        margin-bottom: 30px;
      }

      .error-info {
        background: #f8f9fa;
        padding: 20px;
        border-radius: 8px;
        margin-bottom: 30px;
        text-align: left;
      }

      .error-info-row {
        padding: 10px 0;
        border-bottom: 1px solid #e0e0e0;
      }

      .error-info-row:last-child {
        border-bottom: none;
      }

      .error-label {
        color: #666;
        font-size: 14px;
        margin-bottom: 5px;
      }

      .error-value {
        color: #333;
        font-size: 14px;
      }

      .btn-group {
        display: flex;
        gap: 10px;
        justify-content: center;
      }

      .btn {
        padding: 12px 30px;
        border: none;
        border-radius: 5px;
        font-size: 16px;
        cursor: pointer;
        text-decoration: none;
        display: inline-block;
      }

      .btn-primary {
        background: #667eea;
        color: white;
      }

      .btn-secondary {
        background: #f8f9fa;
        color: #333;
        border: 1px solid #ddd;
      }
    </style>
  </head>
  <body>
    <div class="fail-container">
      <div class="fail-icon">실패</div>
      <h1 class="fail-title">결제에 실패했습니다</h1>
      <p class="fail-message">결제 처리 중 문제가 발생했습니다.</p>

      <% if (errorCode != null || errorMessage != null) { %>
      <div class="error-info">
        <% if (errorCode != null) { %>
        <div class="error-info-row">
          <div class="error-label">오류 코드</div>
          <div class="error-value"><%= errorCode %></div>
        </div>
        <% } %> <% if (errorMessage != null) { %>
        <div class="error-info-row">
          <div class="error-label">오류 메시지</div>
          <div class="error-value"><%= errorMessage %></div>
        </div>
        <% } %>
      </div>
      <% } %>

      <div class="btn-group">
        <a href="<%= contextPath %>/checkout" class="btn btn-primary"
          >다시 시도</a
        >
        <a href="<%= contextPath %>/cart" class="btn btn-secondary"
          >장바구니로</a
        >
      </div>
    </div>
  </body>
</html>
