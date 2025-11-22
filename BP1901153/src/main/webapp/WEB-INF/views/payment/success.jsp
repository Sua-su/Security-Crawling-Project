<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <% String contextPath = request.getContextPath(); String
orderId = (String) request.getAttribute("orderId"); String amount = (String)
request.getAttribute("amount"); String paymentKey = (String)
request.getAttribute("paymentKey"); %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>결제 완료 - Security Crawling</title>
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/common.css" />
    <style>
      .success-container {
        max-width: 600px;
        margin: 100px auto;
        padding: 40px;
        text-align: center;
        background: white;
        border-radius: 10px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
      }

      .success-icon {
        font-size: 80px;
        margin-bottom: 20px;
      }

      .success-title {
        font-size: 28px;
        font-weight: bold;
        color: #27ae60;
        margin-bottom: 10px;
      }

      .success-message {
        font-size: 16px;
        color: #666;
        margin-bottom: 30px;
      }

      .order-info {
        background: #f8f9fa;
        padding: 20px;
        border-radius: 8px;
        margin-bottom: 30px;
        text-align: left;
      }

      .order-info-row {
        display: flex;
        justify-content: space-between;
        padding: 10px 0;
        border-bottom: 1px solid #e0e0e0;
      }

      .order-info-row:last-child {
        border-bottom: none;
      }

      .order-info-label {
        color: #666;
        font-size: 14px;
      }

      .order-info-value {
        color: #333;
        font-weight: bold;
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

      .test-notice {
        margin-top: 20px;
        padding: 15px;
        background: #fff3cd;
        border: 1px solid #ffc107;
        border-radius: 5px;
        font-size: 14px;
        color: #856404;
      }
    </style>
  </head>
  <body>
    <div class="success-container">
      <div class="success-icon">성공</div>
      <h1 class="success-title">결제가 완료되었습니다!</h1>
      <p class="success-message">주문이 정상적으로 처리되었습니다.</p>

      <div class="order-info">
        <div class="order-info-row">
          <span class="order-info-label">주문번호</span>
          <span class="order-info-value"><%= orderId %></span>
        </div>
        <div class="order-info-row">
          <span class="order-info-label">결제금액</span>
          <span class="order-info-value"
            ><%= String.format("%,d", Integer.parseInt(amount)) %>원</span
          >
        </div>
        <div class="order-info-row">
          <span class="order-info-label">결제수단</span>
          <span class="order-info-value">토스페이먼츠 (테스트)</span>
        </div>
      </div>

      <div class="test-notice">
        ℹ️ 테스트 결제입니다. 실제 결제가 발생하지 않았습니다.
      </div>

      <div class="btn-group">
        <a href="<%= contextPath %>/mypage/orders" class="btn btn-primary"
          >주문 내역 보기</a
        >
        <a href="<%= contextPath %>/index" class="btn btn-secondary">홈으로</a>
      </div>
    </div>
  </body>
</html>
