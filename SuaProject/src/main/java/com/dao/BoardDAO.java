package com.dao;

import com.model.Board;
import db.DBConnect;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BoardDAO {

    // 게시글 작성
    public boolean createPost(Board board) {
        String sql = "INSERT INTO board (user_id, title, content) VALUES (?, ?, ?)";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setInt(1, board.getUserId());
            pstmt.setString(2, board.getTitle());
            pstmt.setString(3, board.getContent());

            int result = pstmt.executeUpdate();

            if (result > 0) {
                // 생성된 board_id 가져오기
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    board.setBoardId(rs.getInt(1));
                }
                System.out.println("✅ 게시글 작성 성공 - board_id: " + board.getBoardId() + ", title: " + board.getTitle());
                return true;
            }
            System.out.println("❌ 게시글 작성 실패");
            return false;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 게시글 수정
    public boolean updatePost(Board board) {
        String sql = "UPDATE board SET title = ?, content = ? WHERE board_id = ? AND user_id = ?";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, board.getTitle());
            pstmt.setString(2, board.getContent());
            pstmt.setInt(3, board.getBoardId());
            pstmt.setInt(4, board.getUserId());

            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 게시글 삭제
    public boolean deletePost(int boardId, int userId, boolean isAdmin) {
        String sql;
        if (isAdmin) {
            // 어드민은 user_id 체크 없이 삭제 가능
            sql = "DELETE FROM board WHERE board_id = ?";
        } else {
            // 일반 유저는 자신의 게시글만 삭제 가능
            sql = "DELETE FROM board WHERE board_id = ? AND user_id = ?";
        }

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, boardId);
            if (!isAdmin) {
                pstmt.setInt(2, userId);
            }

            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 게시글 상세 조회
    public Board getPostById(int boardId) {
        String sql = "SELECT b.*, u.username, u.name FROM board b " +
                "JOIN users u ON b.user_id = u.user_id " +
                "WHERE b.board_id = ?";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, boardId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                Board board = new Board();
                board.setBoardId(rs.getInt("board_id"));
                board.setUserId(rs.getInt("user_id"));
                board.setTitle(rs.getString("title"));
                board.setContent(rs.getString("content"));
                board.setViews(rs.getInt("view_count"));
                board.setCreatedAt(rs.getTimestamp("created_at"));
                board.setUpdatedAt(rs.getTimestamp("updated_at"));
                board.setUsername(rs.getString("username"));
                board.setName(rs.getString("name"));
                return board;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // 조회수 증가
    public void increaseViews(int boardId) {
        String sql = "UPDATE board SET view_count = view_count + 1 WHERE board_id = ?";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, boardId);
            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 게시글 목록 조회 (페이징)
    public List<Board> getPosts(int page, int pageSize) {
        List<Board> posts = new ArrayList<>();
        int offset = (page - 1) * pageSize;

        String sql = "SELECT b.board_id, b.user_id, b.title, b.view_count, b.created_at, " +
                "u.username, u.name, " +
                "(SELECT COUNT(*) FROM comments c WHERE c.board_id = b.board_id) as comment_count " +
                "FROM board b " +
                "JOIN users u ON b.user_id = u.user_id " +
                "ORDER BY b.created_at DESC " +
                "LIMIT ? OFFSET ?";

        System.out.println("🔍 게시글 목록 쿼리 실행 - page: " + page + ", pageSize: " + pageSize + ", offset: " + offset);

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, pageSize);
            pstmt.setInt(2, offset);

            System.out.println("📝 SQL: " + sql);
            System.out.println("📝 LIMIT: " + pageSize + ", OFFSET: " + offset);

            ResultSet rs = pstmt.executeQuery();

            int rowCount = 0;
            while (rs.next()) {
                rowCount++;
                Board board = new Board();
                board.setBoardId(rs.getInt("board_id"));
                board.setUserId(rs.getInt("user_id"));
                board.setTitle(rs.getString("title"));
                board.setViews(rs.getInt("view_count"));
                board.setCreatedAt(rs.getTimestamp("created_at"));
                board.setUsername(rs.getString("username"));
                board.setName(rs.getString("name"));
                board.setCommentCount(rs.getInt("comment_count"));
                posts.add(board);
                System.out.println("  ✓ 게시글 " + rowCount + ": " + board.getTitle());
            }
            System.out.println(
                    "📋 게시글 목록 조회 완료 - 총 " + posts.size() + "개 (page: " + page + ", pageSize: " + pageSize + ")");

        } catch (SQLException e) {
            System.out.println("❌ 게시글 목록 조회 중 오류: " + e.getMessage());
            e.printStackTrace();
        }
        return posts;
    }

    // 전체 게시글 수
    public int getTotalCount() {
        String sql = "SELECT COUNT(*) FROM board";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                int count = rs.getInt(1);
                System.out.println("🔢 전체 게시글 수: " + count);
                return count;
            }

        } catch (SQLException e) {
            System.out.println("❌ 게시글 수 조회 실패: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    // 검색 결과 수
    public int getSearchCount(String keyword) {
        String sql = "SELECT COUNT(*) FROM board WHERE title LIKE ? OR content LIKE ?";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            String searchPattern = "%" + keyword + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);

            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 게시글 검색 (페이징)
    public List<Board> searchPosts(String keyword, int page, int pageSize) {
        List<Board> posts = new ArrayList<>();
        int offset = (page - 1) * pageSize;

        String sql = "SELECT b.board_id, b.user_id, b.title, b.view_count, b.created_at, " +
                "u.username, u.name, " +
                "(SELECT COUNT(*) FROM comments c WHERE c.board_id = b.board_id) as comment_count " +
                "FROM board b " +
                "JOIN users u ON b.user_id = u.user_id " +
                "WHERE b.title LIKE ? OR b.content LIKE ? " +
                "ORDER BY b.created_at DESC " +
                "LIMIT ? OFFSET ?";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            String searchPattern = "%" + keyword + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            pstmt.setInt(3, pageSize);
            pstmt.setInt(4, offset);

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Board board = new Board();
                board.setBoardId(rs.getInt("board_id"));
                board.setUserId(rs.getInt("user_id"));
                board.setTitle(rs.getString("title"));
                board.setViews(rs.getInt("view_count"));
                board.setCreatedAt(rs.getTimestamp("created_at"));
                board.setUsername(rs.getString("username"));
                board.setName(rs.getString("name"));
                board.setCommentCount(rs.getInt("comment_count"));
                posts.add(board);
            }
            System.out.println("🔍 게시글 검색 - 키워드: '" + keyword + "', 결과: " + posts.size() + "개");

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return posts;
    }
}
