-- ========================================
-- 게시판 첨부파일 테이블
-- ========================================
CREATE TABLE board_attachments (
    attachment_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '첨부파일 ID',
    board_id INT NOT NULL COMMENT '게시글 ID',
    original_filename VARCHAR(255) NOT NULL COMMENT '원본 파일명',
    stored_filename VARCHAR(255) NOT NULL COMMENT '저장된 파일명',
    file_path VARCHAR(500) NOT NULL COMMENT '파일 경로',
    file_size BIGINT NOT NULL COMMENT '파일 크기 (bytes)',
    file_type VARCHAR(100) COMMENT '파일 타입',
    download_count INT DEFAULT 0 COMMENT '다운로드 수',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '업로드일',
    
    FOREIGN KEY (board_id) REFERENCES board(board_id) ON DELETE CASCADE,
    INDEX idx_board_id (board_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='게시판 첨부파일';
