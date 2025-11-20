<%@ page import="java.sql.*,
                db.DBConnect,
                com.crawler.DatabaseUtil,
                java.util.*,
                java.text.SimpleDateFormat" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title> 저장된 뉴스 목록</title>
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/common.css" />
</head>

<body>
<div class="container">

    <h1> 저장된 뉴스 목록</h1>
    <p style="color: #666; margin-bottom: 20px;">
        MariaDB (포트: 13306) - BP1901153 데이터베이스
    </p>

<%
    try {
        // 전체 뉴스 수
        Object totalCount = DatabaseUtil.executeScalar(
            "SELECT COUNT(*) FROM news"
        );

        // 오늘 저장된 뉴스
        Object todayCount = DatabaseUtil.executeScalar(
            "SELECT COUNT(*) FROM news WHERE DATE(created_at) = CURDATE()"
        );

        // 언론사별 개수
        List<Map<String, Object>> companies = DatabaseUtil.executeQuery(
            "SELECT company, COUNT(*) as cnt FROM news " +
            "GROUP BY company ORDER BY cnt DESC LIMIT 5"
        );

        // 최신 뉴스 목록
        List<Map<String, Object>> newsList = DatabaseUtil.executeQuery(
            "SELECT * FROM news ORDER BY created_at DESC LIMIT 50"
        );

        /* 통계 박스 */
        out.println("<div class='stats'>");

        out.println("  <div class='stat-box'>");
        out.println("    <h3>" + totalCount + "</h3>");
        out.println("    <p>전체 뉴스</p>");
        out.println("  </div>");

        out.println("  <div class='stat-box'>");
        out.println("    <h3>" + todayCount + "</h3>");
        out.println("    <p>오늘 저장된 뉴스</p>");
        out.println("  </div>");

        out.println("  <div class='stat-box'>");
        out.println("    <h3>" + companies.size() + "</h3>");
        out.println("    <p>언론사 수</p>");
        out.println("  </div>");

        out.println("</div>");

        /* 액션 버튼 */
        out.println("<div class='actions'>");
        out.println("  <a href='" + request.getContextPath() + "/crawler' class='btn'> 새로 크롤링하기</a>");
        out.println("  <a href='?action=refresh' class='btn'>🔃 새로고침</a>");
        out.println("  <a href='productBoard.jsp' class='btn'> 상품 게시판</a>");
        out.println("</div>");

        /* 뉴스 데이터 없음 */
        if (newsList.isEmpty()) {

            out.println("<div class='no-data'>");
            out.println("  <h2>📭</h2>");
            out.println("  <p>저장된 뉴스가 없습니다.</p>");
            out.println("  <p><a href='" + request.getContextPath() + "/crawler' class='btn' style='margin-top: 20px;'>첫 크롤링 시작하기</a></p>");
            out.println("</div>");

        } else {

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

            for (Map<String, Object> news : newsList) {

                String title = (String) news.get("title");
                String preview = (String) news.get("preview");
                String company = (String) news.get("company");
                String link = (String) news.get("link");
                Timestamp createdAt = (Timestamp) news.get("created_at");

                out.println("<div class='news-item'>");

                out.println("  <div class='news-title'>" +
                            (title != null ? title : "제목 없음") +
                            "</div>");

                out.println("  <div class='news-preview'>" +
                            (preview != null ? preview : "") +
                            "</div>");

                out.println("  <div class='news-meta'>");
                out.println("    <span> " +
                            (company != null ? company : "알 수 없음") +
                            "</span>");
                out.println("    <span>🕒 " +
                            (createdAt != null ? sdf.format(createdAt) : "") +
                            "</span>");
                out.println("  </div>");

                if (link != null) {
                    out.println("  <a href='" + link +
                                "' target='_blank' class='news-link'>기사 보기 →</a>");
                }

                out.println("</div>");
            }
        }

    } catch (Exception e) {

        out.println("<div class='error'>");
        out.println("  <h3>❌ 오류 발생</h3>");
        out.println("  <p>" + e.getMessage() + "</p>");

        out.println("  <details style='margin-top: 10px;'>");
        out.println("    <summary>상세 정보</summary>");
        out.println("    <pre>" + e.getClass().getName() + "</pre>");
        e.printStackTrace(new java.io.PrintWriter(out));
        out.println("  </details>");

        out.println("  <p style='margin-top: 20px;'> <strong>해결 방법:</strong></p>");
        out.println("  <ol style='margin-left: 20px;'>");
        out.println("    <li>MariaDB 서비스가 실행 중인지 확인하세요.</li>");
        out.println("    <li>포트 13306이 올바른지 확인하세요.</li>");
        out.println("    <li>news 테이블이 생성되어 있는지 확인하세요.</li>");
        out.println("    <li><code>database/init.sql</code> 스크립트를 실행하세요.</li>");
        out.println("  </ol>");

        out.println("</div>");
    }
%>

</div>
</body>
</html>
