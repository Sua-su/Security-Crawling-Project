package com.dao;

import com.model.Comment;
import db.DBConnect;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CommentDAO {

    // 댓글 작성
    public boolean createComment(Comment comment) {
        String sql = "INSERT INTO comments (board_id, user_id, content) VALUES (?, ?, ?)";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setInt(1, comment.getBoardId());
            pstmt.setInt(2, comment.getUserId());
            pstmt.setString(3, comment.getContent());

            int result = pstmt.executeUpdate();

            if (result > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    comment.setCommentId(rs.getInt(1));
                }
                return true;
            }
            return false;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 댓글 수정
    public boolean updateComment(Comment comment) {
        String sql = "UPDATE comments SET content = ? WHERE comment_id = ? AND user_id = ?";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, comment.getContent());
            pstmt.setInt(2, comment.getCommentId());
            pstmt.setInt(3, comment.getUserId());

            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 댓글 삭제
    public boolean deleteComment(int commentId, int userId) {
        String sql = "DELETE FROM comments WHERE comment_id = ? AND user_id = ?";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, commentId);
            pstmt.setInt(2, userId);

            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 특정 게시글의 댓글 목록
    public List<Comment> getCommentsByBoardId(int boardId) {
        List<Comment> comments = new ArrayList<>();

        String sql = "SELECT c.*, u.username, u.name FROM comments c " +
                "JOIN users u ON c.user_id = u.user_id " +
                "WHERE c.board_id = ? " +
                "ORDER BY c.created_at ASC";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, boardId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Comment comment = new Comment();
                comment.setCommentId(rs.getInt("comment_id"));
                comment.setBoardId(rs.getInt("board_id"));
                comment.setUserId(rs.getInt("user_id"));
                comment.setContent(rs.getString("content"));
                comment.setCreatedAt(rs.getTimestamp("created_at"));
                comment.setUpdatedAt(rs.getTimestamp("updated_at"));
                comment.setUsername(rs.getString("username"));
                comment.setName(rs.getString("name"));
                comments.add(comment);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return comments;
    }

    // 특정 게시글의 댓글 수
    public int getCommentCount(int boardId) {
        String sql = "SELECT COUNT(*) FROM comments WHERE board_id = ?";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, boardId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 댓글 상세 조회
    public Comment getCommentById(int commentId) {
        String sql = "SELECT c.*, u.username, u.name FROM comments c " +
                "JOIN users u ON c.user_id = u.user_id " +
                "WHERE c.comment_id = ?";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, commentId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                Comment comment = new Comment();
                comment.setCommentId(rs.getInt("comment_id"));
                comment.setBoardId(rs.getInt("board_id"));
                comment.setUserId(rs.getInt("user_id"));
                comment.setContent(rs.getString("content"));
                comment.setCreatedAt(rs.getTimestamp("created_at"));
                comment.setUpdatedAt(rs.getTimestamp("updated_at"));
                comment.setUsername(rs.getString("username"));
                comment.setName(rs.getString("name"));
                return comment;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
