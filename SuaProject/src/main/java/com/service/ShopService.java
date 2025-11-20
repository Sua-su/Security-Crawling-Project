package com.service;

import com.dao.ProductDAO;
import com.dto.ShopProductsData;
import com.model.Product;

import java.util.List;

public class ShopService {

    private ProductDAO productDAO;

    public ShopService() {
        this.productDAO = new ProductDAO();
    }

    public ShopProductsData getShopProducts(String category) {
        List<Product> products;

        if (category != null && !category.trim().isEmpty()) {
            products = productDAO.getProductsByCategory(category);
        } else {
            products = productDAO.getAllProducts();
        }

        return new ShopProductsData(products, category);
    }

    public Product getProductById(int productId) {
        return productDAO.getProductById(productId);
    }
}
