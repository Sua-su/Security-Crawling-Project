package com.dao;

import com.model.Product;
import db.DBConnect;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    // 상품 등록
    public boolean createProduct(Product product) {
        String sql = "INSERT INTO products (product_name, description, price, stock, category, file_path) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, product.getName());
            pstmt.setString(2, product.getDescription());
            pstmt.setInt(3, product.getPrice());
            pstmt.setInt(4, product.getStock());
            pstmt.setString(5, product.getCategory());
            pstmt.setString(6, product.getFilePath());

            int result = pstmt.executeUpdate();

            if (result > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    product.setProductId(rs.getInt(1));
                }
                return true;
            }
            return false;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 상품 수정
    public boolean updateProduct(Product product) {
        String sql = "UPDATE products SET product_name = ?, description = ?, price = ?, " +
                "stock = ?, category = ?, file_path = ? WHERE product_id = ?";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, product.getName());
            pstmt.setString(2, product.getDescription());
            pstmt.setInt(3, product.getPrice());
            pstmt.setInt(4, product.getStock());
            pstmt.setString(5, product.getCategory());
            pstmt.setString(6, product.getFilePath());
            pstmt.setInt(7, product.getProductId());

            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 상품 삭제
    public boolean deleteProduct(int productId) {
        String sql = "DELETE FROM products WHERE product_id = ?";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, productId);
            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 상품 상세 조회
    public Product getProductById(int productId) {
        String sql = "SELECT * FROM products WHERE product_id = ?";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, productId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return extractProduct(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // 전체 상품 목록
    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products ORDER BY created_at DESC";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                products.add(extractProduct(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    // 카테고리별 상품 목록
    public List<Product> getProductsByCategory(String category) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE category = ? ORDER BY created_at DESC";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, category);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                products.add(extractProduct(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    // 재고 확인
    public boolean hasStock(int productId, int quantity) {
        String sql = "SELECT stock FROM products WHERE product_id = ?";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, productId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("stock") >= quantity;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 재고 감소
    public boolean decreaseStock(int productId, int quantity) {
        String sql = "UPDATE products SET stock = stock - ? WHERE product_id = ? AND stock >= ?";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, quantity);
            pstmt.setInt(2, productId);
            pstmt.setInt(3, quantity);

            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 재고 증가
    public boolean increaseStock(int productId, int quantity) {
        String sql = "UPDATE products SET stock = stock + ? WHERE product_id = ?";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, quantity);
            pstmt.setInt(2, productId);

            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ResultSet에서 Product 객체 추출
    private Product extractProduct(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setProductId(rs.getInt("product_id"));
        product.setName(rs.getString("product_name"));
        product.setDescription(rs.getString("description"));
        product.setPrice(rs.getInt("price"));
        product.setStock(rs.getInt("stock"));
        product.setCategory(rs.getString("category"));
        product.setFilePath(rs.getString("file_path"));
        product.setCreatedAt(rs.getTimestamp("created_at"));
        return product;
    }
}
