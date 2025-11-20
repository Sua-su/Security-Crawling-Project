package com.service;

import com.dao.OrderDAO;
import com.dao.UserDAO;
import com.dto.MyPageData;
import com.model.Order;
import com.model.User;

import java.util.List;

public class MyPageService {

    private UserDAO userDAO;
    private OrderDAO orderDAO;

    public MyPageService() {
        this.userDAO = new UserDAO();
        this.orderDAO = new OrderDAO();
    }

    public MyPageData getMyPageData(Integer userId, String activeTab) {
        if (userId == null) {
            return null;
        }

        MyPageData data = new MyPageData();

        // 사용자 정보
        User user = userDAO.getUserById(userId);
        data.setUser(user);

        // 주문 내역
        List<Order> orders = orderDAO.getOrdersByUserId(userId);
        data.setOrders(orders);

        // 통계 계산
        int totalSpent = 0;
        int completedCount = 0;

        if (orders != null) {
            for (Order order : orders) {
                totalSpent += order.getTotalAmount();
                if ("PAID".equals(order.getStatus())) {
                    completedCount++;
                }
            }
        }

        data.setTotalSpent(totalSpent);
        data.setCompletedOrderCount(completedCount);
        data.setActiveTab(activeTab);

        return data;
    }
}
