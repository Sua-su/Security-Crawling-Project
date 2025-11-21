package com.controller.admin;

import com.dao.ProductDAO;
import com.model.Product;
import com.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/products")
public class AdminProductController extends HttpServlet {

    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/index");
            return;
        }

        String action = request.getParameter("action");

        switch (action != null ? action : "list") {
            case "edit":
                handleEdit(request, response);
                break;
            case "new":
                request.getRequestDispatcher("/WEB-INF/views/admin/productForm.jsp").forward(request, response);
                break;
            default:
                handleList(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/index");
            return;
        }

        String action = request.getParameter("action");

        switch (action) {
            case "create":
                handleCreate(request, response);
                break;
            case "update":
                handleUpdate(request, response);
                break;
            case "delete":
                handleDelete(request, response);
                break;
            case "updateStock":
                handleUpdateStock(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/products");
        }
    }

    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String category = request.getParameter("category");
        List<Product> products;

        if (category != null && !category.isEmpty()) {
            products = productDAO.getProductsByCategory(category);
        } else {
            products = productDAO.getAllProducts();
        }

        request.setAttribute("products", products);
        request.setAttribute("selectedCategory", category);
        request.setAttribute("totalProducts", products.size());

        request.getRequestDispatcher("/WEB-INF/views/admin/products.jsp").forward(request, response);
    }

    private void handleEdit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int productId = Integer.parseInt(request.getParameter("id"));
        Product product = productDAO.getProductById(productId);

        if (product != null) {
            request.setAttribute("product", product);
            request.getRequestDispatcher("/WEB-INF/views/admin/productForm.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/products?error=product_not_found");
        }
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Product product = extractProduct(request);
        boolean success = productDAO.createProduct(product);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/products?message=product_created");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/products?error=create_failed");
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Product product = extractProduct(request);
        product.setProductId(Integer.parseInt(request.getParameter("productId")));

        boolean success = productDAO.updateProduct(product);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/products?message=product_updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/products?error=update_failed");
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int productId = Integer.parseInt(request.getParameter("productId"));
        boolean success = productDAO.deleteProduct(productId);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/products?message=product_deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/products?error=delete_failed");
        }
    }

    private void handleUpdateStock(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int productId = Integer.parseInt(request.getParameter("productId"));
        int stock = Integer.parseInt(request.getParameter("stock"));

        Product product = productDAO.getProductById(productId);
        boolean success = false;
        if (product != null) {
            product.setStock(stock);
            success = productDAO.updateProduct(product);
        }

        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/products?message=stock_updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/products?error=update_failed");
        }
    }

    private Product extractProduct(HttpServletRequest request) {
        Product product = new Product();
        product.setProductName(request.getParameter("productName"));
        product.setDescription(request.getParameter("description"));
        product.setPrice(Integer.parseInt(request.getParameter("price")));
        product.setStock(Integer.parseInt(request.getParameter("stock")));
        product.setCategory(request.getParameter("category"));
        product.setStatus(request.getParameter("status"));
        product.setFilePath(request.getParameter("filePath"));
        return product;
    }
}
