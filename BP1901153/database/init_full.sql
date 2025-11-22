-- ========================================
-- 전체 시스템 데이터베이스 스키마
-- Security Crawling Project + Shopping Mall
-- MariaDB (포트: 13306)
-- Database: BP1901153
-- ========================================

USE BP1901153;

-- 기존 테이블 삭제 (순서 중요 - 외래키 역순)
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS cart;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS board;
DROP TABLE IF EXISTS crawl_log;
DROP TABLE IF EXISTS security_keywords;
DROP TABLE IF EXISTS news;
DROP TABLE IF EXISTS users;

-- ========================================
-- 1. 회원 테이블
-- ========================================
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '회원 ID',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '아이디 (로그인용)',
    password VARCHAR(255) NOT NULL COMMENT '비밀번호 (암호화)',
    name VARCHAR(100) NOT NULL COMMENT '이름',
    email VARCHAR(100) NOT NULL UNIQUE COMMENT '이메일',
    phone VARCHAR(20) COMMENT '전화번호',
    address VARCHAR(255) COMMENT '주소',
    address_detail VARCHAR(255) COMMENT '상세주소',
    zipcode VARCHAR(10) COMMENT '우편번호',
    role ENUM('USER', 'ADMIN') DEFAULT 'USER' COMMENT '권한',
    status ENUM('ACTIVE', 'INACTIVE', 'BANNED') DEFAULT 'ACTIVE' COMMENT '상태',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '가입일',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
    last_login TIMESTAMP NULL COMMENT '마지막 로그인',
    
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='회원 정보';

