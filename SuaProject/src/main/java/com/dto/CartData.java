package com.dto;

import java.util.List;
import com.model.Cart;

public class CartData {
    private List<Cart> cartItems;
    private int totalPrice;

    public CartData() {
    }

    public CartData(List<Cart> cartItems, int totalPrice) {
        this.cartItems = cartItems;
        this.totalPrice = totalPrice;
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

    public boolean isEmpty() {
        return cartItems == null || cartItems.isEmpty();
    }

    public int getItemCount() {
        return cartItems != null ? cartItems.size() : 0;
    }
}
