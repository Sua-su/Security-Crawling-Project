package com.dto;

import java.util.List;
import java.util.Map;

public class ProductBoardData {
    private boolean productsReady;
    private boolean newsReady;
    private boolean crawlReady;

    private int totalCount;
    private int totalPages;
    private int pageSize;

    private List<Map<String, Object>> productFeed;
    private List<Map<String, Object>> categoryStats;
    private List<String> integrationWarnings;

    private long totalProducts;
    private long inventoryStock;

    // News data
    private List<Map<String, Object>> latestNews;
    private long totalNews;
    private long todayNews;
    private long companyCount;

    // Crawl log data
    private List<Map<String, Object>> crawlLogs;

    public ProductBoardData() {
        this.pageSize = 9;
    }

    // Getters and Setters
    public boolean isProductsReady() {
        return productsReady;
    }

    public void setProductsReady(boolean productsReady) {
        this.productsReady = productsReady;
    }

    public boolean isNewsReady() {
        return newsReady;
    }

    public void setNewsReady(boolean newsReady) {
        this.newsReady = newsReady;
    }

    public boolean isCrawlReady() {
        return crawlReady;
    }

    public void setCrawlReady(boolean crawlReady) {
        this.crawlReady = crawlReady;
    }

    public int getTotalCount() {
        return totalCount;
    }

    public void setTotalCount(int totalCount) {
        this.totalCount = totalCount;
    }

    public int getTotalPages() {
        return totalPages;
    }

    public void setTotalPages(int totalPages) {
        this.totalPages = totalPages;
    }

    public int getPageSize() {
        return pageSize;
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }

    public List<Map<String, Object>> getProductFeed() {
        return productFeed;
    }

    public void setProductFeed(List<Map<String, Object>> productFeed) {
        this.productFeed = productFeed;
    }

    public List<Map<String, Object>> getCategoryStats() {
        return categoryStats;
    }

    public void setCategoryStats(List<Map<String, Object>> categoryStats) {
        this.categoryStats = categoryStats;
    }

    public List<String> getIntegrationWarnings() {
        return integrationWarnings;
    }

    public void setIntegrationWarnings(List<String> integrationWarnings) {
        this.integrationWarnings = integrationWarnings;
    }

    public long getTotalProducts() {
        return totalProducts;
    }

    public void setTotalProducts(long totalProducts) {
        this.totalProducts = totalProducts;
    }

    public long getInventoryStock() {
        return inventoryStock;
    }

    public void setInventoryStock(long inventoryStock) {
        this.inventoryStock = inventoryStock;
    }

    public List<Map<String, Object>> getLatestNews() {
        return latestNews;
    }

    public void setLatestNews(List<Map<String, Object>> latestNews) {
        this.latestNews = latestNews;
    }

    public long getTotalNews() {
        return totalNews;
    }

    public void setTotalNews(long totalNews) {
        this.totalNews = totalNews;
    }

    public long getTodayNews() {
        return todayNews;
    }

    public void setTodayNews(long todayNews) {
        this.todayNews = todayNews;
    }

    public long getCompanyCount() {
        return companyCount;
    }

    public void setCompanyCount(long companyCount) {
        this.companyCount = companyCount;
    }

    public List<Map<String, Object>> getCrawlLogs() {
        return crawlLogs;
    }

    public void setCrawlLogs(List<Map<String, Object>> crawlLogs) {
        this.crawlLogs = crawlLogs;
    }
}
