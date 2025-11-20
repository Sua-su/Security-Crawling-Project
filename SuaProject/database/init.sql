-- ========================================
-- MariaDB 설정 스크립트 (포트: 13306)
-- Database: BP1901153
-- ========================================

-- 데이터베이스 생성 (존재하지 않을 경우)
CREATE DATABASE IF NOT EXISTS BP1901153
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

-- 데이터베이스 선택
USE BP1901153;

-- ========================================
-- 1. news 테이블 (크롤링한 뉴스 저장)
-- ========================================
DROP TABLE IF EXISTS news;

CREATE TABLE news (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '뉴스 ID',
    title VARCHAR(500) NOT NULL COMMENT '뉴스 제목',
    preview TEXT COMMENT '뉴스 요약',
    company VARCHAR(100) COMMENT '언론사',
    link VARCHAR(1000) COMMENT '뉴스 링크',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    
    INDEX idx_created_at (created_at),
    INDEX idx_company (company)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='크롤링한 뉴스 데이터';

-- ========================================
-- 2. security_keywords 테이블 (보안 키워드 관리)
-- ========================================
DROP TABLE IF EXISTS security_keywords;

CREATE TABLE security_keywords (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '키워드 ID',
    keyword VARCHAR(100) NOT NULL COMMENT '보안 키워드',
    risk_level ENUM('HIGH', 'MEDIUM', 'LOW') DEFAULT 'MEDIUM' COMMENT '위험도',
    category VARCHAR(50) COMMENT '카테고리',
    description TEXT COMMENT '설명',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    
    UNIQUE KEY uk_keyword (keyword),
    INDEX idx_risk_level (risk_level)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='보안 키워드 관리';

-- ========================================
-- 3. crawl_log 테이블 (크롤링 이력)
-- ========================================
DROP TABLE IF EXISTS crawl_log;

CREATE TABLE crawl_log (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '로그 ID',
    target_url VARCHAR(500) NOT NULL COMMENT '크롤링 대상 URL',
    status ENUM('SUCCESS', 'FAIL') DEFAULT 'SUCCESS' COMMENT '상태',
    items_count INT DEFAULT 0 COMMENT '수집 항목 수',
    error_message TEXT COMMENT '오류 메시지',
    crawled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '크롤링 일시',
    
    INDEX idx_crawled_at (crawled_at),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='크롤링 실행 이력';

-- ========================================
-- 샘플 데이터 삽입
-- ========================================

-- 보안 키워드 샘플
INSERT INTO security_keywords (keyword, risk_level, category, description) VALUES
('해킹', 'HIGH', 'CYBER_ATTACK', '해킹 관련 위협'),
('랜섬웨어', 'HIGH', 'MALWARE', '랜섬웨어 공격'),
('DDoS', 'HIGH', 'CYBER_ATTACK', 'DDoS 공격'),
('피싱', 'MEDIUM', 'SOCIAL_ENGINEERING', '피싱 공격'),
('악성코드', 'HIGH', 'MALWARE', '악성 소프트웨어'),
('개인정보유출', 'HIGH', 'DATA_BREACH', '개인정보 유출 사고'),
('취약점', 'MEDIUM', 'VULNERABILITY', '보안 취약점'),
('보안패치', 'LOW', 'SECURITY_UPDATE', '보안 업데이트'),
('방화벽', 'LOW', 'SECURITY_TOOL', '보안 시스템'),
('암호화', 'LOW', 'SECURITY_TECH', '보안 기술');

-- 뉴스 샘플 데이터
INSERT INTO news (title, preview, company, link) VALUES
('[보안] 주요 기업 대상 랜섬웨어 공격 증가', '최근 주요 기업을 대상으로 한 랜섬웨어 공격이 증가하고 있어...', '보안뉴스', 'https://example.com/news/1'),
('[IT] 새로운 보안 취약점 발견', 'Windows 운영체제에서 심각한 보안 취약점이 발견되어...', '데일리시큐', 'https://example.com/news/2'),
('[경제] 개인정보유출 사고로 과징금 부과', 'A사가 고객 개인정보 유출로 인해 막대한 과징금을...', '전자신문', 'https://example.com/news/3');

-- ========================================
-- 유용한 쿼리 예제
-- ========================================

-- 1. 최근 뉴스 조회
-- SELECT * FROM news ORDER BY created_at DESC LIMIT 10;

-- 2. 특정 키워드가 포함된 뉴스 검색
-- SELECT * FROM news WHERE title LIKE '%해킹%' OR preview LIKE '%해킹%';

-- 3. 언론사별 뉴스 개수
-- SELECT company, COUNT(*) as cnt FROM news GROUP BY company ORDER BY cnt DESC;

-- 4. HIGH 위험도 키워드 목록
-- SELECT * FROM security_keywords WHERE risk_level = 'HIGH';

-- 5. 크롤링 성공률 확인
-- SELECT 
--     status,
--     COUNT(*) as cnt,
--     ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM crawl_log), 2) as percentage
-- FROM crawl_log
-- GROUP BY status;

-- ========================================
-- 테이블 정보 확인
-- ========================================
SHOW TABLES;

SELECT 
    TABLE_NAME as '테이블명',
    TABLE_ROWS as '행수',
    ROUND(DATA_LENGTH/1024/1024, 2) as '데이터크기(MB)',
    TABLE_COLLATION as '콜레이션'
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'BP1901153'
ORDER BY TABLE_NAME;
