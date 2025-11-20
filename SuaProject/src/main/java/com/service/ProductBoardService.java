package com.service;

import com.crawler.DatabaseUtil;
import com.dto.ProductBoardData;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class ProductBoardService {

    private static final int PAGE_SIZE = 9;

    public ProductBoardData getProductBoardData(String category, String sort,
            Integer minPrice, Integer maxPrice, int currentPage) {
        ProductBoardData data = new ProductBoardData();
        data.setPageSize(PAGE_SIZE);

        // 테이블 존재 여부 확인
        boolean productsReady = DatabaseUtil.tableExists("products");
        boolean newsReady = DatabaseUtil.tableExists("news");
        boolean crawlReady = DatabaseUtil.tableExists("crawl_log");

        data.setProductsReady(productsReady);
        data.setNewsReady(newsReady);
        data.setCrawlReady(crawlReady);

        List<String> warnings = new ArrayList<>();
        data.setIntegrationWarnings(warnings);

        // 상품 데이터 조회
        if (productsReady) {
            loadProductData(data, category, sort, minPrice, maxPrice, currentPage, warnings);
        } else {
            warnings.add("products 테이블을 찾을 수 없습니다. database/init.sql을 실행해 주세요.");
        }

        return data;
    }

    private void loadProductData(ProductBoardData data, String category, String sort,
            Integer minPrice, Integer maxPrice, int currentPage,
            List<String> warnings) {
        try {
            // 필터 조건 생성
            StringBuilder filter = new StringBuilder(" WHERE 1=1 ");
            List<Object> params = new ArrayList<>();

            if (category != null && !category.trim().isEmpty()) {
                filter.append(" AND category = ?");
                params.add(category.trim());
            }
            if (minPrice != null) {
                filter.append(" AND price >= ?");
                params.add(minPrice);
            }
            if (maxPrice != null) {
                filter.append(" AND price <= ?");
                params.add(maxPrice);
            }

            // 정렬 조건
            String orderSql = " ORDER BY created_at DESC";
            if ("priceAsc".equals(sort)) {
                orderSql = " ORDER BY price ASC";
            } else if ("priceDesc".equals(sort)) {
                orderSql = " ORDER BY price DESC";
            } else if ("stock".equals(sort)) {
                orderSql = " ORDER BY stock DESC";
            }

            // 전체 개수 조회
            Object totalCountObj = DatabaseUtil.executeScalar(
                    "SELECT COUNT(*) FROM products" + filter.toString(),
                    params.toArray(new Object[0]));
            int totalCount = totalCountObj instanceof Number ? ((Number) totalCountObj).intValue() : 0;
            int totalPages = Math.max(1, (int) Math.ceil(totalCount / (double) PAGE_SIZE));

            data.setTotalCount(totalCount);
            data.setTotalPages(totalPages);

            // 페이징 처리
            int offset = (currentPage - 1) * PAGE_SIZE;
            List<Object> dataParams = new ArrayList<>(params);
            dataParams.add(PAGE_SIZE);
            dataParams.add(offset);

            // 상품 목록 조회
            List<Map<String, Object>> productFeed = DatabaseUtil.executeQuery(
                    "SELECT product_id, name, description, price, stock, category, file_path, created_at " +
                            "FROM products" + filter.toString() + orderSql + " LIMIT ? OFFSET ?",
                    dataParams.toArray(new Object[0]));
            data.setProductFeed(productFeed);

            // 카테고리 통계
            List<Map<String, Object>> categoryStats = DatabaseUtil.executeQuery(
                    "SELECT category, COUNT(*) AS cnt FROM products GROUP BY category ORDER BY cnt DESC");
            data.setCategoryStats(categoryStats);

            // 전체 통계
            Object totalProductsObj = DatabaseUtil.executeScalar("SELECT COUNT(*) FROM products");
            data.setTotalProducts(totalProductsObj instanceof Number ? ((Number) totalProductsObj).longValue() : 0L);

            Object inventorySumObj = DatabaseUtil.executeScalar("SELECT IFNULL(SUM(stock), 0) FROM products");
            data.setInventoryStock(inventorySumObj instanceof Number ? ((Number) inventorySumObj).longValue() : 0L);

            // 뉴스 데이터 로드
            loadNewsData(data, warnings);

            // 크롤링 로그 데이터 로드
            loadCrawlLogData(data, warnings);

        } catch (Exception e) {
            warnings.add("상품 정보를 불러오지 못했습니다: " + e.getMessage());
        }
    }

    private void loadNewsData(ProductBoardData data, List<String> warnings) {
        if (!data.isNewsReady()) {
            return;
        }
        try {
            // 최신 뉴스 5건
            List<Map<String, Object>> latestNews = DatabaseUtil.executeQuery(
                    "SELECT title, company, created_at FROM news ORDER BY created_at DESC LIMIT 5");
            data.setLatestNews(latestNews);

            // 뉴스 통계
            Object totalNewsObj = DatabaseUtil.executeScalar("SELECT COUNT(*) FROM news");
            data.setTotalNews(totalNewsObj instanceof Number ? ((Number) totalNewsObj).longValue() : 0L);

            Object todayNewsObj = DatabaseUtil.executeScalar(
                    "SELECT COUNT(*) FROM news WHERE DATE(created_at) = CURDATE()");
            data.setTodayNews(todayNewsObj instanceof Number ? ((Number) todayNewsObj).longValue() : 0L);

            Object companyCountObj = DatabaseUtil.executeScalar(
                    "SELECT COUNT(DISTINCT company) FROM news");
            data.setCompanyCount(companyCountObj instanceof Number ? ((Number) companyCountObj).longValue() : 0L);

        } catch (Exception e) {
            warnings.add("뉴스 정보를 불러오지 못했습니다: " + e.getMessage());
        }
    }

    private void loadCrawlLogData(ProductBoardData data, List<String> warnings) {
        if (!data.isCrawlReady()) {
            return;
        }
        try {
            List<Map<String, Object>> crawlLogs = DatabaseUtil.executeQuery(
                    "SELECT status, items_count, crawled_at FROM crawl_log ORDER BY crawled_at DESC LIMIT 3");
            data.setCrawlLogs(crawlLogs);
        } catch (Exception e) {
            warnings.add("크롤링 로그를 불러오지 못했습니다: " + e.getMessage());
        }
    }
}
