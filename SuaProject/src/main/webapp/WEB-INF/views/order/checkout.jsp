<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ page import="java.util.*" %> <%@ page
import="com.dto.CheckoutData" %> <%@ page import="com.model.Cart" %> <%@ page
import="com.model.User" %> <% String contextPath = request.getContextPath();
CheckoutData checkoutData = (CheckoutData) request.getAttribute("checkoutData");
User user = checkoutData.getUser(); List<Cart>
  cartItems = checkoutData.getCartItems(); int totalPrice =
  checkoutData.getTotalPrice(); String orderId = (String)
  request.getAttribute("orderId"); %>

  <!DOCTYPE html>
  <html>
    <head>
      <meta charset="UTF-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title>주문하기 - Security Crawling</title>

      <link rel="stylesheet" href="<%= contextPath %>/assets/css/common.css" />
      <link rel="stylesheet" href="<%= contextPath %>/assets/css/shop.css" />

      <!-- 토스페이먼츠 SDK -->
      <script src="https://js.tosspayments.com/v1/payment"></script>
    </head>

    <body>
      <div class="container">
        <h1>주문하기</h1>

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
          <div class="section-title">주문 상품 (<%= cartItems.size() %>개)</div>

          <div class="order-items">
            <% for (Cart item : cartItems) { %>
            <div class="order-item">
              <div class="item-info">
                <div class="item-icon">
                  <% if ("news".equals(item.getCategory())) out.print("뉴스");
                  else if ("analysis".equals(item.getCategory()))
                  out.print("분석"); else if
                  ("report".equals(item.getCategory())) out.print("리포트");
                  else out.print("상품"); %>
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

        <!-- 결제 금액 -->
        <div class="section">
          <div class="section-title">결제 금액</div>
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
        </div>

        <!-- 결제 안내 -->
        <div class="section">
          <div class="payment-notice">
            <div style="font-size: 14px; color: #666; margin-bottom: 10px">
              ℹ️ 토스페이먼츠 <strong>테스트 환경</strong>으로 결제됩니다.
            </div>

            <div style="font-size: 13px; color: #999">
              • 실제 결제가 발생하지 않습니다<br />
              • 테스트용 카드번호를 사용해주세요<br />
              • 결제 완료 후 주문이 생성됩니다
            </div>
          </div>
        </div>

        <div class="btn-group">
          <a href="<%= contextPath %>/cart" class="btn btn-secondary"
            >장바구니로</a
          >

          <button type="button" id="paymentButton" class="btn btn-primary">
            토스페이먼츠로 결제하기
          </button>
        </div>
      </div>

      <% String jsOrderId = orderId; int jsItemCount = cartItems.size(); String
      jsFirstProductName = cartItems.get(0).getProductName(); int jsAmount =
      totalPrice; String jsCustomerName = user.getName(); String jsCustomerEmail
      = user.getEmail(); String jsSuccessUrl = request.getScheme() + "://" +
      request.getServerName() + ":" + request.getServerPort() + contextPath +
      "/payment/success"; String jsFailUrl = request.getScheme() + "://" +
      request.getServerName() + ":" + request.getServerPort() + contextPath +
      "/payment/fail"; %>
      <script type="text/javascript">
        var clientKey = 'test_ck_D5GePWvyJnrK0W0k6q8gLzN97Eoq';
        var tossPayments = TossPayments(clientKey);

        document.getElementById('paymentButton').addEventListener('click', function () {
            var orderId = '<%= jsOrderId %>';
            var itemCount = <%= jsItemCount %>;
            var orderName = '<%= jsFirstProductName %>' + (itemCount > 1 ? ' 외 ' + (itemCount - 1) + '건' : '');
            var amount = <%= jsAmount %>;
            var customerName = '<%= jsCustomerName %>';
            var customerEmail = '<%= jsCustomerEmail %>';

            tossPayments.requestPayment('카드', {
                amount: amount,
                orderId: orderId,
                orderName: orderName,
                customerName: customerName,
                customerEmail: customerEmail,
                successUrl: '<%= jsSuccessUrl %>',
                failUrl: '<%= jsFailUrl %>'
            }).catch(function (error) {
                if (error.code === 'USER_CANCEL') {
                    alert('결제를 취소하셨습니다.');
                } else {
                    alert('결제 중 오류가 발생했습니다: ' + error.message);
                }
            });
        });
      </script>
    </body>
  </html>
</Cart>
