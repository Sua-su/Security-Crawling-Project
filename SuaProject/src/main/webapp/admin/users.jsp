<%@ page import="com.dao.*" %> <%@ page import="com.model.*" %> <%@ page
import="java.util.List" %> <%@ page contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
 <% 
 // 관리자 체크 
 if (session.getAttribute("user") == null) { response.sendRedirect(request.getContextPath() + "/auth/login");
return; } Integer userId = (Integer) session.getAttribute("userId"); UserDAO
userDAO = new UserDAO(); User user = userDAO.getUserById(userId); 
if (!user.isAdmin()) { response.sendRedirect(request.getContextPath() + "/index.jsp"); return; }
List<User> users = userDAO.getAllUsers();
  OrderDAO orderDAO = new OrderDAO();
  String message = request.getParameter("message"); %>
  <!DOCTYPE html>
  <html>
    <head>
      <meta charset="UTF-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title>회원 관리 - Security Crawling</title>
      <link
        rel="stylesheet"
        href="${pageContext.request.contextPath}/assets/css/common.css"
      />
      <link
        rel="stylesheet"
        href="${pageContext.request.contextPath}/assets/css/admin.css"
      />
    </head>
    <body>
      <div class="sidebar">
        <h2> 관리자</h2>
        <ul class="sidebar-menu">
          <li><a href="dashboard.jsp"> 대시보드</a></li>
          <li><a href="products.jsp">상품 관리</a></li>
          <li><a href="users.jsp" class="active">회원 관리</a></li>
          <li>
            <a href="<%= request.getContextPath() %>/index"> 메인으로</a>
          </li>
        </ul>
      </div>

      <div class="main-content">
        <div class="header">
          <h1> 회원 관리</h1>
          <div>
            <span style="color: #666"
              >관리자: <strong><%= user.getName() %></strong></span
            >
          </div>
        </div>

        <% if (message != null) { %>
        <div class="alert alert-success"><%= message %></div>
        <% } %>

        <div class="stats">
          <div class="stat-box">
            <div class="number"><%= users.size() %></div>
            <div class="label">전체 회원</div>
          </div>
          <div class="stat-box">
            <div class="number">
              <% int activeCount = 0; for (User u : users) { if (u.isActive())
              activeCount++; } %> <%= activeCount %>
            </div>
            <div class="label">활성 회원</div>
          </div>
          <div class="stat-box">
            <div class="number">
              <% int adminCount = 0; for (User u : users) { if (u.isAdmin())
              adminCount++; } %> <%= adminCount %>
            </div>
            <div class="label">관리자</div>
          </div>
          <div class="stat-box">
            <div class="number">
              <% int inactiveCount = 0; for (User u : users) { if
              (!u.isActive()) inactiveCount++; } %> <%= inactiveCount %>
            </div>
            <div class="label">비활성 회원</div>
          </div>
        </div>

        <div class="card">
          <div class="card-title">전체 회원 목록 (<%= users.size() %>명)</div>
          <table class="user-table">
            <thead>
              <tr>
                <th>ID</th>
                <th>이름</th>
                <th>아이디</th>
                <th>이메일</th>
                <th>권한</th>
                <th>상태</th>
                <th>주문수</th>
                <th>가입일</th>
                <th>관리</th>
              </tr>
            </thead>
            <tbody>
              <% for (User u : users) { int orderCount =
              orderDAO.getOrdersByUserId(u.getUserId()).size(); %>
              <tr>
                <td><%= u.getUserId() %></td>
                <td><strong><%= u.getName() %></strong></td>
                <td><%= u.getUsername() %></td>
                <td><%= u.getEmail() %></td>
                <td>
                  <% if (u.isAdmin()) { %>
                  <span class="badge badge-warning">👑 관리자</span>
                  <% } else { %>
                  <span class="badge badge-primary"> 일반</span>
                  <% } %>
                </td>
                <td>
                  <% if (u.isActive()) { %>
                  <span class="badge badge-success">활성</span>
                  <% } else { %>
                  <span class="badge badge-danger">비활성</span>
                  <% } %>
                </td>
                <td><%= orderCount %>건</td>
                <td><%= u.getCreatedAt().toString().substring(0, 10) %></td>
                <td>
                  <% if (u.getUserId() != userId) { %> <% if (u.isActive()) { %>
                  <a
                    href="userProcess.jsp?action=deactivate&userId=<%= u.getUserId() %>"
                    class="btn btn-danger"
                    onclick="return confirm('정말 비활성화 하시겠습니까?')"
                    >비활성화</a
                  >
                  <% } else { %>
                  <a
                    href="userProcess.jsp?action=activate&userId=<%= u.getUserId() %>"
                    class="btn btn-success"
                    >활성화</a
                  >
                  <% } %> <% if (!u.isAdmin()) { %>
                  <a
                    href="userProcess.jsp?action=makeAdmin&userId=<%= u.getUserId() %>"
                    class="btn btn-primary"
                    onclick="return confirm('관리자로 승격하시겠습니까?')"
                    >관리자로</a
                  >
                  <% } %> <% } else { %>
                  <span style="color: #999; font-size: 0.9em">본인 계정</span>
                  <% } %>
                </td>
              </tr>
              <% } %>
            </tbody>
          </table>
        </div>
      </div>
    </body>
  </html>
</User>
