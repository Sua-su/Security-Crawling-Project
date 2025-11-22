package com.controller.admin;

import com.dao.ProductDAO;
import com.model.Product;
import com.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

@WebServlet("/admin/products")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
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
            case "create":
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

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/index");
            return;
        }

        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/products");
            return;
        }

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

        String productIdParam = request.getParameter("productId");
        if (productIdParam == null) {
            productIdParam = request.getParameter("id");
        }

        int productId = Integer.parseInt(productIdParam);
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

        try {
            // 파일 업로드 처리
            String uploadedFilePath = handleFileUpload(request);

            Product product = extractProduct(request);

            // 업로드된 파일이 있으면 filePath 설정
            if (uploadedFilePath != null && !uploadedFilePath.isEmpty()) {
                product.setFilePath(uploadedFilePath);
            }

            // 필수 필드 검증
            if (product.getProductName() == null || product.getProductName().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/products?error=invalid_data");
                return;
            }

            boolean success = productDAO.createProduct(product);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/products?message=created");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/products?error=create_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/products?error=create_failed");
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            // 파일 업로드 처리
            String uploadedFilePath = handleFileUpload(request);

            Product product = extractProduct(request);
            product.setProductId(Integer.parseInt(request.getParameter("productId")));

            // 새로 업로드된 파일이 있으면 filePath 설정
            if (uploadedFilePath != null && !uploadedFilePath.isEmpty()) {
                product.setFilePath(uploadedFilePath);
            }

            boolean success = productDAO.updateProduct(product);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/products?message=product_updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/products?error=update_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
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

        String productName = request.getParameter("productName");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String stockStr = request.getParameter("stock");
        String category = request.getParameter("category");
        String status = request.getParameter("status");
        String filePath = request.getParameter("filePath");

        product.setProductName(productName != null ? productName : "");
        product.setDescription(description != null ? description : "");
        product.setPrice(priceStr != null && !priceStr.isEmpty() ? Integer.parseInt(priceStr) : 0);
        product.setStock(stockStr != null && !stockStr.isEmpty() ? Integer.parseInt(stockStr) : 0);
        product.setCategory(category != null ? category : "");
        product.setStatus(status != null ? status : "활성");
        product.setFilePath(filePath != null && !filePath.isEmpty() ? filePath : null);

        return product;
    }

    private String handleFileUpload(HttpServletRequest request) throws IOException, ServletException {
        Part filePart = request.getPart("productImage");

        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }

        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String fileExtension = "";
        int dotIndex = fileName.lastIndexOf('.');
        if (dotIndex > 0) {
            fileExtension = fileName.substring(dotIndex);
        }

        // 고유한 파일명 생성
        String uniqueFileName = UUID.randomUUID().toString() + fileExtension;

        // 업로드 디렉토리 경로
        String uploadPath = getServletContext().getRealPath("/") + "uploads" + File.separator + "products";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // 파일 저장
        String filePath = uploadPath + File.separator + uniqueFileName;
        filePart.write(filePath);

        // 웹 접근 가능한 상대 경로 반환
        return request.getContextPath() + "/uploads/products/" + uniqueFileName;
    }
}
