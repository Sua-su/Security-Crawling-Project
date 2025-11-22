package com.service;

import com.dao.BoardDAO;
import com.dto.BoardListData;
import com.model.Board;

import java.util.List;

public class BoardService {

    private BoardDAO boardDAO;

    public BoardService() {
        this.boardDAO = new BoardDAO();
    }

    public BoardListData getBoardList(int currentPage, String keyword) {
        BoardListData data = new BoardListData();
        data.setCurrentPage(currentPage);
        data.setKeyword(keyword);

        boolean isSearch = (keyword != null && !keyword.trim().isEmpty());
        data.setSearch(isSearch);

        List<Board> posts;
        int totalCount;

        if (isSearch) {
            posts = boardDAO.searchPosts(keyword, currentPage, data.getPageSize());
            totalCount = boardDAO.getSearchCount(keyword);
        } else {
            posts = boardDAO.getPosts(currentPage, data.getPageSize());
            totalCount = boardDAO.getTotalCount();
        }

        data.setPosts(posts);
        data.setTotalCount(totalCount);

        int totalPages = (int) Math.ceil((double) totalCount / data.getPageSize());
        data.setTotalPages(Math.max(1, totalPages));

        return data;
    }

    public Board getPost(int postId) {
        return boardDAO.getPostById(postId);
    }

    public boolean createPost(Board board) {
        try {
            return boardDAO.createPost(board);
        } catch (Exception e) {
            return false;
        }
    }

    public boolean updatePost(Board board) {
        try {
            return boardDAO.updatePost(board);
        } catch (Exception e) {
            return false;
        }
    }

    public boolean deletePost(int postId, int userId, boolean isAdmin) {
        try {
            return boardDAO.deletePost(postId, userId, isAdmin);
        } catch (Exception e) {
            return false;
        }
    }

    public void incrementViewCount(int postId) {
        try {
            boardDAO.increaseViews(postId);
        } catch (Exception e) {
        }
    }
}
