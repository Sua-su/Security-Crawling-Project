package com.dto;

import com.model.Board;
import java.util.List;

public class BoardListData {
    private List<Board> posts;
    private int totalCount;
    private int currentPage;
    private int totalPages;
    private int pageSize;
    private String keyword;
    private boolean isSearch;

    public BoardListData() {
        this.pageSize = 10;
        this.currentPage = 1;
    }

    public List<Board> getPosts() {
        return posts;
    }

    public void setPosts(List<Board> posts) {
        this.posts = posts;
    }

    public int getTotalCount() {
        return totalCount;
    }

    public void setTotalCount(int totalCount) {
        this.totalCount = totalCount;
    }

    public int getCurrentPage() {
        return currentPage;
    }

    public void setCurrentPage(int currentPage) {
        this.currentPage = currentPage;
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

    public String getKeyword() {
        return keyword;
    }

    public void setKeyword(String keyword) {
        this.keyword = keyword;
    }

    public boolean isSearch() {
        return isSearch;
    }

    public void setSearch(boolean search) {
        isSearch = search;
    }

    public boolean hasPosts() {
        return posts != null && !posts.isEmpty();
    }
}
