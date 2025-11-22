package com.service;

import com.dao.CartDAO;
import com.dao.UserDAO;
import com.dto.CheckoutData;
import com.model.Cart;
import com.model.User;

import java.util.List;

public class CheckoutService {

    private CartDAO cartDAO;
    private UserDAO userDAO;

    public CheckoutService() {
        this.cartDAO = new CartDAO();
        this.userDAO = new UserDAO();
    }

    public CheckoutData getCheckoutData(Integer userId) {
        if (userId == null) {
            return null;
        }

        User user = userDAO.getUserById(userId);
        List<Cart> cartItems = cartDAO.getCartByUserId(userId);
        int totalPrice = cartDAO.getTotalPrice(userId);

        return new CheckoutData(user, cartItems, totalPrice);
    }
}
