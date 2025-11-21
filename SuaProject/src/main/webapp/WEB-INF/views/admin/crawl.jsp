<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crawl Data Management - Admin</title>
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

        .tabs {
            background: white;
            padding: 0 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            display: flex;
            gap: 0;
        }

        .tab-btn {
            padding: 15px 30px;
            background: none;
            border: none;
            cursor: pointer;
            font-size: 16px;
            color: #7f8c8d;
            border-bottom: 3px solid transparent;
            transition: all 0.3s;
        }

        .tab-btn.active {
            color: #3498db;
            border-bottom-color: #3498db;
        }

        .tab-btn:hover {
            color: #3498db;
        }

        .tab-content {
            display: none;
        }

        .tab-content.active {
            display: block;
        }

        .filter-section {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        .filter-form {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .filter-select {
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }

        .filter-btn {
            padding: 10px 20px;
            background: #3498db;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            transition: background 0.3s;
        }

        .filter-btn:hover {
            background: #2980b9;
        }

        .clear-btn {
            background: #e74c3c;
        }

        .clear-btn:hover {
            background: #c0392b;
        }

        .data-table-section {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
        }

        .data-table thead {
            background: #34495e;
            color: white;
        }

        .data-table th,
        .data-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ecf0f1;
        }

        .data-table tbody tr:hover {
            background: #f8f9fa;
        }

        .badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }

        .badge-success {
            background: #d4edda;
            color: #155724;
        }

        .badge-error {
            background: #f8d7da;
            color: #721c24;
        }

        .badge-info {
            background: #d1ecf1;
            color: #0c5460;
        }

        .action-btn {
            padding: 5px 10px;
            margin: 0 2px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }

        .btn-view {
            background: #3498db;
            color: white;
        }

        .btn-view:hover {
            background: #2980b9;
        }

        .btn-delete {
            background: #e74c3c;
            color: white;
        }

        .btn-delete:hover {
            background: #c0392b;
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

        .news-title {
            max-width: 300px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .news-url {
            color: #3498db;
            text-decoration: none;
            font-size: 12px;
        }

        .news-url:hover {
            text-decoration: underline;
        }
    </style>
    <script>
        function showTab(tabName) {
            // Hide all tab contents
            document.querySelectorAll('.tab-content').forEach(tab => {
                tab.classList.remove('active');
            });
            
            // Remove active class from all tab buttons
            document.querySelectorAll('.tab-btn').forEach(btn => {
                btn.classList.remove('active');
            });
            
            // Show selected tab content
            document.getElementById(tabName + '-tab').classList.add('active');
            
            // Add active class to clicked button
            event.target.classList.add('active');
        }
    </script>
</head>
<body>
    <div class="admin-container">
        <div class="admin-header">
            <h1>Crawl Data Management</h1>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="back-link">← Back to Dashboard</a>
        </div>

        <c:if test="${param.message == 'deleted'}">
            <div class="message message-success">News deleted successfully!</div>
        </c:if>
        <c:if test="${param.message == 'logs_cleared'}">
            <div class="message message-success">Crawl logs cleared successfully!</div>
        </c:if>
        <c:if test="${param.error != null}">
            <div class="message message-error">Operation failed. Please try again.</div>
        </c:if>

        <div class="tabs">
            <button class="tab-btn active" onclick="showTab('news')">News Data</button>
            <button class="tab-btn" onclick="showTab('logs')">Crawl Logs</button>
        </div>

        <!-- News Tab -->
        <div id="news-tab" class="tab-content active">
            <div class="filter-section">
                <form class="filter-form" action="${pageContext.request.contextPath}/admin/crawl" method="get">
                    <input type="hidden" name="tab" value="news">
                    <select name="company" class="filter-select">
                        <option value="">All Companies</option>
                        <option value="samsung" ${param.company == 'samsung' ? 'selected' : ''}>Samsung</option>
                        <option value="apple" ${param.company == 'apple' ? 'selected' : ''}>Apple</option>
                        <option value="google" ${param.company == 'google' ? 'selected' : ''}>Google</option>
                    </select>
                    <button type="submit" class="filter-btn">Filter</button>
                </form>
            </div>

            <div class="data-table-section">
                <c:choose>
                    <c:when test="${not empty newsList}">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Title</th>
                                    <th>Company</th>
                                    <th>URL</th>
                                    <th>Crawled Date</th>
                                    <th>Actions</th>
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
                                            <a href="${news.url}" target="_blank" class="news-url">View</a>
                                        </td>
                                        <td><fmt:formatDate value="${news.createdAt}" pattern="yyyy-MM-dd HH:mm"/></td>
                                        <td>
                                            <form action="${pageContext.request.contextPath}/admin/crawl" method="post" style="display: inline;">
                                                <input type="hidden" name="action" value="deleteNews">
                                                <input type="hidden" name="newsId" value="${news.newsId}">
                                                <button type="submit" class="action-btn btn-delete" 
                                                        onclick="return confirm('Are you sure you want to delete this news?')">
                                                    Delete
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <div class="no-data">No news data found</div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Logs Tab -->
        <div id="logs-tab" class="tab-content">
            <div class="filter-section">
                <form action="${pageContext.request.contextPath}/admin/crawl" method="post" style="display: inline;">
                    <input type="hidden" name="action" value="clearLogs">
                    <button type="submit" class="filter-btn clear-btn" 
                            onclick="return confirm('Are you sure you want to clear all crawl logs?')">
                        Clear All Logs
                    </button>
                </form>
            </div>

            <div class="data-table-section">
                <c:choose>
                    <c:when test="${not empty crawlLogs}">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Status</th>
                                    <th>Message</th>
                                    <th>Items Crawled</th>
                                    <th>Time</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${crawlLogs}" var="log">
                                    <tr>
                                        <td>${log.logId}</td>
                                        <td>
                                            <span class="badge ${log.status == 'SUCCESS' ? 'badge-success' : 'badge-error'}">
                                                ${log.status}
                                            </span>
                                        </td>
                                        <td>${log.message}</td>
                                        <td>${log.itemsCrawled}</td>
                                        <td><fmt:formatDate value="${log.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <div class="no-data">No crawl logs found</div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</body>
</html>
