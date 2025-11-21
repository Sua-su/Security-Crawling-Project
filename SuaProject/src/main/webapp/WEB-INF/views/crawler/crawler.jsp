<%@ page import="com.crawler.JsoupCrawler" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>MLB 뉴스 크롤러</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/common.css" />
</head>

<body>
<div class="container">
    <h1>MLB 뉴스 크롤러</h1>
    <p style="color: #666; margin-bottom: 20px;">
        네이버 MLB 뉴스를 크롤링하여 DB에 저장
    </p>

    <div class="nav">
        <a href="<%= request.getContextPath() %>/dbList">저장된 뉴스 보기</a>
        <a href="<%= request.getContextPath() %>/crawler">다시 시도</a>
        <a href="<%= request.getContextPath() %>/index">메인으로</a>
    </div>

    <!-- 검색 키워드 선택 -->
    <div style="margin: 20px 0; padding: 20px; background: #f9f9f9; border-radius: 8px;">
        <h3 style="margin-bottom: 15px;">검색 키워드 선택</h3>
        
        <!-- 인기 키워드 -->
        <div style="margin-bottom: 20px;">
            <h4 style="margin-bottom: 10px; color: #666;">인기 키워드</h4>
            <div style="display: flex; gap: 10px; flex-wrap: wrap;">
                <a href="<%= request.getContextPath() %>/crawler?keyword=MLB" 
                   class="btn btn-primary" style="text-decoration: none;">
                    MLB 전체
                </a>
                <a href="<%= request.getContextPath() %>/crawler?keyword=MLB+LA다저스" 
                   class="btn btn-primary" style="text-decoration: none;">
                    MLB LA다저스
                </a>
                <a href="<%= request.getContextPath() %>/crawler?keyword=MLB+양키스" 
                   class="btn btn-primary" style="text-decoration: none;">
                    MLB 양키스
                </a>
                <a href="<%= request.getContextPath() %>/crawler?keyword=MLB+오타니" 
                   class="btn btn-primary" style="text-decoration: none;">
                    MLB 오타니
                </a>
                <a href="<%= request.getContextPath() %>/crawler?keyword=MLB+류현진" 
                   class="btn btn-primary" style="text-decoration: none;">
                    MLB 류현진
                </a>
                <a href="<%= request.getContextPath() %>/crawler?keyword=KBO" 
                   class="btn btn-primary" style="text-decoration: none;">
                    KBO
                </a>
            </div>
        </div>

        <!-- 직접 검색 -->
        <div>
            <h4 style="margin-bottom: 10px; color: #666;">직접 검색</h4>
            <form method="get" action="<%= request.getContextPath() %>/crawler" 
                  style="display: flex; gap: 10px; align-items: center;">
                <input type="text" 
                       name="keyword" 
                       placeholder="검색어를 입력하세요 (예: 손흥민, 프리미어리그)" 
                       style="flex: 1; padding: 10px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px;"
                       required />
                <button type="submit" class="btn btn-primary" style="white-space: nowrap;">
                    크롤링 시작
                </button>
            </form>
            <p style="margin-top: 8px; font-size: 12px; color: #999;">
                * 네이버 뉴스에서 검색 가능한 모든 키워드를 사용할 수 있습니다.
            </p>
        </div>
    </div>

    <div class="result">
        <%
            String result = (String) request.getAttribute("crawlerResult");
            String error  = (String) request.getAttribute("error");

            if (error != null) {
                out.println(
                    "<div style=\"color: red; padding: 20px; background: #ffebee; border-radius: 8px;\">"
                );
                out.println("<h3>크롤링 오류</h3>");
                out.println("<p>" + error + "</p>");
                out.println("<p style=\"margin-top: 10px;\"><strong>확인 사항:</strong></p>");
                out.println("<ul style=\"margin-left: 20px;\">");
                out.println("<li>인터넷 연결이 정상인지 확인하세요.</li>");
                out.println("<li>네이버 뉴스 페이지 구조가 변경되었을 수 있습니다.</li>");
                out.println("<li>MariaDB 서비스가 실행 중인지 확인하세요.</li>");
                out.println("</ul>");
                out.println("</div>");

            } else if (result != null) {
                out.print(result);

            } else {
                out.println(
                    "<div style=\"padding: 20px; background: #f5f5f5; border-radius: 8px;\">"
                );
                out.println(
                    "<p>크롤링을 실행하려면 새로고침하거나 다시 시도 버튼을 클릭하세요.</p>"
                );
                out.println("</div>");
            }
        %>
    </div>
</div>
</body>
</html>
