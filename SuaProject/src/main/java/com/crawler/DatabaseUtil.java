package com.crawler;

import db.DBConnect;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 데이터베이스 유틸리티 클래스
 * CRUD 작업을 간편하게 수행할 수 있는 헬퍼 메서드 제공
 */
public class DatabaseUtil {

    /**
     * SELECT 쿼리 실행 (여러 행 반환)
     * 
     * @param sql    SQL 쿼리
     * @param params 파라미터 배열
     * @return 결과 리스트 (각 행은 Map<컬럼명, 값>)
     */
    public static List<Map<String, Object>> executeQuery(String sql, Object... params) {
        List<Map<String, Object>> results = new ArrayList<>();

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            // 파라미터 설정
            setParameters(pstmt, params);

            try (ResultSet rs = pstmt.executeQuery()) {
                ResultSetMetaData metaData = rs.getMetaData();
                int columnCount = metaData.getColumnCount();

                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    for (int i = 1; i <= columnCount; i++) {
                        String columnName = metaData.getColumnLabel(i);
                        Object value = rs.getObject(i);
                        row.put(columnName, value);
                    }
                    results.add(row);
                }
            }
        } catch (SQLException e) {
            System.err.println("❌ 쿼리 실행 오류: " + e.getMessage());
            e.printStackTrace();
        }

        return results;
    }

    /**
     * INSERT, UPDATE, DELETE 쿼리 실행
     * 
     * @param sql    SQL 쿼리
     * @param params 파라미터 배열
     * @return 영향받은 행의 개수
     */
    public static int executeUpdate(String sql, Object... params) {
        int affectedRows = 0;

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            setParameters(pstmt, params);
            affectedRows = pstmt.executeUpdate();

        } catch (SQLException e) {
            System.err.println("❌ 업데이트 실행 오류: " + e.getMessage());
            e.printStackTrace();
        }

        return affectedRows;
    }

    /**
     * INSERT 쿼리 실행 후 생성된 키 반환
     * 
     * @param sql    SQL 쿼리
     * @param params 파라미터 배열
     * @return 생성된 키 값 (auto_increment)
     */
    public static long executeInsertWithKey(String sql, Object... params) {
        long generatedKey = -1;

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            setParameters(pstmt, params);
            int affectedRows = pstmt.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedKey = rs.getLong(1);
                    }
                }
            }

        } catch (SQLException e) {
            System.err.println("❌ INSERT 실행 오류: " + e.getMessage());
            e.printStackTrace();
        }

        return generatedKey;
    }

    /**
     * 단일 값 조회 (COUNT, SUM 등)
     * 
     * @param sql    SQL 쿼리
     * @param params 파라미터 배열
     * @return 첫 번째 컬럼의 값
     */
    public static Object executeScalar(String sql, Object... params) {
        Object result = null;

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            setParameters(pstmt, params);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    result = rs.getObject(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("❌ 스칼라 쿼리 실행 오류: " + e.getMessage());
            e.printStackTrace();
        }

        return result;
    }

    /**
     * 트랜잭션 실행
     * 
     * @param operations 트랜잭션 작업
     * @return 성공 여부
     */
    public static boolean executeTransaction(TransactionOperation operations) {
        Connection conn = null;
        try {
            conn = DBConnect.getConnection();
            conn.setAutoCommit(false);

            operations.execute(conn);

            conn.commit();
            return true;

        } catch (Exception e) {
            System.err.println("❌ 트랜잭션 실행 오류: " + e.getMessage());
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                    System.out.println("⚠️ 트랜잭션 롤백됨");
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * PreparedStatement에 파라미터 설정
     */
    private static void setParameters(PreparedStatement pstmt, Object... params) throws SQLException {
        for (int i = 0; i < params.length; i++) {
            pstmt.setObject(i + 1, params[i]);
        }
    }

    /**
     * 테이블 존재 여부 확인
     */
    public static boolean tableExists(String tableName) {
        try (Connection conn = DBConnect.getConnection()) {
            DatabaseMetaData metaData = conn.getMetaData();
            try (ResultSet rs = metaData.getTables(null, null, tableName, new String[] { "TABLE" })) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.err.println("❌ 테이블 존재 확인 오류: " + e.getMessage());
            return false;
        }
    }

    /**
     * 트랜잭션 작업을 위한 함수형 인터페이스
     */
    @FunctionalInterface
    public interface TransactionOperation {
        void execute(Connection conn) throws Exception;
    }
}
