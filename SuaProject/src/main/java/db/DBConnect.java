package db;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import java.sql.Connection;
import java.sql.SQLException;

public class DBConnect {
    private static final String URL = "jdbc:mariadb://localhost:13306/BP1901153";
    private static final String USER = "root";
    private static final String PASSWORD = "1234";

    private static HikariDataSource dataSource;

    static {
        try {
            HikariConfig config = new HikariConfig();
            config.setJdbcUrl(URL);
            config.setUsername(USER);
            config.setPassword(PASSWORD);
            config.setDriverClassName("org.mariadb.jdbc.Driver");

            // Connection Pool 설정
            config.setMaximumPoolSize(10);
            config.setMinimumIdle(2);
            config.setConnectionTimeout(30000);
            config.setIdleTimeout(600000);
            config.setMaxLifetime(1800000);

            // 성능 최적화
            config.addDataSourceProperty("cachePrepStmts", "true");
            config.addDataSourceProperty("prepStmtCacheSize", "250");
            config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");

            dataSource = new HikariDataSource(config);
            System.out.println("✅ HikariCP Connection Pool 초기화 성공! (포트: 13306)");
        } catch (Exception e) {
            System.err.println("❌ Connection Pool 초기화 실패: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Connection Pool에서 연결을 가져옵니다.
     * 
     * @return DB 연결 객체
     */
    public static Connection getConnection() throws SQLException {
        if (dataSource == null) {
            throw new SQLException("DataSource가 초기화되지 않았습니다.");
        }
        return dataSource.getConnection();
    }

    /**
     * Connection Pool을 종료합니다. (애플리케이션 종료 시 호출)
     */
    public static void close() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
            System.out.println("✅ Connection Pool 종료");
        }
    }

    /**
     * Connection Pool 상태 확인
     */
    public static void printPoolStats() {
        if (dataSource != null) {
            System.out.println("=== Connection Pool 상태 ===");
            System.out.println("활성 연결: " + (dataSource.getHikariPoolMXBean().getActiveConnections()));
            System.out.println("대기 연결: " + (dataSource.getHikariPoolMXBean().getIdleConnections()));
            System.out.println("총 연결: " + (dataSource.getHikariPoolMXBean().getTotalConnections()));
            System.out.println("대기 중인 스레드: " + (dataSource.getHikariPoolMXBean().getThreadsAwaitingConnection()));
        }
    }
}
