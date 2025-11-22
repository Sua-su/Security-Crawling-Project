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
            background: #F1F1F1;
            color: #2c2c2c;
        }

        .admin-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
        }

        .admin-header {
            background: white;
            padding: 24px 32px;
            border-radius: 20px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.12);
            margin-bottom: 32px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border: 1px solid rgba(0,0,0,0.1);
        }

        .admin-header h1 {
            font-size: 2rem;
            font-weight: 900;
            background: linear-gradient(135deg, #000000 0%, #444444 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .search-section {
            background: white;
            padding: 24px;
            border-radius: 20px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.12);
            margin-bottom: 32px;
            border: 1px solid rgba(0,0,0,0.1);
        }

        .search-form {
            display: flex;
            gap: 12px;
            align-items: center;
        }

        .search-input {
            flex: 1;
            padding: 12px 16px;
            border: 1px solid #d0d0d0;
            border-radius: 12px;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .search-input:focus {
            outline: none;
            border-color: #2c2c2c;
            box-shadow: 0 0 0 3px rgba(44,44,44,0.1);
        }

        .search-btn {
            padding: 12px 28px;
            background: linear-gradient(135deg, #000000 0%, #333333 100%);
            color: white;
            border: none;
            border-radius: 12px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 700;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(0,0,0,0.3);
        }

        .search-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.4);
        }

        .users-table-section {
            background: white;
            padding: 28px;
            border-radius: 20px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.12);
            border: 1px solid rgba(0,0,0,0.1);
        }

        .users-table {
            width: 100%;
            border-collapse: collapse;
        }

        .users-table thead {
            background: linear-gradient(135deg, rgba(0,0,0,0.05) 0%, rgba(100,100,100,0.05) 100%);
        }

        .users-table th {
            padding: 16px;
            text-align: left;
            font-weight: 700;
            color: #374151;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 0.5px;
        }

        .users-table td {
            padding: 16px;
            border-bottom: 1px solid rgba(0,0,0,0.05);
            color: #6B7280;
        }

        .users-table tbody tr:hover {
            background: linear-gradient(135deg, rgba(0,0,0,0.02) 0%, rgba(100,100,100,0.02) 100%);
        }

        .badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 999px;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .badge-active {
            background: linear-gradient(135deg, #E8E8E8 0%, #D0D0D0 100%);
            color: #1a1a1a;
        }

        .badge-inactive {
            background: linear-gradient(135deg, #F5F5F5 0%, #E0E0E0 100%);
            color: #6B6B6B;
        }

        .badge-admin {
            background: linear-gradient(135deg, #000000 0%, #333333 100%);
            color: white;
        }

        .badge-user {
            background: linear-gradient(135deg, #B8B8B8 0%, #8A8A8A 100%);
            color: white;
        }

        .action-btn {
            padding: 8px 16px;
            margin: 0 4px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 12px;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .btn-edit {
            background: linear-gradient(135deg, #4A4A4A 0%, #2C2C2C 100%);
            color: white;
        }

        .btn-edit:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.3);
        }

        .btn-deactivate {
            background: linear-gradient(135deg, #6B6B6B 0%, #4A4A4A 100%);
            color: white;
        }

        .btn-deactivate:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.3);
        }

        .btn-activate {
            background: linear-gradient(135deg, #000000 0%, #1a1a1a 100%);
            color: white;
        }

        .btn-activate:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.4);
        }

        .message {
            padding: 12px 16px;
            border-radius: 12px;
            margin-bottom: 24px;
            font-weight: 600;
        }

        .message-success {
            background: #F0F0F0;
            color: #1a1a1a;
            border-left: 4px solid #000000;
        }

        .message-error {
            background: #F5F5F5;
            color: #4A4A4A;
            border-left: 4px solid #6B6B6B;
        }

        .no-data {
            text-align: center;
            padding: 60px;
            color: #9CA3AF;
            font-size: 1.1rem;
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
            <div class="message message-success">회원 상태가 성공적으로 업데이트되었습니다!</div>
        </c:if>
        <c:if test="${param.message == 'role_updated'}">
            <div class="message message-success">회원 권한이 성공적으로 업데이트되었습니다!</div>
        </c:if>
        <c:if test="${param.message == 'user_deactivated'}">
            <div class="message message-success">회원이 성공적으로 비활성화되었습니다!</div>
        </c:if>
        <c:if test="${param.error == 'update_failed'}">
            <div class="message message-error">회원 정보 업데이트에 실패했습니다. 다시 시도해주세요.</div>
        </c:if>

        <div class="search-section">
            <form class="search-form" action="${pageContext.request.contextPath}/admin/users" method="get">
                <input type="hidden" name="action" value="search">
                <input type="text" name="keyword" class="search-input" 
                       placeholder="아이디, 이름, 이메일로 검색..." 
                       value="${param.keyword}">
                <button type="submit" class="search-btn">검색</button>
            </form>
        </div>

        <div class="users-table-section">
            <c:choose>
                <c:when test="${not empty users}">
                    <table class="users-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>아이디</th>
                                <th>이름</th>
                                <th>이메일</th>
                                <th>권한</th>
                                <th>상태</th>
                                <th>가입일</th>
                                <th>작업</th>
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
                                            ${user.active ? '활성' : '비활성'}
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
                                                        onclick="return confirm('이 회원을 비활성화하시겠습니까?')">
                                                    비활성화
                                                </button>
                                            </form>
                                        </c:if>
                                        <c:if test="${!user.active}">
                                            <form action="${pageContext.request.contextPath}/admin/users" method="post" style="display: inline;">
                                                <input type="hidden" name="action" value="updateStatus">
                                                <input type="hidden" name="userId" value="${user.userId}">
                                                <input type="hidden" name="status" value="ACTIVE">
                                                <button type="submit" class="action-btn btn-activate">
                                                    활성화
                                                </button>
                                            </form>
                                        </c:if>
                                        <c:if test="${user.role != 'ADMIN'}">
                                            <form action="${pageContext.request.contextPath}/admin/users" method="post" style="display: inline;">
                                                <input type="hidden" name="action" value="updateRole">
                                                <input type="hidden" name="userId" value="${user.userId}">
                                                <input type="hidden" name="role" value="ADMIN">
                                                <button type="submit" class="action-btn btn-edit" 
                                                        onclick="return confirm('이 회원을 관리자로 지정하시겠습니까?')">
                                                    관리자 지정
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
                    <div class="no-data">회원이 없습니다</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
