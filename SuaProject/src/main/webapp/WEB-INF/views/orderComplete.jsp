<%@ page import="com.model.Order" %> <%@ page import="com.model.OrderItem" %>
<%@ page import="java.util.List" %> <%@ page contentType="text/html;
charset=UTF-8" pageEncoding="UTF-8"%> <% Order order = (Order)
request.getAttribute("order"); List<OrderItem>
  orderItems = (List<OrderItem
    >) request.getAttribute("orderItems"); %>
    <!DOCTYPE html>
    <html>
      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>주문 완료 - Security Crawling</title>
        <link
          rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/common.css"
        />
        <link
          rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/shop.css"
        />
      </head>
      <body>
        <div class="container">
          <div class="success-icon"></div>
          <h1>주문이 완료되었습니다!</h1>
          <p class="subtitle">구매해주셔서 감사합니다.</p>

          <div class="order-info">
            <div class="info-row">
              <span class="info-label">주문번호</span>
              <span class="order-number"
                >#<%= String.format("%06d", order.getOrderId()) %></span
              >
            </div>
            <div class="info-row">
              <span class="info-label">주문일시</span>
              <span class="info-value"
                ><%= order.getCreatedAt().toString().substring(0, 16) %></span
              >
            </div>
            <div class="info-row">
              <span class="info-label">결제수단</span>
              <span class="info-value">
                <% String method = order.getPaymentMethod(); if
                ("card".equals(method)) out.print(" 신용카드"); else if
                ("bank".equals(method)) out.print(" 계좌이체"); else if
                ("phone".equals(method)) out.print(" 휴대폰"); else
                out.print(method); %>
              </span>
            </div>
            <div class="info-row">
              <span class="info-label">결제상태</span>
              <span
                class="info-value"
                style="color: #28a745; font-weight: bold"
              >
                 결제완료
              </span>
            </div>
          </div>

          <div class="order-items">
            <div class="item-title">
               주문 상품 (<%= orderItems.size() %>개)
            </div>
            <% for (OrderItem item : orderItems) { %>
            <div class="item">
              <div>
                <div class="item-name"><%= item.getProductName() %></div>
                <div class="item-detail">
                  <%= item.getCategory() %> | 수량: <%= item.getQuantity() %>개
                </div>
              </div>
              <div class="item-price">
                <%= String.format("%,d", item.getTotalPrice()) %>원
              </div>
            </div>
            <% } %>
          </div>

          <div class="total-amount">
            <div class="total-label">총 결제금액</div>
            <div class="total-value">
              <%= String.format("%,d", order.getTotalAmount()) %>원
            </div>
          </div>

          <div class="btn-group">
            <a
              href="<%= request.getContextPath() %>/mypage"
              class="btn btn-secondary"
            >
              마이페이지
            </a>
            <a
              href="<%= request.getContextPath() %>/products"
              class="btn btn-primary"
            >
              쇼핑 계속하기
            </a>
          </div>
        </div>
      </body>
    </html>
  </OrderItem>
</OrderItem>
