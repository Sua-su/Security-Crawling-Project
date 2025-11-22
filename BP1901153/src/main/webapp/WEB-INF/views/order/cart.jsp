<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ page import="java.util.*" %> <%@ page
import="com.dto.CartData" %> <%@ page import="com.model.Cart" %> <% String
contextPath = request.getContextPath(); CartData cartData = (CartData)
request.getAttribute("cartData"); List<Cart>
  cartItems = cartData != null ? cartData.getCartItems() :
  Collections.emptyList(); int totalPrice = cartData != null ?
  cartData.getTotalPrice() : 0; %>
  <!DOCTYPE html>
  <html>
    <head>
      <meta charset="UTF-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title>장바구니 - Security Crawling</title>
      <link rel="stylesheet" href="<%= contextPath %>/assets/css/common.css" />
      <link rel="stylesheet" href="<%= contextPath %>/assets/css/shop.css" />
    </head>
    <body>
      <div class="container">
        <div class="nav-links">
          <a href="<%= contextPath %>/index"> 홈</a>
          <a href="<%= contextPath %>/products"> 상품 게시판</a>
          <a href="<%= contextPath %>/products"> 상품구매</a>
          <a href="<%= contextPath %>/mypage"> 마이페이지</a>
        </div>

        <div class="header">
          <h1>장바구니</h1>
          <span style="color: #666"><%= cartItems.size() %>개 상품</span>
        </div>

        <% if (cartItems.isEmpty()) { %>
        <div class="empty">
          <p style="font-size: 4em"></p>
          <p style="font-size: 1.2em; margin-bottom: 20px">
            장바구니가 비어있습니다.
          </p>
          <a
            href="<%= contextPath %>/products"
            class="btn-large btn-primary"
            style="display: inline-block; text-decoration: none"
          >
            상품 둘러보기
          </a>
        </div>
        <% } else { %>

        <table class="cart-table">
          <thead>
            <tr>
              <th width="45%">상품정보</th>
              <th width="15%">가격</th>
              <th width="20%">수량</th>
              <th width="15%">합계</th>
              <th width="5%"></th>
            </tr>
          </thead>
          <tbody>
            <% for (Cart item : cartItems) { int itemTotal = item.getPrice() *
            item.getQuantity(); boolean stockIssue = item.getQuantity() >
            item.getStock(); %>
            <tr>
              <td>
                <div class="product-info">
                  <div class="product-icon">
                    <% if ("news".equals(item.getCategory())) { out.print(""); }
                    else if ("analysis".equals(item.getCategory())) {
                    out.print(""); } else if
                    ("report".equals(item.getCategory())) { out.print(""); }
                    else { out.print(""); } %>
                  </div>
                  <div>
                    <div class="product-name"><%= item.getProductName() %></div>
                    <div class="product-category">
                      <%= item.getCategory() %>
                    </div>
                    <% if (stockIssue) { %>
                    <div class="stock-warning">
                      재고부족 (남은수량: <%= item.getStock() %>개)
                    </div>
                    <% } %>
                  </div>
                </div>
              </td>
              <td class="price">
                <%= String.format("%,d", item.getPrice()) %>원
              </td>
              <td>
                <form
                  action="<%= contextPath %>/cart"
                  method="post"
                  style="display: inline"
                >
                  <input type="hidden" name="action" value="updateQuantity" />
                  <input
                    type="hidden"
                    name="cartId"
                    value="<%= item.getCartId() %>"
                  />
                  <div class="quantity-controls">
                    <button
                      type="submit"
                      name="quantityAction"
                      value="decrease"
                      class="quantity-btn"
                    >
                      -
                    </button>
                    <input
                      type="number"
                      class="quantity-input"
                      value="<%= item.getQuantity() %>"
                      min="1"
                      max="<%= item.getStock() %>"
                      readonly
                    />
                    <button
                      type="submit"
                      name="quantityAction"
                      value="increase"
                      class="quantity-btn"
                    >
                      +
                    </button>
                  </div>
                </form>
              </td>
              <td class="price"><%= String.format("%,d", itemTotal) %>원</td>
              <td>
                <form
                  action="<%= contextPath %>/cart"
                  method="post"
                  onsubmit="return confirm('삭제하시겠습니까?');"
                >
                  <input type="hidden" name="action" value="remove" />
                  <input
                    type="hidden"
                    name="cartId"
                    value="<%= item.getCartId() %>"
                  />
                  <button type="submit" class="btn btn-danger">삭제</button>
                </form>
              </td>
            </tr>
            <% } %>
          </tbody>
        </table>

        <div class="summary">
          <div class="summary-row">
            <span>상품 금액</span>
            <span class="price"><%= String.format("%,d", totalPrice) %>원</span>
          </div>
          <div class="summary-row">
            <span>배송비</span>
            <span class="price">0원</span>
          </div>
          <div class="summary-row summary-total">
            <span class="label">총 결제금액</span>
            <span class="value"><%= String.format("%,d", totalPrice) %>원</span>
          </div>
        </div>

        <div class="action-buttons">
          <a
            href="<%= contextPath %>/products"
            class="btn-large btn-secondary"
            style="
              text-decoration: none;
              text-align: center;
              line-height: 1.5em;
            "
          >
            계속 쇼핑하기
          </a>
          <form
            action="<%= contextPath %>/checkout"
            method="post"
            style="flex: 1; margin: 0"
          >
            <button
              type="submit"
              class="btn-large btn-primary"
              style="
                width: 100%;
                padding: 18px 32px;
                font-size: 18px;
                font-weight: 700;
              "
            >
              주문하기
            </button>
          </form>
        </div>
        <% } %>
      </div>
    </body>
  </html>
</Cart>
