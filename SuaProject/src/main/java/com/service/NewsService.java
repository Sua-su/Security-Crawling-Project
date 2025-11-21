package com.service;

import com.crawler.DatabaseUtil;
import com.dto.NewsData;

import java.util.List;
import java.util.Map;

public class NewsService {

    public NewsData getNewsData() {
        NewsData newsData = new NewsData();

        try {
            // 전체 뉴스 수
            Object totalCount = DatabaseUtil.executeScalar("SELECT COUNT(*) FROM news");
            newsData.setTotalCount(totalCount != null ? ((Number) totalCount).intValue() : 0);

            // 오늘 저장된 뉴스
            Object todayCount = DatabaseUtil.executeScalar(
                    "SELECT COUNT(*) FROM news WHERE DATE(created_at) = CURDATE()");
            newsData.setTodayCount(todayCount != null ? ((Number) todayCount).intValue() : 0);

            // 언론사별 개수
            List<Map<String, Object>> companies = DatabaseUtil.executeQuery(
                    "SELECT company, COUNT(*) as cnt FROM news " +
                            "GROUP BY company ORDER BY cnt DESC LIMIT 5");
            newsData.setCompanies(companies);
            newsData.setCompanyCount(companies.size());

            // 최신 뉴스 목록
            List<Map<String, Object>> newsList = DatabaseUtil.executeQuery(
                    "SELECT * FROM news ORDER BY created_at DESC LIMIT 50");
            newsData.setNewsList(newsList);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return newsData;
    }
}
