package com.dao;

import com.model.Order;
import com.model.OrderItem;
import db.DBConnect;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    // 주문 생성
    public boolean createOrder(Order order) {
        String sql = "INSERT INTO orders (user_id, total_amount, payment_method, status) " +
                "VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setInt(1, order.getUserId());
            pstmt.setInt(2, order.getTotalAmount());
            pstmt.setString(3, order.getPaymentMethod());
            pstmt.setString(4, order.getStatus());

            int result = pstmt.executeUpdate();

            if (result > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    order.setOrderId(rs.getInt(1));
                }
                return true;
            }
            return false;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 주문 항목 추가
    public boolean addOrderItem(int orderId, int productId, int quantity, int price) {
        String sql = "INSERT INTO order_items (order_id, product_id, quantity, price) " +
                "VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, orderId);
            pstmt.setInt(2, productId);
            pstmt.setInt(3, quantity);
            pstmt.setInt(4, price);

            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 주문 상태 변경
    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE orders SET status = ? WHERE order_id = ?";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, status);
            pstmt.setInt(2, orderId);

            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 주문 상세 조회
    public Order getOrderById(int orderId) {
        String sql = "SELECT * FROM orders WHERE order_id = ?";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, orderId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return extractOrder(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // 사용자의 주문 목록
    public List<Order> getOrdersByUserId(int userId) {
        List<Order> orders = new ArrayList<>();

        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                orders.add(extractOrder(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    // 주문 항목 조회
    public List<OrderItem> getOrderItems(int orderId) {
        List<OrderItem> items = new ArrayList<>();

        String sql = "SELECT oi.*, p.product_name, p.category, p.file_path " +
                "FROM order_items oi " +
                "JOIN products p ON oi.product_id = p.product_id " +
                "WHERE oi.order_id = ?";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, orderId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setOrderItemId(rs.getInt("order_item_id"));
                item.setOrderId(rs.getInt("order_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setQuantity(rs.getInt("quantity"));
                item.setPrice(rs.getInt("price"));
                item.setProductName(rs.getString("product_name"));
                item.setCategory(rs.getString("category"));
                item.setFilePath(rs.getString("file_path"));
                items.add(item);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    // 전체 주문 조회 (관리자용)
    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY created_at DESC";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql);
                ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                orders.add(extractOrder(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    // 상태별 주문 조회
    public List<Order> getOrdersByStatus(String status) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE status = ? ORDER BY created_at DESC";

        try (Connection conn = DBConnect.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, status);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                orders.add(extractOrder(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    // ResultSet에서 Order 객체 추출
    private Order extractOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setOrderId(rs.getInt("order_id"));
        order.setUserId(rs.getInt("user_id"));
        order.setTotalAmount(rs.getInt("total_amount"));
        order.setPaymentMethod(rs.getString("payment_method"));
        order.setStatus(rs.getString("status"));
        order.setCreatedAt(rs.getTimestamp("created_at"));
        return order;
    }
}
