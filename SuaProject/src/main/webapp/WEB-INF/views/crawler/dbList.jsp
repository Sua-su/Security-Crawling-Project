<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="com.dto.NewsData" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    NewsData newsData = (NewsData) request.getAttribute("newsData");
    int totalCount = newsData.getTotalCount();
    int todayCount = newsData.getTodayCount();
    List<Map<String, Object>> companies = newsData.getCompanies();
    List<Map<String, Object>> newsList = newsData.getNewsList();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>저장된 뉴스 목록</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/common.css" />
</head>
<body>
<div class="container">
    <h1>저장된 뉴스 목록</h1>
    <p style="color: #666; margin-bottom: 20px;">
        MariaDB (포트: 13306) - BP1901153 데이터베이스
    </p>

    <!-- 통계 박스 -->
    <div class='stats'>
        <div class='stat-box'>
            <h3><%= totalCount %></h3>
            <p>전체 뉴스</p>
        </div>
        <div class='stat-box'>
            <h3><%= todayCount %></h3>
            <p>오늘 저장된 뉴스</p>
        </div>
        <div class='stat-box'>
            <h3><%= companies.size() %></h3>
            <p>언론사 수</p>
        </div>
    </div>

    <!-- 액션 버튼 -->
    <div class='actions'>
        <a href='<%= request.getContextPath() %>/crawler' class='btn'>새로 크롤링하기</a>
        <a href='<%= request.getContextPath() %>/dbList' class='btn'>새로고침</a>
        <a href='<%= request.getContextPath() %>/products' class='btn'>상품 게시판</a>
    </div>

    <% if (newsList.isEmpty()) { %>
        <div class='no-data'>
            <h2>비어있음</h2>
            <p>저장된 뉴스가 없습니다.</p>
            <p><a href='<%= request.getContextPath() %>/crawler' class='btn' style='margin-top: 20px;'>첫 크롤링 시작하기</a></p>
        </div>
    <% } else { 
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        for (Map<String, Object> news : newsList) {
            String title = (String) news.get("title");
            String preview = (String) news.get("preview");
            String company = (String) news.get("company");
            String link = (String) news.get("link");
            Timestamp createdAt = (Timestamp) news.get("created_at");
    %>
        <div class='news-item'>
            <div class='news-title'><%= title != null ? title : "제목 없음" %></div>
            <div class='news-preview'><%= preview != null ? preview : "" %></div>
            <div class='news-meta'>
                <span><%= company != null ? company : "알 수 없음" %></span>
                <span><%= createdAt != null ? sdf.format(createdAt) : "" %></span>
            </div>
            <% if (link != null) { %>
                <a href='<%= link %>' target='_blank' class='news-link'>기사 보기 →</a>
            <% } %>
        </div>
    <% 
        }
    } 
    %>

</div>
</body>
</html>
