package com.dto;

import com.model.User;
import com.model.Order;
import java.util.List;

public class MyPageData {
    private User user;
    private List<Order> orders;
    private int totalSpent;
    private int completedOrderCount;
    private String activeTab;

    public MyPageData() {
        this.activeTab = "info";
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public List<Order> getOrders() {
        return orders;
    }

    public void setOrders(List<Order> orders) {
        this.orders = orders;
    }

    public int getTotalSpent() {
        return totalSpent;
    }

    public void setTotalSpent(int totalSpent) {
        this.totalSpent = totalSpent;
    }

    public int getCompletedOrderCount() {
        return completedOrderCount;
    }

    public void setCompletedOrderCount(int completedOrderCount) {
        this.completedOrderCount = completedOrderCount;
    }

    public String getActiveTab() {
        return activeTab;
    }

    public void setActiveTab(String activeTab) {
        this.activeTab = activeTab != null ? activeTab : "info";
    }

    public int getOrderCount() {
        return orders != null ? orders.size() : 0;
    }
}
