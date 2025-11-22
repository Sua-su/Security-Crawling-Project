package com.dao;

import com.model.Cart;
import db.DBConnect;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {
    // 장바구니에 추가
    public boolean addToCart(Cart cart) {
        // 이미 장바구니에 있는지 확인
        String checkSql = "SELECT cart_id, quantity FROM cart WHERE user_id = ? AND product_id = ?";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {

            checkStmt.setInt(1, cart.getUserId());
            checkStmt.setInt(2, cart.getProductId());
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                // 이미 있으면 수량만 증가
                int cartId = rs.getInt("cart_id");
                int currentQuantity = rs.getInt("quantity");
                int newQuantity = currentQuantity + cart.getQuantity();

                String updateSql = "UPDATE cart SET quantity = ? WHERE cart_id = ?";
                try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                    updateStmt.setInt(1, newQuantity);
                    updateStmt.setInt(2, cartId);
                    return updateStmt.executeUpdate() > 0;
                }
            } else {
                // 새로 추가
                String insertSql = "INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?)";
                try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                    insertStmt.setInt(1, cart.getUserId());
                    insertStmt.setInt(2, cart.getProductId());
                    insertStmt.setInt(3, cart.getQuantity());
                    return insertStmt.executeUpdate() > 0;
                }
            }

        } catch (SQLException e) {
            return false;
        }
    }

    // 장바구니 수량 변경
    public boolean updateQuantity(int cartId, int userId, int quantity) {
        String sql = "UPDATE cart SET quantity = ? WHERE cart_id = ? AND user_id = ?";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, quantity);
            pstmt.setInt(2, cartId);
            pstmt.setInt(3, userId);

            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            return false;
        }
    }

    // 장바구니 항목 삭제
    public boolean removeFromCart(int cartId, int userId) {
        String sql = "DELETE FROM cart WHERE cart_id = ? AND user_id = ?";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, cartId);
            pstmt.setInt(2, userId);

            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            return false;
        }
    }

    // 사용자의 장바구니 목록 조회
    public List<Cart> getCartByUserId(int userId) {
        List<Cart> cartList = new ArrayList<>();

        String sql = "SELECT c.cart_id, c.user_id, c.product_id, c.quantity, c.created_at, " +
                "p.product_name, p.description, p.price, p.stock, p.category, p.file_path " +
                "FROM cart c " +
                "JOIN products p ON c.product_id = p.product_id " +
                "WHERE c.user_id = ? " +
                "ORDER BY c.created_at DESC";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Cart cart = new Cart();
                cart.setCartId(rs.getInt("cart_id"));
                cart.setUserId(rs.getInt("user_id"));
                cart.setProductId(rs.getInt("product_id"));
                cart.setQuantity(rs.getInt("quantity"));
                cart.setAddedAt(rs.getTimestamp("created_at"));

                // 상품 정보
                cart.setProductName(rs.getString("product_name"));
                cart.setDescription(rs.getString("description"));
                cart.setPrice(rs.getInt("price"));
                cart.setStock(rs.getInt("stock"));
                cart.setCategory(rs.getString("category"));

                cartList.add(cart);
            }

        } catch (SQLException e) {
        }
        return cartList;
    }

    // 장바구니 총 금액 계산
    public int getTotalPrice(int userId) {
        String sql = "SELECT SUM(c.quantity * p.price) as total " +
                "FROM cart c " +
                "JOIN products p ON c.product_id = p.product_id " +
                "WHERE c.user_id = ?";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("total");
            }

        } catch (SQLException e) {
        }
        return 0;
    }

    // 장바구니 비우기
    public boolean clearCart(int userId) {
        String sql = "DELETE FROM cart WHERE user_id = ?";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            return pstmt.executeUpdate() >= 0;

        } catch (SQLException e) {
            return false;
        }
    }

    // 장바구니 항목 수
    public int getCartCount(int userId) {
        String sql = "SELECT COUNT(*) FROM cart WHERE user_id = ?";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
        }
        return 0;
    }

    // 장바구니 항목 조회 (단일)
    public Cart getCartById(int cartId) {
        String sql = "SELECT c.*, p.stock FROM cart c " +
                "JOIN products p ON c.product_id = p.product_id " +
                "WHERE c.cart_id = ?";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, cartId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                Cart cart = new Cart();
                cart.setCartId(rs.getInt("cart_id"));
                cart.setUserId(rs.getInt("user_id"));
                cart.setProductId(rs.getInt("product_id"));
                cart.setQuantity(rs.getInt("quantity"));
                cart.setStock(rs.getInt("stock"));
                return cart;
            }

        } catch (SQLException e) {
        }
        return null;
    }

    // 장바구니 항목 삭제 (cartId만으로)
    public boolean deleteCart(int cartId) {
        String sql = "DELETE FROM cart WHERE cart_id = ?";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, cartId);
            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            return false;
        }
    }
}
