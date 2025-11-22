package com.crawler;

import db.DBConnect;
import java.sql.Connection;
import java.sql.Statement;
import java.util.List;
import java.util.Map;

/**
 * MariaDB 연결 테스트 클래스 (포트 13306)
 */
public class DBTest {

    public static void main(String[] args) {

        // 1. 기본 연결 테스트
        testConnection();

        // 2. Connection Pool 상태 확인
        testPoolStats();

        // 3. 테이블 생성 테스트
        createNewsTable();

        // 4. CRUD 테스트
        testCRUD();

        // 5. DatabaseUtil 테스트
        testDatabaseUtil();


        // Connection Pool 종료
        DBConnect.close();
    }

    /**
     * 1. 기본 연결 테스트
     */
    private static void testConnection() {
        try (Connection conn = DBConnect.getConnection()) {
            if (conn != null && !conn.isClosed()) {
            }
        } catch (Exception e) {
        }
    }

    /**
     * 2. Connection Pool 상태
     */
    private static void testPoolStats() {
        DBConnect.printPoolStats();
    }

    /**
     * 3. 뉴스 테이블 생성
     */
    private static void createNewsTable() {

        String dropSql = "DROP TABLE IF EXISTS news";
        String createSql = "CREATE TABLE news (" +
                "id INT AUTO_INCREMENT PRIMARY KEY," +
                "title VARCHAR(500) NOT NULL," +
                "preview TEXT," +
                "company VARCHAR(100)," +
                "link VARCHAR(1000)," +
                "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                "INDEX idx_created_at (created_at)," +
                "INDEX idx_company (company)" +
                ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci";

        try (Connection conn = DBConnect.getConnection();
                Statement stmt = conn.createStatement()) {

            stmt.executeUpdate(dropSql);

            stmt.executeUpdate(createSql);

        } catch (Exception e) {
        }
    }

    /**
     * 4. CRUD 테스트
     */
    private static void testCRUD() {

        // INSERT
        String insertSql = "INSERT INTO news (title, preview, company, link) VALUES (?, ?, ?, ?)";
        int rows = DatabaseUtil.executeUpdate(
                insertSql,
                "테스트 뉴스 제목",
                "이것은 테스트 뉴스입니다.",
                "테스트 언론사",
                "https://example.com/news/1");

        // SELECT
        String selectSql = "SELECT * FROM news";
        List<Map<String, Object>> results = DatabaseUtil.executeQuery(selectSql);

        for (Map<String, Object> row : results) {
        }

        // COUNT
        Object count = DatabaseUtil.executeScalar("SELECT COUNT(*) FROM news");

    }

    /**
     * 5. DatabaseUtil 고급 기능 테스트
     */
    private static void testDatabaseUtil() {

        // 테이블 존재 확인
        boolean exists = DatabaseUtil.tableExists("news");

        // 트랜잭션 테스트
        boolean success = DatabaseUtil.executeTransaction(conn -> {
            String sql = "INSERT INTO news (title, preview, company, link) VALUES (?, ?, ?, ?)";

            try (var pstmt = conn.prepareStatement(sql)) {
                // 첫 번째 뉴스
                pstmt.setString(1, "트랜잭션 뉴스 1");
                pstmt.setString(2, "트랜잭션 테스트");
                pstmt.setString(3, "언론사1");
                pstmt.setString(4, "http://example.com/1");
                pstmt.executeUpdate();

                // 두 번째 뉴스
                pstmt.setString(1, "트랜잭션 뉴스 2");
                pstmt.setString(2, "트랜잭션 테스트");
                pstmt.setString(3, "언론사2");
                pstmt.setString(4, "http://example.com/2");
                pstmt.executeUpdate();

            }
        });


        // 최종 카운트
        Object finalCount = DatabaseUtil.executeScalar("SELECT COUNT(*) FROM news");

    }
}
