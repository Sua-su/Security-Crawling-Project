package com.service;

import com.crawler.DatabaseUtil;
import com.dto.DashboardData;

import java.util.List;
import java.util.Map;

/**
 * 대시보드 관련 비즈니스 로직을 처리하는 서비스 클래스
 */
public class DashboardService {

    /**
     * 대시보드에 필요한 모든 데이터를 조회하여 반환
     */
    public DashboardData getDashboardData() {
        DashboardData data = new DashboardData();

        // 테이블 존재 여부 확인
        boolean newsTableReady = DatabaseUtil.tableExists("news");
        boolean boardTableReady = DatabaseUtil.tableExists("board");
        boolean productTableReady = DatabaseUtil.tableExists("products");
        boolean ordersTableReady = DatabaseUtil.tableExists("orders");

        data.setNewsTableReady(newsTableReady);
        data.setBoardTableReady(boardTableReady);
        data.setProductTableReady(productTableReady);
        data.setOrdersTableReady(ordersTableReady);

        try {
            // 뉴스 데이터 조회
            if (newsTableReady) {
                loadNewsData(data);
            } else {
                data.setErrorMsg("news 테이블을 찾을 수 없습니다. database/init.sql을 실행해주세요.");
            }

            // 게시판 데이터 조회
            if (boardTableReady) {
                loadBoardData(data);
            }

            // 상품 데이터 조회
            if (productTableReady) {
                loadProductData(data);
            }

            // 주문 데이터 조회
            if (ordersTableReady) {
                loadOrderData(data);
            }

        } catch (Exception e) {
            data.setErrorMsg(e.getMessage());
        }

        // DB 연결 상태 설정
        data.setConnected(newsTableReady && data.getErrorMsg() == null);

        return data;
    }

    /**
     * 뉴스 데이터 로드
     */
    private void loadNewsData(DashboardData data) {
        // 전체 뉴스 수
        Object newsCountObj = DatabaseUtil.executeScalar("SELECT COUNT(*) FROM news");
        if (newsCountObj instanceof Number) {
            data.setNewsCount(((Number) newsCountObj).longValue());
        }

        // 오늘 수집한 뉴스 수
        Object todayCountObj = DatabaseUtil.executeScalar(
                "SELECT COUNT(*) FROM news WHERE DATE(created_at) = CURDATE()");
        if (todayCountObj instanceof Number) {
            data.setTodayCount(((Number) todayCountObj).longValue());
        }

        // 최신 뉴스 4개
        List<Map<String, Object>> latestNews = DatabaseUtil.executeQuery(
                "SELECT title, company, created_at FROM news ORDER BY created_at DESC LIMIT 4");
        data.setLatestNews(latestNews);
    }

    /**
     * 게시판 데이터 로드
     */
    private void loadBoardData(DashboardData data) {
        // 전체 게시글 수
        Object boardCountObj = DatabaseUtil.executeScalar("SELECT COUNT(*) FROM board");
        if (boardCountObj instanceof Number) {
            data.setBoardCount(((Number) boardCountObj).longValue());
        }

        // 최신 게시글 4개 (댓글 수 포함)
        List<Map<String, Object>> latestBoardPosts = DatabaseUtil.executeQuery(
                "SELECT b.title, IFNULL(u.name, u.username) AS author, b.created_at, " +
                        "(SELECT COUNT(*) FROM comments c WHERE c.board_id = b.board_id) AS comment_count " +
                        "FROM board b JOIN users u ON b.user_id = u.user_id " +
                        "ORDER BY b.created_at DESC LIMIT 4");
        data.setLatestBoardPosts(latestBoardPosts);
    }

    /**
     * 상품 데이터 로드
     */
    private void loadProductData(DashboardData data) {
        // 전체 상품 수
        Object productCountObj = DatabaseUtil.executeScalar("SELECT COUNT(*) FROM products");
        if (productCountObj instanceof Number) {
            data.setProductCount(((Number) productCountObj).longValue());
        }

        // 최신 상품 4개
        List<Map<String, Object>> latestProducts = DatabaseUtil.executeQuery(
                "SELECT product_name, description, price, status, created_at FROM products ORDER BY created_at DESC LIMIT 4");
        data.setLatestProducts(latestProducts);
    }

    /**
     * 주문 데이터 로드
     */
    private void loadOrderData(DashboardData data) {
        // 전체 주문 수
        Object orderCountObj = DatabaseUtil.executeScalar("SELECT COUNT(*) FROM orders");
        if (orderCountObj instanceof Number) {
            data.setOrderCount(((Number) orderCountObj).longValue());
        }
    }
}
