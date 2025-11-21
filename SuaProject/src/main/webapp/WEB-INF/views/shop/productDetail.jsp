<%@ page import="com.model.Product" %> <%@ page contentType="text/html;
charset=UTF-8" pageEncoding="UTF-8"%> <% Product product = (Product)
request.getAttribute("product"); boolean hasStock = product.getStock() > 0; int
productId = product.getProductId(); %>

<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title><%= product.getName() %> - Security Crawling</title>

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
      <div class="nav-links">
        <a href="<%= request.getContextPath() %>/index"> 홈</a>
        <a href="<%= request.getContextPath() %>/products"> 상품구매</a>
        <a href="<%= request.getContextPath() %>/cart"> 장바구니</a>
      </div>

      <div class="product-detail">
        <div class="product-icon-large">
          <% if ("news".equals(product.getCategory())) { out.print(""); } else
          if ("analysis".equals(product.getCategory())) { out.print(""); } else
          if ("report".equals(product.getCategory())) { out.print(""); } else {
          out.print(""); } %>
        </div>

        <div class="product-info">
          <h1><%= product.getName() %></h1>

          <span class="product-category">
            <%= product.getCategory() != null ? product.getCategory() : "기타"
            %>
          </span>

          <div class="product-description"><%= product.getDescription() %></div>

          <div class="product-meta">
            <div class="meta-item">
              <div class="meta-label">등록일</div>
              <div class="meta-value" style="font-size: 1em">
                <%= product.getCreatedAt().toString().substring(0, 10) %>
              </div>
            </div>

            <div class="meta-item">
              <div class="meta-label">다운로드 수</div>
              <div class="meta-value"><%= product.getDownloadCount() %>회</div>
            </div>
          </div>
        </div>
      </div>

      <div class="price-section">
        <div class="price-label">판매가</div>
        <div class="price-value">
          <%= String.format("%,d", product.getPrice()) %>원
        </div>
      </div>

      <% String stockClass = product.getStock() > 10 ? "stock-available" :
      product.getStock() > 0 ? "stock-low" : "stock-out"; String stockMessage =
      product.getStock() > 10 ? "재고 충분" : product.getStock() > 0 ? "재고
      부족 (남은 수량: " + product.getStock() + "개)" : "품절"; %>

      <div class="stock-info <%= stockClass %>"><%= stockMessage %></div>

      <% if (hasStock) { %>
      <form
        action="<%= request.getContextPath() %>/shop/addToCart"
        method="post"
        onsubmit="return validateQuantity()"
      >
        <input type="hidden" name="productId" value="<%= productId %>" />
        <input
          type="hidden"
          name="returnUrl"
          value="/shop/productDetail?id=<%= productId %>"
        />

        <div class="quantity-section">
          <div class="quantity-controls">
            <button
              type="button"
              class="quantity-btn"
              onclick="decreaseQuantity()"
            >
              -
            </button>

            <input
              type="number"
              id="quantity"
              name="quantity"
              class="quantity-input"
              value="1"
              min="1"
              max="<%= product.getStock() %>"
              required
            />

            <button
              type="button"
              class="quantity-btn"
              onclick="increaseQuantity()"
            >
              +
            </button>
          </div>
        </div>

        <div class="button-group">
          <button type="submit" class="btn btn-primary">장바구니 담기</button>

          <button
            type="submit"
            formaction="<%= request.getContextPath() %>/shop/directOrder"
            class="btn btn-secondary"
          >
            바로 구매
          </button>
        </div>
      </form>

      <% } else { %>

      <div class="button-group">
        <button class="btn btn-primary" disabled>품절</button>
        <a
          href="<%= request.getContextPath() %>/products"
          class="btn btn-secondary"
          style="text-align: center; line-height: 1.5em"
        >
          목록으로
        </a>
      </div>

      <% } %>
    </div>

    <script>
      const maxStock = <%= product.getStock() %>;

      function decreaseQuantity() {
          const input = document.getElementById('quantity');
          if (input.value > 1) {
              input.value = parseInt(input.value) - 1;
          }
      }

      function increaseQuantity() {
          const input = document.getElementById('quantity');
          if (input.value < maxStock) {
              input.value = parseInt(input.value) + 1;
          }
      }

      function validateQuantity() {
          const quantity = parseInt(document.getElementById('quantity').value);
          if (quantity < 1) {
              alert('최소 수량은 1개입니다.');
              return false;
          }
          if (quantity > maxStock) {
              alert('재고 수량을 초과할 수 없습니다. (최대: ' + maxStock + '개)');
              return false;
          }
          return true;
      }
    </script>
  </body>
</html>
