<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ page import="java.util.*" %> <%@ page
import="com.dto.CheckoutData" %> <%@ page import="com.model.Cart" %> <%@ page
import="com.model.User" %> <% String contextPath = request.getContextPath();
CheckoutData checkoutData = (CheckoutData) request.getAttribute("checkoutData");
User user = checkoutData.getUser(); List<Cart>
  cartItems = checkoutData.getCartItems(); int totalPrice =
  checkoutData.getTotalPrice(); %>
  <!DOCTYPE html>
  <html>
    <head>
      <meta charset="UTF-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title>주문하기 - Security Crawling</title>
      <link rel="stylesheet" href="<%= contextPath %>/assets/css/common.css" />
      <link rel="stylesheet" href="<%= contextPath %>/assets/css/shop.css" />
    </head>
    <body>
      <div class="container">
        <h1> 주문하기</h1>

        <!-- 주문자 정보 -->
        <div class="section">
          <div class="section-title"> 주문자 정보</div>
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
          <div class="section-title">
             주문 상품 (<%= cartItems.size() %>개)
          </div>
          <div class="order-items">
            <% for (Cart item : cartItems) { %>
            <div class="order-item">
              <div class="item-info">
                <div class="item-icon">
                  <% if ("news".equals(item.getCategory())) out.print("");
                  else if ("analysis".equals(item.getCategory()))
                  out.print(""); else if ("report".equals(item.getCategory()))
                  out.print(""); else out.print(""); %>
                </div>
                <div>
                  <div class="item-name"><%= item.getProductName() %></div>
                  <div class="item-category"><%= item.getCategory() %></div>
                  <div class="item-quantity">
                    수량: <%= item.getQuantity() %>개
                  </div>
                </div>
              </div>
              <div class="item-price">
                <%= String.format("%,d", item.getTotalPrice()) %>원
              </div>
            </div>
            <% } %>
          </div>
        </div>

        <!-- 결제 수단 -->
        <div class="section">
          <div class="section-title"> 결제 수단</div>
          <form action="<%= contextPath %>/order" method="post" id="orderForm">
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
                  <div class="payment-icon"></div>
                  <div>신용카드</div>
                </label>
              </div>
              <div class="payment-option">
                <input
                  type="radio"
                  id="bank"
                  name="paymentMethod"
                  value="bank"
                />
                <label for="bank" class="payment-label">
                  <div class="payment-icon"></div>
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
                  <div class="payment-icon"></div>
                  <div>휴대폰</div>
                </label>
              </div>
            </div>

            <!-- 결제 금액 -->
            <div class="summary">
              <div class="summary-row">
                <span>상품 금액</span>
                <span><%= String.format("%,d", totalPrice) %>원</span>
              </div>
              <div class="summary-row">
                <span>배송비</span>
                <span>0원</span>
              </div>
              <div class="summary-row summary-total">
                <span class="label">최종 결제 금액</span>
                <span class="value"
                  ><%= String.format("%,d", totalPrice) %>원</span
                >
              </div>
            </div>

            <div class="btn-group">
              <a href="<%= contextPath %>/cart" class="btn btn-secondary"
                >장바구니로</a
              >
              <button type="submit" class="btn btn-primary">결제하기</button>
            </div>
          </form>
        </div>
      </div>

      <script>
        document
          .getElementById("orderForm")
          .addEventListener("submit", function (e) {
            if (!confirm("결제를 진행하시겠습니까?")) {
              e.preventDefault();
            }
          });
      </script>
    </body>
  </html>
</Cart>
