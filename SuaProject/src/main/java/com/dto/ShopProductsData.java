package com.dto;

import com.model.Product;
import java.util.List;

public class ShopProductsData {
    private List<Product> products;
    private String category;

    public ShopProductsData() {
    }

    public ShopProductsData(List<Product> products, String category) {
        this.products = products;
        this.category = category;
    }

    public List<Product> getProducts() {
        return products;
    }

    public void setProducts(List<Product> products) {
        this.products = products;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public boolean hasProducts() {
        return products != null && !products.isEmpty();
    }

    public int getProductCount() {
        return products != null ? products.size() : 0;
    }
}
