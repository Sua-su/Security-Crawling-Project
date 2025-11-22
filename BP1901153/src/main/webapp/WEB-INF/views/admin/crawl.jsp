<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>크롤링 데이터 관리 - Admin</title>
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

        .back-link {
            color: #2c2c2c;
            text-decoration: none;
            font-size: 14px;
            padding: 8px 16px;
            border: 1px solid #d0d0d0;
            border-radius: 8px;
            transition: all 0.3s ease;
            background: linear-gradient(135deg, #ffffff 0%, #f8f8f8 100%);
            font-weight: 600;
        }

        .back-link:hover {
            background: linear-gradient(135deg, #2c2c2c 0%, #1a1a1a 100%);
            color: white;
            border-color: #2c2c2c;
        }

        .data-table-section {
            background: white;
            padding: 28px;
            margin-top: 24px;
            border-radius: 20px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.12);
            border: 1px solid rgba(0,0,0,0.1);
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
        }

        .data-table thead {
            background: linear-gradient(135deg, rgba(0,0,0,0.05) 0%, rgba(100,100,100,0.05) 100%);
        }

        .data-table th {
            padding: 16px;
            text-align: left;
            font-weight: 700;
            color: #374151;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 0.5px;
        }

        .data-table td {
            padding: 16px;
            border-bottom: 1px solid rgba(0,0,0,0.05);
            color: #6B7280;
        }

        .data-table tbody tr:hover {
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

        .badge-success {
            background: linear-gradient(135deg, #000000 0%, #333333 100%);
            color: white;
        }

        .badge-error {
            background: linear-gradient(135deg, #E0E0E0 0%, #CACACA 100%);
            color: #6B6B6B;
        }

        .badge-info {
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

        .btn-view {
            background: linear-gradient(135deg, #4A4A4A 0%, #2C2C2C 100%);
            color: white;
        }

        .btn-view:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.3);
        }

        .btn-delete {
            background: linear-gradient(135deg, #6B6B6B 0%, #4A4A4A 100%);
            color: white;
        }

        .btn-delete:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.3);
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

        .news-title {
            max-width: 300px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            font-weight: 600;
        }

        .news-url {
            color: #2c2c2c;
            text-decoration: none;
            font-size: 12px;
            font-weight: 600;
            padding: 4px 8px;
            border-radius: 6px;
            background: linear-gradient(135deg, #F5F5F5 0%, #E8E8E8 100%);
            transition: all 0.3s ease;
        }

        .news-url:hover {
            background: linear-gradient(135deg, #2c2c2c 0%, #1a1a1a 100%);
            color: white;
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <div class="admin-header">
            <h1>크롤링 데이터 관리</h1>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="back-link">← 대시보드로 돌아가기</a>
        </div>

        <c:if test="${param.message == 'deleted'}">
            <div class="message message-success">뉴스가 성공적으로 삭제되었습니다!</div>
        </c:if>
        <c:if test="${param.message == 'logs_cleared'}">
            <div class="message message-success">크롤링 로그가 성공적으로 삭제되었습니다!</div>
        </c:if>
        <c:if test="${param.error != null}">
            <div class="message message-error">작업에 실패했습니다. 다시 시도해주세요.</div>
        </c:if>

        <div class="data-table-section">
                <c:choose>
                    <c:when test="${not empty newsList}">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>   </th>
                                    <th>제목</th>
                                    <th>기업</th>
                                    <th>URL</th>
                                    <th>        </th>
                                    <th>삭제</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${newsList}" var="news">
                                    <tr>
                                        <td>${news.newsId}</td>
                                        <td>
                                            <div class="news-title" title="${news.title}">
                                                ${news.title}
                                            </div>
                                        </td>
                                        <td>
                                            <span class="badge badge-info">${news.company}</span>
                                        </td>
                                        <td>
                                            <a href="${news.url}" target="_blank" class="news-url">보기</a>
                                        </td>
                                        <td><fmt:formatDate value="${news.createdAt}" pattern="yyyy-MM-dd HH:mm"/></td>
                                        <td>
                                            <form action="${pageContext.request.contextPath}/admin/crawl" method="post" style="display: inline;">
                                                <input type="hidden" name="action" value="deleteNews">
                                                <input type="hidden" name="newsId" value="${news.newsId}">
                                                <button type="submit" class="action-btn btn-delete" 
                                                        onclick="return confirm('이 뉴스를 삭제하시겠습니까?')">
                                                    삭제
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <div class="no-data">뉴스 데이터가 없습니다</div>
                    </c:otherwise>
                </c:choose>
        </div>
    </div>
</body>
</html>
