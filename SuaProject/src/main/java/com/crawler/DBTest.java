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
        System.out.println("=== MariaDB 연결 테스트 시작 (포트: 13306) ===\n");

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

        System.out.println("\n=== 모든 테스트 완료 ===");

        // Connection Pool 종료
        DBConnect.close();
    }

    /**
     * 1. 기본 연결 테스트
     */
    private static void testConnection() {
        System.out.println("【1】 기본 연결 테스트");
        try (Connection conn = DBConnect.getConnection()) {
            if (conn != null && !conn.isClosed()) {
                System.out.println("✅ DB 연결 성공!");
                System.out.println("   - DB: " + conn.getCatalog());
                System.out.println("   - Auto Commit: " + conn.getAutoCommit());
            }
        } catch (Exception e) {
            System.err.println("❌ 연결 실패: " + e.getMessage());
        }
        System.out.println();
    }

    /**
     * 2. Connection Pool 상태
     */
    private static void testPoolStats() {
        System.out.println("【2】 Connection Pool 상태");
        DBConnect.printPoolStats();
        System.out.println();
    }

    /**
     * 3. 뉴스 테이블 생성
     */
    private static void createNewsTable() {
        System.out.println("【3】 news 테이블 생성");

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
            System.out.println("   기존 테이블 삭제");

            stmt.executeUpdate(createSql);
            System.out.println("✅ news 테이블 생성 완료");

        } catch (Exception e) {
            System.err.println("❌ 테이블 생성 실패: " + e.getMessage());
        }
        System.out.println();
    }

    /**
     * 4. CRUD 테스트
     */
    private static void testCRUD() {
        System.out.println("【4】 CRUD 작업 테스트");

        // INSERT
        String insertSql = "INSERT INTO news (title, preview, company, link) VALUES (?, ?, ?, ?)";
        int rows = DatabaseUtil.executeUpdate(
                insertSql,
                "테스트 뉴스 제목",
                "이것은 테스트 뉴스입니다.",
                "테스트 언론사",
                "https://example.com/news/1");
        System.out.println("   INSERT: " + rows + "행 추가됨");

        // SELECT
        String selectSql = "SELECT * FROM news";
        List<Map<String, Object>> results = DatabaseUtil.executeQuery(selectSql);
        System.out.println("   SELECT: " + results.size() + "행 조회됨");

        for (Map<String, Object> row : results) {
            System.out.println("   - ID: " + row.get("id") + ", 제목: " + row.get("title"));
        }

        // COUNT
        Object count = DatabaseUtil.executeScalar("SELECT COUNT(*) FROM news");
        System.out.println("   COUNT: " + count + "개");

        System.out.println("✅ CRUD 테스트 완료");
        System.out.println();
    }

    /**
     * 5. DatabaseUtil 고급 기능 테스트
     */
    private static void testDatabaseUtil() {
        System.out.println("【5】 DatabaseUtil 고급 기능 테스트");

        // 테이블 존재 확인
        boolean exists = DatabaseUtil.tableExists("news");
        System.out.println("   테이블 존재: " + (exists ? "✅ 예" : "❌ 아니오"));

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

                System.out.println("   트랜잭션으로 2개 뉴스 추가");
            }
        });

        System.out.println("   트랜잭션: " + (success ? "✅ 성공" : "❌ 실패"));

        // 최종 카운트
        Object finalCount = DatabaseUtil.executeScalar("SELECT COUNT(*) FROM news");
        System.out.println("   최종 뉴스 개수: " + finalCount);

        System.out.println("✅ 고급 기능 테스트 완료");
    }
}
