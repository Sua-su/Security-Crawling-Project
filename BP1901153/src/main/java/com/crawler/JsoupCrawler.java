package com.crawler;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import db.DBConnect;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class JsoupCrawler {
    private int savedCount = 0;
    private int failedCount = 0;

    /**
     * 네이버 뉴스 크롤링 및 DB 저장
     * 
     * @param saveToDb true면 DB에 저장, false면 화면만 표시
     * @param keyword  검색 키워드 (예: "MLB", "MLB LA다저스")
     */
    public String crawlNaverNews(boolean saveToDb, String keyword) {
        StringBuilder sb = new StringBuilder();
        savedCount = 0;
        failedCount = 0;

        try {
            // 키워드가 없으면 기본값 사용
            if (keyword == null || keyword.trim().isEmpty()) {
                keyword = "MLB";
            }

            String url = "https://search.naver.com/search.naver?where=news&query=" +
                    java.net.URLEncoder.encode(keyword, "UTF-8") + "&display=100";
            Document doc = Jsoup.connect(url).get();

            // 뉴스 블록 선택 (최상위 div)
            Elements newsBlocks = doc.select("div.sds-comps-vertical-layout.sds-comps-full-layout");

            sb.append("<div style='margin-bottom: 20px; padding: 10px; background: #f0f8ff; border-radius: 5px;'>");
            sb.append("<h3>크롤링 결과</h3>");
            sb.append("<p><strong>검색 키워드:</strong> ").append(keyword).append("</p>");
            sb.append("<p>총 <strong>").append(newsBlocks.size()).append("</strong>개의 뉴스를 찾았습니다.</p>");
            if (saveToDb) {
                sb.append("<p style='color: green;'> DB 저장 모드: ON</p>");
            } else {
                sb.append("<p style='color: orange;'> DB 저장 모드: OFF (조회만)</p>");
            }
            sb.append("</div>");

            for (Element block : newsBlocks) {
                // 제목
                Element titleEl = block.selectFirst(".sds-comps-text-type-headline1");
                // 요약문
                Element previewEl = block.selectFirst(".sds-comps-text-type-body1");
                // 링크 - 제목을 감싸고 있는 a 태그에서 href 추출
                Element linkEl = block.selectFirst("a.sds-comps-text-type-headline1");
                if (linkEl == null) {
                    // fallback: 제목 요소의 부모 a 태그 찾기
                    linkEl = titleEl != null ? titleEl.parent() : null;
                }
                // 회사
                Element companyEl = block.selectFirst(".sds-comps-text-weight-sm");

                if (titleEl != null && previewEl != null && linkEl != null && companyEl != null) {
                    String title = titleEl.text();
                    String preview = previewEl.text();
                    String company = companyEl.text();
                    String link = linkEl.attr("href");

                    // 화면 출력
                    sb.append("<div style='margin-bottom: 15px; padding: 10px; border-left: 3px solid #4CAF50;'>");
                    sb.append("<strong>제목:</strong> ").append(title).append("<br>");
                    sb.append("<strong>요약:</strong> ").append(preview).append("<br>");
                    sb.append("<strong>회사:</strong> ").append(company).append("<br>");
                    sb.append("<strong>링크:</strong> <a href='").append(link).append("' target='_blank'>기사 보기</a>");

                    // DB에 저장
                    if (saveToDb) {
                        boolean saved = saveToDatabase(title, preview, company, link);
                        if (saved) {
                            sb.append(" <span style='color: green;'> DB 저장 완료</span>");
                            savedCount++;
                        } else {
                            sb.append(" <span style='color: red;'> DB 저장 실패</span>");
                            failedCount++;
                        }
                    }
                    sb.append("</div>");
                }
            }

            // 결과 요약
            if (saveToDb) {
                sb.append("<div style='margin-top: 20px; padding: 15px; background: #e8f5e9; border-radius: 5px;'>");
                sb.append("<h3>저장 결과</h3>");
                sb.append("<p> 성공: <strong>").append(savedCount).append("</strong>개</p>");
                if (failedCount > 0) {
                    sb.append("<p> 실패: <strong>").append(failedCount).append("</strong>개</p>");
                }
                sb.append("</div>");
            }

        } catch (Exception e) {
            sb.append("<div style='color: red; padding: 10px; background: #ffebee; border-radius: 5px;'>");
            sb.append(" 오류 발생: ").append(e.getMessage());
            sb.append("</div>");
        }

        return sb.toString();
    }

    /**
     * 기본 메서드 (DB 저장 활성화, 기본 키워드 "MLB")
     */
    public String crawlNaverNews() {
        return crawlNaverNews(true, "MLB");
    }

    /**
     * saveToDb만 지정하는 메서드 (기본 키워드 "MLB")
     */
    public String crawlNaverNews(boolean saveToDb) {
        return crawlNaverNews(saveToDb, "MLB");
    }

    /**
     * 크롤링한 뉴스 데이터를 MariaDB에 저장 (포트 13306)
     * 
     * 테이블 생성 SQL:
     * CREATE TABLE news (
     * id INT AUTO_INCREMENT PRIMARY KEY,
     * title VARCHAR(500) NOT NULL,
     * preview TEXT,
     * company VARCHAR(100),
     * link VARCHAR(1000),
     * created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
     * ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
     * 
     * @return 저장 성공 여부
     */
    private boolean saveToDatabase(String title, String preview, String company, String link) {
        // 중복 체크: 동일한 링크가 이미 있으면 저장하지 않음
        String checkSql = "SELECT COUNT(*) FROM news WHERE link = ?";
        Object count = DatabaseUtil.executeScalar(checkSql, link);

        if (count != null && ((Number) count).intValue() > 0) {
            return false; // 중복이므로 저장하지 않음
        }

        // 새로운 뉴스 저장
        String sql = "INSERT INTO news (title, preview, company, link) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, title);
            pstmt.setString(2, preview);
            pstmt.setString(3, company);
            pstmt.setString(4, link);

            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                return true;
            }

        } catch (SQLException e) {
        }
        return false;
    }

    /**
     * DatabaseUtil을 사용한 간편한 저장 방법 (중복 체크 포함)
     * 현재는 saveToDatabase 메서드를 사용하고 있음
     */
    @SuppressWarnings("unused")
    private boolean saveToDatabase2(String title, String preview, String company, String link) {
        // 중복 체크
        String checkSql = "SELECT COUNT(*) FROM news WHERE link = ?";
        Object count = DatabaseUtil.executeScalar(checkSql, link);

        if (count != null && ((Number) count).intValue() > 0) {
            return false;
        }

        // 저장
        String sql = "INSERT INTO news (title, preview, company, link) VALUES (?, ?, ?, ?)";
        int rows = DatabaseUtil.executeUpdate(sql, title, preview, company, link);

        if (rows > 0) {
            return true;
        }
        return false;
    }

    public static String getNewsResult() {
        return new JsoupCrawler().crawlNaverNews();
    }
}
