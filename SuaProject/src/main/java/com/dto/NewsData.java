package com.dto;

import java.util.List;
import java.util.Map;

public class NewsData {
    private int totalCount;
    private int todayCount;
    private int companyCount;
    private List<Map<String, Object>> companies;
    private List<Map<String, Object>> newsList;

    public int getTotalCount() {
        return totalCount;
    }

    public void setTotalCount(int totalCount) {
        this.totalCount = totalCount;
    }

    public int getTodayCount() {
        return todayCount;
    }

    public void setTodayCount(int todayCount) {
        this.todayCount = todayCount;
    }

    public int getCompanyCount() {
        return companyCount;
    }

    public void setCompanyCount(int companyCount) {
        this.companyCount = companyCount;
    }

    public List<Map<String, Object>> getCompanies() {
        return companies;
    }

    public void setCompanies(List<Map<String, Object>> companies) {
        this.companies = companies;
    }

    public List<Map<String, Object>> getNewsList() {
        return newsList;
    }

    public void setNewsList(List<Map<String, Object>> newsList) {
        this.newsList = newsList;
    }
}
