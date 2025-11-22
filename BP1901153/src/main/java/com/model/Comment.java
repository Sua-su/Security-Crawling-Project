package com.model;

import java.sql.Timestamp;

/**
 * 댓글 DTO
 */
public class Comment {
    private int commentId;
    private int boardId;
    private int userId;
    private String content;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // 추가 정보 (JOIN 시)
    private String username;
    private String authorName;
    private String name; // 작성자 실명

    // 기본 생성자
    public Comment() {
    }

    // 작성용 생성자
    public Comment(int boardId, int userId, String content) {
        this.boardId = boardId;
        this.userId = userId;
        this.content = content;
    }

    // Getters and Setters
    public int getCommentId() {
        return commentId;
    }

    public void setCommentId(int commentId) {
        this.commentId = commentId;
    }

    public int getBoardId() {
        return boardId;
    }

    public void setBoardId(int boardId) {
        this.boardId = boardId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getAuthorName() {
        return authorName;
    }

    public void setAuthorName(String authorName) {
        this.authorName = authorName;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
