<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원 관리 - Admin</title>
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/common.css" />
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/admin.css" />
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f6fa;
            color: #2c3e50;
        }

        .admin-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
        }

        .admin-header {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .admin-header h1 {
            color: #2c3e50;
            font-size: 28px;
        }

        .back-link {
            color: #3498db;
            text-decoration: none;
            font-size: 14px;
            padding: 8px 16px;
            border: 1px solid #3498db;
            border-radius: 5px;
            transition: all 0.3s;
        }

        .back-link:hover {
            background: #3498db;
            color: white;
        }

        .search-section {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        .search-form {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .search-input {
            flex: 1;
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }

        .search-btn {
            padding: 10px 20px;
            background: #3498db;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            transition: background 0.3s;
        }

        .search-btn:hover {
            background: #2980b9;
        }

        .users-table-section {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .users-table {
            width: 100%;
            border-collapse: collapse;
        }

        .users-table thead {
            background: #34495e;
            color: white;
        }

        .users-table th,
        .users-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ecf0f1;
        }

        .users-table tbody tr:hover {
            background: #f8f9fa;
        }

        .badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }

        .badge-active {
            background: #d4edda;
            color: #155724;
        }

        .badge-inactive {
            background: #f8d7da;
            color: #721c24;
        }

        .badge-admin {
            background: #d1ecf1;
            color: #0c5460;
        }

        .badge-user {
            background: #e2e3e5;
            color: #383d41;
        }

        .action-btn {
            padding: 5px 10px;
            margin: 0 2px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            transition: all 0.3s;
        }

        .btn-edit {
            background: #3498db;
            color: white;
        }

        .btn-edit:hover {
            background: #2980b9;
        }

        .btn-deactivate {
            background: #e74c3c;
            color: white;
        }

        .btn-deactivate:hover {
            background: #c0392b;
        }

        .btn-activate {
            background: #27ae60;
            color: white;
        }

        .btn-activate:hover {
            background: #229954;
        }

        .message {
            padding: 10px 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }

        .message-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .message-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .no-data {
            text-align: center;
            padding: 40px;
            color: #7f8c8d;
        }
    </style>
</head>
<body>
<div class="admin-container">
    <!-- Header -->
    <div class="admin-header">
        <h1>회원 관리</h1>
        <div class="admin-nav">
            <a href="<%= contextPath %>/admin/dashboard">대시보드</a>
            <a href="<%= contextPath %>/admin/users" class="active">회원 관리</a>
            <a href="<%= contextPath %>/admin/orders">주문 관리</a>
            <a href="<%= contextPath %>/admin/products">상품 관리</a>
            <a href="<%= contextPath %>/admin/crawl">크롤링 관리</a>
            <a href="<%= contextPath %>/index">메인으로</a>
        </div>
    </div>

        <c:if test="${param.message == 'status_updated'}">
            <div class="message message-success">User status updated successfully!</div>
        </c:if>
        <c:if test="${param.message == 'role_updated'}">
            <div class="message message-success">User role updated successfully!</div>
        </c:if>
        <c:if test="${param.message == 'user_deactivated'}">
            <div class="message message-success">User deactivated successfully!</div>
        </c:if>
        <c:if test="${param.error == 'update_failed'}">
            <div class="message message-error">Failed to update user. Please try again.</div>
        </c:if>

        <div class="search-section">
            <form class="search-form" action="${pageContext.request.contextPath}/admin/users" method="get">
                <input type="hidden" name="action" value="search">
                <input type="text" name="keyword" class="search-input" 
                       placeholder="Search by username, name, or email..." 
                       value="${param.keyword}">
                <button type="submit" class="search-btn">Search</button>
            </form>
        </div>

        <div class="users-table-section">
            <c:choose>
                <c:when test="${not empty users}">
                    <table class="users-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Username</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Role</th>
                                <th>Status</th>
                                <th>Created</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${users}" var="user">
                                <tr>
                                    <td>${user.userId}</td>
                                    <td>${user.username}</td>
                                    <td>${user.name}</td>
                                    <td>${user.email}</td>
                                    <td>
                                        <span class="badge ${user.role == 'ADMIN' ? 'badge-admin' : 'badge-user'}">
                                            ${user.role}
                                        </span>
                                    </td>
                                    <td>
                                        <span class="badge ${user.active ? 'badge-active' : 'badge-inactive'}">
                                            ${user.active ? 'ACTIVE' : 'INACTIVE'}
                                        </span>
                                    </td>
                                    <td>${user.createdAt}</td>
                                    <td>
                                        <c:if test="${user.active}">
                                            <form action="${pageContext.request.contextPath}/admin/users" method="post" style="display: inline;">
                                                <input type="hidden" name="action" value="updateStatus">
                                                <input type="hidden" name="userId" value="${user.userId}">
                                                <input type="hidden" name="status" value="INACTIVE">
                                                <button type="submit" class="action-btn btn-deactivate" 
                                                        onclick="return confirm('Are you sure you want to deactivate this user?')">
                                                    Deactivate
                                                </button>
                                            </form>
                                        </c:if>
                                        <c:if test="${!user.active}">
                                            <form action="${pageContext.request.contextPath}/admin/users" method="post" style="display: inline;">
                                                <input type="hidden" name="action" value="updateStatus">
                                                <input type="hidden" name="userId" value="${user.userId}">
                                                <input type="hidden" name="status" value="ACTIVE">
                                                <button type="submit" class="action-btn btn-activate">
                                                    Activate
                                                </button>
                                            </form>
                                        </c:if>
                                        <c:if test="${user.role != 'ADMIN'}">
                                            <form action="${pageContext.request.contextPath}/admin/users" method="post" style="display: inline;">
                                                <input type="hidden" name="action" value="updateRole">
                                                <input type="hidden" name="userId" value="${user.userId}">
                                                <input type="hidden" name="role" value="ADMIN">
                                                <button type="submit" class="action-btn btn-edit" 
                                                        onclick="return confirm('Are you sure you want to make this user an admin?')">
                                                    Make Admin
                                                </button>
                                            </form>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="no-data">No users found</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
