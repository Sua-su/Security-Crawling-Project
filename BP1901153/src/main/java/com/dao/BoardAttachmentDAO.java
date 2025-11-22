package com.dao;

import com.model.BoardAttachment;
import db.DBConnect;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BoardAttachmentDAO {

    /**
     * 첨부파일 저장
     */
    public boolean insertAttachment(BoardAttachment attachment) {
        String sql = "INSERT INTO board_attachments (board_id, original_filename, stored_filename, " +
                "file_path, file_size, file_type) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setInt(1, attachment.getBoardId());
            pstmt.setString(2, attachment.getOriginalFilename());
            pstmt.setString(3, attachment.getStoredFilename());
            pstmt.setString(4, attachment.getFilePath());
            pstmt.setLong(5, attachment.getFileSize());
            pstmt.setString(6, attachment.getFileType());

            int result = pstmt.executeUpdate();

            if (result > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    attachment.setAttachmentId(rs.getInt(1));
                }
                return true;
            }
            return false;

        } catch (SQLException e) {
            return false;
        }
    }

    /**
     * 게시글의 첨부파일 목록 조회
     */
    public List<BoardAttachment> getAttachmentsByBoardId(int boardId) {
        String sql = "SELECT * FROM board_attachments WHERE board_id = ? ORDER BY created_at ASC";
        List<BoardAttachment> attachments = new ArrayList<>();

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, boardId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                BoardAttachment attachment = new BoardAttachment();
                attachment.setAttachmentId(rs.getInt("attachment_id"));
                attachment.setBoardId(rs.getInt("board_id"));
                attachment.setOriginalFilename(rs.getString("original_filename"));
                attachment.setStoredFilename(rs.getString("stored_filename"));
                attachment.setFilePath(rs.getString("file_path"));
                attachment.setFileSize(rs.getLong("file_size"));
                attachment.setFileType(rs.getString("file_type"));
                attachment.setDownloadCount(rs.getInt("download_count"));
                attachment.setCreatedAt(rs.getTimestamp("created_at"));
                attachments.add(attachment);
            }

        } catch (SQLException e) {
        }

        return attachments;
    }

    /**
     * 첨부파일 ID로 조회
     */
    public BoardAttachment getAttachmentById(int attachmentId) {
        String sql = "SELECT * FROM board_attachments WHERE attachment_id = ?";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, attachmentId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                BoardAttachment attachment = new BoardAttachment();
                attachment.setAttachmentId(rs.getInt("attachment_id"));
                attachment.setBoardId(rs.getInt("board_id"));
                attachment.setOriginalFilename(rs.getString("original_filename"));
                attachment.setStoredFilename(rs.getString("stored_filename"));
                attachment.setFilePath(rs.getString("file_path"));
                attachment.setFileSize(rs.getLong("file_size"));
                attachment.setFileType(rs.getString("file_type"));
                attachment.setDownloadCount(rs.getInt("download_count"));
                attachment.setCreatedAt(rs.getTimestamp("created_at"));
                return attachment;
            }

        } catch (SQLException e) {
        }

        return null;
    }

    /**
     * 첨부파일 다운로드 횟수 증가
     */
    public boolean incrementDownloadCount(int attachmentId) {
        String sql = "UPDATE board_attachments SET download_count = download_count + 1 WHERE attachment_id = ?";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, attachmentId);
            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            return false;
        }
    }

    /**
     * 첨부파일 삭제
     */
    public boolean deleteAttachment(int attachmentId) {
        String sql = "DELETE FROM board_attachments WHERE attachment_id = ?";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, attachmentId);
            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            return false;
        }
    }

    /**
     * 게시글의 모든 첨부파일 삭제
     */
    public boolean deleteAttachmentsByBoardId(int boardId) {
        String sql = "DELETE FROM board_attachments WHERE board_id = ?";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, boardId);
            pstmt.executeUpdate();
            return true;

        } catch (SQLException e) {
            return false;
        }
    }
}
