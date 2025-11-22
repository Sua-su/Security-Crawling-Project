<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ page import="com.model.Product" %> <%@ page
import="com.model.User" %> <% String contextPath = request.getContextPath();
Product product = (Product) request.getAttribute("product"); int quantity =
(Integer) request.getAttribute("quantity"); int totalPrice = (Integer)
request.getAttribute("totalPrice"); User user = (User)
request.getAttribute("user"); %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>바로 구매 - Security Crawling</title>
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/common.css" />
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/shop.css" />
  </head>
  <body>
    <div class="container">
      <h1>바로 구매</h1>

      <!-- 주문자 정보 -->
      <div class="section">
        <div class="section-title">주문자 정보</div>
        <div class="user-info">
          <div class="info-row">
            <div class="info-label">이름</div>
            <div class="info-value"><%= user.getName() %></div>
          </div>
          <div class="info-row">
            <div class="info-label">아이디</div>
            <div class="info-value"><%= user.getUsername() %></div>
          </div>
          <div class="info-row">
            <div class="info-label">이메일</div>
            <div class="info-value"><%= user.getEmail() %></div>
          </div>
        </div>
      </div>

      <!-- 주문 상품 -->
      <div class="section">
        <div class="section-title">주문 상품</div>
        <div class="order-items">
          <div class="order-item">
            <div class="item-info">
              <div class="item-icon">
                <% if ("news".equals(product.getCategory())) out.print("뉴스");
                else if ("analysis".equals(product.getCategory()))
                out.print("분석"); else if
                ("report".equals(product.getCategory())) out.print("리포트");
                else out.print("상품"); %>
              </div>
              <div>
                <div class="item-name"><%= product.getName() %></div>
                <div class="item-category"><%= product.getCategory() %></div>
                <div class="item-quantity">수량: <%= quantity %>개</div>
              </div>
            </div>
            <div class="item-price">
              <%= String.format("%,d", product.getPrice() * quantity) %>원
            </div>
          </div>
        </div>
      </div>

      <!-- 결제 수단 -->
      <div class="section">
        <div class="section-title">결제 수단</div>
        <form
          action="<%= contextPath %>/shop/directOrderProcess"
          method="post"
          id="orderForm"
        >
          <input
            type="hidden"
            name="productId"
            value="<%= product.getProductId() %>"
          />
          <input type="hidden" name="quantity" value="<%= quantity %>" />

          <div class="payment-methods">
            <div class="payment-option">
              <input
                type="radio"
                id="card"
                name="paymentMethod"
                value="card"
                checked
              />
              <label for="card" class="payment-label">
                <div class="payment-icon">카드</div>
                <div>신용카드</div>
              </label>
            </div>
            <div class="payment-option">
              <input type="radio" id="bank" name="paymentMethod" value="bank" />
              <label for="bank" class="payment-label">
                <div class="payment-icon">이체</div>
                <div>계좌이체</div>
              </label>
            </div>
            <div class="payment-option">
              <input
                type="radio"
                id="phone"
                name="paymentMethod"
                value="phone"
              />
              <label for="phone" class="payment-label">
                <div class="payment-icon">간편</div>
                <div>휴대폰 결제</div>
              </label>
            </div>
          </div>

          <!-- 총 결제 금액 -->
          <div class="total-section">
            <div class="total-label">총 결제 금액</div>
            <div class="total-price">
              <%= String.format("%,d", totalPrice) %>원
            </div>
          </div>

          <!-- 버튼 -->
          <div class="button-group">
            <button
              type="button"
              onclick="history.back()"
              class="btn btn-secondary"
            >
              취소
            </button>
            <button type="submit" class="btn btn-primary">결제하기</button>
          </div>
        </form>
      </div>
    </div>

    <script>
      document
        .getElementById("orderForm")
        .addEventListener("submit", function (e) {
          const selected = document.querySelector(
            'input[name="paymentMethod"]:checked'
          );
          if (!selected) {
            e.preventDefault();
            alert("결제 수단을 선택해주세요.");
            return false;
          }

          if (!confirm("결제를 진행하시겠습니까?")) {
            e.preventDefault();
            return false;
          }
        });
    </script>
  </body>
</html>
