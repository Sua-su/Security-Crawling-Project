package com.service;

import com.crawler.DatabaseUtil;
import java.util.*;

/**
 * 어드민 대시보드 통계 서비스
 */
public class AdminService {

    /**
     * 대시보드 전체 통계 조회
     */
    public Map<String, Object> getDashboardStats() {
        Map<String, Object> stats = new HashMap<>();

        // 회원 통계
        stats.put("totalUsers", getTotalUsers());
        stats.put("activeUsers", getActiveUsers());
        stats.put("newUsersToday", getNewUsersToday());
        stats.put("adminCount", getAdminCount());

        // 주문 통계
        stats.put("totalOrders", getTotalOrders());
        stats.put("pendingOrders", getPendingOrders());
        stats.put("completedOrders", getCompletedOrders());
        stats.put("totalRevenue", getTotalRevenue());
        stats.put("todayRevenue", getTodayRevenue());

        // 상품 통계
        stats.put("totalProducts", getTotalProducts());
        stats.put("activeProducts", getActiveProducts());
        stats.put("lowStockProducts", getLowStockProducts());
        stats.put("totalStock", getTotalStock());

        // 크롤링 통계
        stats.put("totalNews", getTotalNews());
        stats.put("todayNews", getTodayNews());
        stats.put("companyCount", getCompanyCount());
        stats.put("lastCrawlTime", getLastCrawlTime());

        // 최근 활동
        stats.put("recentOrders", getRecentOrders(5));
        stats.put("recentUsers", getRecentUsers(5));

        return stats;
    }

    // 회원 통계
    private long getTotalUsers() {
        Object result = DatabaseUtil.executeScalar("SELECT COUNT(*) FROM users");
        return result instanceof Number ? ((Number) result).longValue() : 0;
    }

    private long getActiveUsers() {
        Object result = DatabaseUtil.executeScalar("SELECT COUNT(*) FROM users WHERE status = 'ACTIVE'");
        return result instanceof Number ? ((Number) result).longValue() : 0;
    }

    private long getNewUsersToday() {
        Object result = DatabaseUtil.executeScalar(
                "SELECT COUNT(*) FROM users WHERE DATE(created_at) = CURDATE()");
        return result instanceof Number ? ((Number) result).longValue() : 0;
    }

    private long getAdminCount() {
        Object result = DatabaseUtil.executeScalar("SELECT COUNT(*) FROM users WHERE role = 'ADMIN'");
        return result instanceof Number ? ((Number) result).longValue() : 0;
    }

    // 주문 통계
    private long getTotalOrders() {
        Object result = DatabaseUtil.executeScalar("SELECT COUNT(*) FROM orders");
        return result instanceof Number ? ((Number) result).longValue() : 0;
    }

    private long getPendingOrders() {
        Object result = DatabaseUtil.executeScalar("SELECT COUNT(*) FROM orders WHERE status = 'PENDING'");
        return result instanceof Number ? ((Number) result).longValue() : 0;
    }

    private long getCompletedOrders() {
        Object result = DatabaseUtil.executeScalar("SELECT COUNT(*) FROM orders WHERE status = 'COMPLETED'");
        return result instanceof Number ? ((Number) result).longValue() : 0;
    }

    private long getTotalRevenue() {
        Object result = DatabaseUtil
                .executeScalar("SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE status = 'COMPLETED'");
        return result instanceof Number ? ((Number) result).longValue() : 0;
    }

    private long getTodayRevenue() {
        Object result = DatabaseUtil.executeScalar(
                "SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE status = 'COMPLETED' AND DATE(created_at) = CURDATE()");
        return result instanceof Number ? ((Number) result).longValue() : 0;
    }

    // 상품 통계
    private long getTotalProducts() {
        Object result = DatabaseUtil.executeScalar("SELECT COUNT(*) FROM products");
        return result instanceof Number ? ((Number) result).longValue() : 0;
    }

    private long getActiveProducts() {
        Object result = DatabaseUtil.executeScalar("SELECT COUNT(*) FROM products WHERE status = 'ACTIVE'");
        return result instanceof Number ? ((Number) result).longValue() : 0;
    }

    private long getLowStockProducts() {
        Object result = DatabaseUtil.executeScalar("SELECT COUNT(*) FROM products WHERE stock < 5");
        return result instanceof Number ? ((Number) result).longValue() : 0;
    }

    private long getTotalStock() {
        Object result = DatabaseUtil.executeScalar("SELECT COALESCE(SUM(stock), 0) FROM products");
        return result instanceof Number ? ((Number) result).longValue() : 0;
    }

    // 크롤링 통계
    private long getTotalNews() {
        Object result = DatabaseUtil.executeScalar("SELECT COUNT(*) FROM news");
        return result instanceof Number ? ((Number) result).longValue() : 0;
    }

    private long getTodayNews() {
        Object result = DatabaseUtil.executeScalar(
                "SELECT COUNT(*) FROM news WHERE DATE(created_at) = CURDATE()");
        return result instanceof Number ? ((Number) result).longValue() : 0;
    }

    private long getCompanyCount() {
        Object result = DatabaseUtil.executeScalar("SELECT COUNT(DISTINCT company) FROM news");
        return result instanceof Number ? ((Number) result).longValue() : 0;
    }

    private String getLastCrawlTime() {
        Object result = DatabaseUtil.executeScalar(
                "SELECT MAX(created_at) FROM news");
        return result != null ? result.toString() : "없음";
    }

    // 최근 활동
    private List<Map<String, Object>> getRecentOrders(int limit) {
        return DatabaseUtil.executeQuery(
                "SELECT o.order_id, o.user_id, u.username, o.total_amount, o.status, o.created_at " +
                        "FROM orders o JOIN users u ON o.user_id = u.user_id " +
                        "ORDER BY o.created_at DESC LIMIT ?",
                limit);
    }

    private List<Map<String, Object>> getRecentUsers(int limit) {
        return DatabaseUtil.executeQuery(
                "SELECT user_id, username, name, email, role, status, created_at " +
                        "FROM users ORDER BY created_at DESC LIMIT ?",
                limit);
    }

    /**
     * 월별 매출 통계 (최근 6개월)
     */
    public List<Map<String, Object>> getMonthlyRevenue() {
        return DatabaseUtil.executeQuery(
                "SELECT DATE_FORMAT(created_at, '%Y-%m') as month, " +
                        "COUNT(*) as order_count, " +
                        "SUM(total_amount) as revenue " +
                        "FROM orders " +
                        "WHERE status = 'COMPLETED' AND created_at >= DATE_SUB(NOW(), INTERVAL 6 MONTH) " +
                        "GROUP BY DATE_FORMAT(created_at, '%Y-%m') " +
                        "ORDER BY month DESC");
    }

    /**
     * 카테고리별 상품 통계
     */
    public List<Map<String, Object>> getCategoryStats() {
        return DatabaseUtil.executeQuery(
                "SELECT category, COUNT(*) as count, SUM(stock) as total_stock " +
                        "FROM products " +
                        "GROUP BY category " +
                        "ORDER BY count DESC");
    }
}
