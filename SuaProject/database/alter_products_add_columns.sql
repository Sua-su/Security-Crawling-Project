-- products 테이블에 image_url, stock, category 컬럼 추가
ALTER TABLE products 
ADD COLUMN image_url VARCHAR(500) COMMENT '상품 이미지 URL' AFTER file_path,
ADD COLUMN stock INT DEFAULT 0 COMMENT '재고 수량' AFTER download_count,
ADD COLUMN category VARCHAR(50) COMMENT '카테고리' AFTER stock;

-- 기존 데이터에 기본값 설정
UPDATE products SET category = 'news' WHERE category IS NULL;
UPDATE products SET stock = 100 WHERE stock = 0;