-- ========================================
-- 2. 뉴스 테이블 (크롤링 데이터)
-- ========================================
CREATE TABLE news (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '뉴스 ID',
    title VARCHAR(500) NOT NULL COMMENT '뉴스 제목',
    preview TEXT COMMENT '뉴스 요약',
    company VARCHAR(100) COMMENT '언론사',
    link VARCHAR(1000) COMMENT '뉴스 링크',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    
    INDEX idx_created_at (created_at),
    INDEX idx_company (company),
    UNIQUE KEY uk_link (link)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='크롤링한 뉴스 데이터';

-- ========================================
-- 3. 게시판 테이블
-- ========================================
CREATE TABLE board (
    board_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '게시글 ID',
    user_id INT NOT NULL COMMENT '작성자 ID',
    title VARCHAR(200) NOT NULL COMMENT '제목',
    content TEXT NOT NULL COMMENT '내용',
    view_count INT DEFAULT 0 COMMENT '조회수',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
    
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='게시판';

-- ========================================
-- 4. 댓글 테이블
-- ========================================
CREATE TABLE comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '댓글 ID',
    board_id INT NOT NULL COMMENT '게시글 ID',
    user_id INT NOT NULL COMMENT '작성자 ID',
    content TEXT NOT NULL COMMENT '댓글 내용',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    
    FOREIGN KEY (board_id) REFERENCES board(board_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_board_id (board_id),
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='게시판 댓글';

-- ========================================
-- 5. 상품 테이블 (크롤링 데이터 ZIP 파일)
-- ========================================
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '상품 ID',
    product_name VARCHAR(200) NOT NULL COMMENT '상품명',
    description TEXT COMMENT '상품 설명',
    price INT NOT NULL DEFAULT 1000 COMMENT '가격',
    file_path VARCHAR(500) COMMENT 'ZIP 파일 경로',
    news_count INT DEFAULT 0 COMMENT '포함된 뉴스 개수',
    download_count INT DEFAULT 0 COMMENT '다운로드 횟수',
    status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE' COMMENT '판매 상태',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '등록일',
    
    INDEX idx_status (status),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='상품 (크롤링 데이터 ZIP)';

-- ========================================
-- 6. 장바구니 테이블
-- ========================================
CREATE TABLE cart (
    cart_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '장바구니 ID',
    user_id INT NOT NULL COMMENT '회원 ID',
    product_id INT NOT NULL COMMENT '상품 ID',
    quantity INT DEFAULT 1 COMMENT '수량',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '추가일',
    
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    UNIQUE KEY uk_user_product (user_id, product_id),
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='장바구니';

-- ========================================
-- 7. 주문 테이블
-- ========================================
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '주문 ID',
    user_id INT NOT NULL COMMENT '회원 ID',
    total_amount INT NOT NULL COMMENT '총 금액',
    status ENUM('PENDING', 'PAID', 'COMPLETED', 'CANCELLED') DEFAULT 'PENDING' COMMENT '주문 상태',
    payment_method VARCHAR(50) COMMENT '결제 방법',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '주문일',
    
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='주문';

-- ========================================
-- 8. 주문 상세 테이블
-- ========================================
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '주문 상세 ID',
    order_id INT NOT NULL COMMENT '주문 ID',
    product_id INT NOT NULL COMMENT '상품 ID',
    quantity INT NOT NULL COMMENT '수량',
    price INT NOT NULL COMMENT '구매 당시 가격',
    
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    INDEX idx_order_id (order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='주문 상세';

-- ========================================
-- 9. 보안 키워드 테이블
-- ========================================
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
-- 10. 크롤링 로그 테이블
-- ========================================
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

-- 관리자 및 테스트 회원
INSERT INTO users (username, password, name, email, phone, address, role) VALUES
('admin', 'admin123', '관리자', 'admin@example.com', '010-1234-5678', '서울시 강남구', 'ADMIN'),
('user1', 'user123', '홍길동', 'user1@example.com', '010-1111-2222', '서울시 서초구', 'USER'),
('user2', 'user123', '김철수', 'user2@example.com', '010-3333-4444', '경기도 성남시', 'USER');

-- 게시판 샘플
INSERT INTO board (user_id, title, content, view_count) VALUES
(2, '첫 번째 게시글입니다', '안녕하세요! 게시판 테스트입니다.', 10),
(2, 'MLB 뉴스 관련 질문', 'MLB 뉴스 데이터는 어떻게 활용하나요?', 5),
(3, '쇼핑몰 이용 후기', '크롤링 데이터 구매했는데 정말 유용하네요!', 15);

-- 댓글 샘플
INSERT INTO comments (board_id, user_id, content) VALUES
(1, 3, '좋은 글 감사합니다!'),
(1, 2, '도움이 되었습니다.'),
(2, 1, 'ZIP 파일로 다운로드 받으실 수 있습니다.');

-- 상품 샘플 (크롤링 데이터 ZIP)
INSERT INTO products (product_name, description, price, news_count, status) VALUES
('MLB 뉴스 데이터 패키지 Vol.1', '2025년 11월 첫째주 MLB 관련 뉴스 50건', 1000, 50, 'ACTIVE'),
('MLB 뉴스 데이터 패키지 Vol.2', '2025년 11월 둘째주 MLB 관련 뉴스 75건', 1000, 75, 'ACTIVE'),
('MLB 종합 뉴스 패키지', '2025년 11월 전체 MLB 뉴스 200건', 1000, 200, 'ACTIVE');

-- 보안 키워드 샘플
INSERT INTO security_keywords (keyword, risk_level, category, description) VALUES
('해킹', 'HIGH', 'CYBER_ATTACK', '해킹 관련 위협'),
('랜섬웨어', 'HIGH', 'MALWARE', '랜섬웨어 공격'),
('DDoS', 'HIGH', 'CYBER_ATTACK', 'DDoS 공격'),
('피싱', 'MEDIUM', 'SOCIAL_ENGINEERING', '피싱 공격'),
('악성코드', 'HIGH', 'MALWARE', '악성 소프트웨어');

-- ========================================
-- 뷰 생성 (편의 기능)
-- ========================================

-- 게시판 상세 뷰 (작성자 정보 포함)
CREATE OR REPLACE VIEW board_detail AS
SELECT 
    b.board_id,
    b.title,
    b.content,
    b.view_count,
    b.created_at,
    b.updated_at,
    u.user_id,
    u.username,
    u.name AS author_name,
    (SELECT COUNT(*) FROM comments c WHERE c.board_id = b.board_id) AS comment_count
FROM board b
JOIN users u ON b.user_id = u.user_id;

-- 주문 내역 뷰 (상품 정보 포함)
CREATE OR REPLACE VIEW order_history AS
SELECT 
    o.order_id,
    o.user_id,
    u.username,
    u.name,
    o.total_amount,
    o.status,
    o.payment_method,
    o.created_at,
    oi.product_id,
    p.product_name,
    oi.quantity,
    oi.price
FROM orders o
JOIN users u ON o.user_id = u.user_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id;

-- ========================================
-- 테이블 정보 확인
-- ========================================
SELECT 
    TABLE_NAME as '테이블명',
    TABLE_ROWS as '행수',
    ROUND(DATA_LENGTH/1024/1024, 2) as '데이터크기(MB)',
    TABLE_COMMENT as '설명'
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'BP1901153'
    AND TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
