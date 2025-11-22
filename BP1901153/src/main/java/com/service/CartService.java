package com.service;

import com.dao.CartDAO;
import com.dto.CartData;
import com.model.Cart;

import java.util.List;

public class CartService {

    private CartDAO cartDAO;

    public CartService() {
        this.cartDAO = new CartDAO();
    }

    public CartData getCartData(Integer userId) {
        if (userId == null) {
            return new CartData();
        }

        List<Cart> cartItems = cartDAO.getCartByUserId(userId);
        int totalPrice = cartDAO.getTotalPrice(userId);

        return new CartData(cartItems, totalPrice);
    }

    public boolean updateCartQuantity(int cartId, String action) {
        try {
            Cart cart = cartDAO.getCartById(cartId);
            if (cart == null) {
                return false;
            }

            int newQuantity = cart.getQuantity();
            if ("increase".equals(action)) {
                if (newQuantity < cart.getStock()) {
                    newQuantity++;
                } else {
                    return false; // 재고 부족
                }
            } else if ("decrease".equals(action)) {
                if (newQuantity > 1) {
                    newQuantity--;
                } else {
                    return false; // 최소 수량 1
                }
            }

            return cartDAO.updateQuantity(cartId, cart.getUserId(), newQuantity);
        } catch (Exception e) {
            return false;
        }
    }

    public boolean removeFromCart(int cartId) {
        try {
            return cartDAO.deleteCart(cartId);
        } catch (Exception e) {
            return false;
        }
    }

    public boolean addToCart(Integer userId, int productId, int quantity) {
        if (userId == null) {
            return false;
        }

        try {
            Cart cart = new Cart();
            cart.setUserId(userId);
            cart.setProductId(productId);
            cart.setQuantity(quantity);
            return cartDAO.addToCart(cart);
        } catch (Exception e) {
            return false;
        }
    }
}