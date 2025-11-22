package com.dto;

import com.model.Cart;
import com.model.User;
import java.util.List;

public class CheckoutData {
    private User user;
    private List<Cart> cartItems;
    private int totalPrice;

    public CheckoutData() {
    }

    public CheckoutData(User user, List<Cart> cartItems, int totalPrice) {
        this.user = user;
        this.cartItems = cartItems;
        this.totalPrice = totalPrice;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public List<Cart> getCartItems() {
        return cartItems;
    }

    public void setCartItems(List<Cart> cartItems) {
        this.cartItems = cartItems;
    }

    public int getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(int totalPrice) {
        this.totalPrice = totalPrice;
    }

    public boolean hasItems() {
        return cartItems != null && !cartItems.isEmpty();
    }

    public int getItemCount() {
        return cartItems != null ? cartItems.size() : 0;
    }
}
