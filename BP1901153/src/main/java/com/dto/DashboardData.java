package com.dto;

import java.util.List;
import java.util.Map;

/**
 * 대시보드 화면에 필요한 모든 데이터를 담는 DTO
 */
public class DashboardData {
    private long newsCount;
    private long todayCount;
    private long boardCount;
    private long productCount;
    private long orderCount;

    private List<Map<String, Object>> latestNews;
    private List<Map<String, Object>> latestProducts;
    private List<Map<String, Object>> latestBoardPosts;

    private boolean newsTableReady;
    private boolean boardTableReady;
    private boolean productTableReady;
    private boolean ordersTableReady;
    private boolean isConnected;

    private String errorMsg;

    // Constructors
    public DashboardData() {
    }

    // Getters and Setters
    public long getNewsCount() {
        return newsCount;
    }

    public void setNewsCount(long newsCount) {
        this.newsCount = newsCount;
    }

    public long getTodayCount() {
        return todayCount;
    }

    public void setTodayCount(long todayCount) {
        this.todayCount = todayCount;
    }

    public long getBoardCount() {
        return boardCount;
    }

    public void setBoardCount(long boardCount) {
        this.boardCount = boardCount;
    }

    public long getProductCount() {
        return productCount;
    }

    public void setProductCount(long productCount) {
        this.productCount = productCount;
    }

    public long getOrderCount() {
        return orderCount;
    }

    public void setOrderCount(long orderCount) {
        this.orderCount = orderCount;
    }

    public List<Map<String, Object>> getLatestNews() {
        return latestNews;
    }

    public void setLatestNews(List<Map<String, Object>> latestNews) {
        this.latestNews = latestNews;
    }

    public List<Map<String, Object>> getLatestProducts() {
        return latestProducts;
    }

    public void setLatestProducts(List<Map<String, Object>> latestProducts) {
        this.latestProducts = latestProducts;
    }

    public List<Map<String, Object>> getLatestBoardPosts() {
        return latestBoardPosts;
    }

    public void setLatestBoardPosts(List<Map<String, Object>> latestBoardPosts) {
        this.latestBoardPosts = latestBoardPosts;
    }

    public boolean isNewsTableReady() {
        return newsTableReady;
    }

    public void setNewsTableReady(boolean newsTableReady) {
        this.newsTableReady = newsTableReady;
    }

    public boolean isBoardTableReady() {
        return boardTableReady;
    }

    public void setBoardTableReady(boolean boardTableReady) {
        this.boardTableReady = boardTableReady;
    }

    public boolean isProductTableReady() {
        return productTableReady;
    }

    public void setProductTableReady(boolean productTableReady) {
        this.productTableReady = productTableReady;
    }

    public boolean isOrdersTableReady() {
        return ordersTableReady;
    }

    public void setOrdersTableReady(boolean ordersTableReady) {
        this.ordersTableReady = ordersTableReady;
    }

    public boolean isConnected() {
        return isConnected;
    }

    public void setConnected(boolean connected) {
        isConnected = connected;
    }

    public String getErrorMsg() {
        return errorMsg;
    }

    public void setErrorMsg(String errorMsg) {
        this.errorMsg = errorMsg;
    }
}
