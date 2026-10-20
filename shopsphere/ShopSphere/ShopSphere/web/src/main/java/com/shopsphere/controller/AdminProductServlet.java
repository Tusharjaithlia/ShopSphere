package com.shopsphere.controller;

import com.shopsphere.model.Category;
import com.shopsphere.model.Product;
import com.shopsphere.service.CategoryService;
import com.shopsphere.service.ProductService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/products")
public class AdminProductServlet extends HttpServlet {

    private final ProductService productService = new ProductService();
    private final CategoryService categoryService = new CategoryService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<Product> products = productService.getAllProductsAdmin();
            List<Category> categories = categoryService.getAllCategories();

            request.setAttribute("products", products);
            request.setAttribute("categories", categories);

            request.getRequestDispatcher("/admin/products.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Unable to load admin products.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if ("add".equalsIgnoreCase(action)) {
                Product p = new Product();
                p.setName(request.getParameter("name"));
                p.setBrand(request.getParameter("brand"));
                p.setDescription(request.getParameter("description"));
                p.setPrice(Double.parseDouble(request.getParameter("price")));
                p.setDiscount(request.getParameter("discount") != null && !request.getParameter("discount").isBlank() ? Double.parseDouble(request.getParameter("discount")) : 0.0);
                p.setStock(Integer.parseInt(request.getParameter("stock")));
                p.setImageUrl(request.getParameter("imageUrl"));
                p.setStatus(request.getParameter("status") == null || "true".equalsIgnoreCase(request.getParameter("status")) || "on".equalsIgnoreCase(request.getParameter("status")));

                String catIdStr = request.getParameter("categoryId");
                if (catIdStr != null && !catIdStr.isBlank()) {
                    p.setCategoryId(Integer.parseInt(catIdStr));
                }

                productService.addProduct(p);

            } else if ("edit".equalsIgnoreCase(action)) {
                int id = Integer.parseInt(request.getParameter("productId"));
                Product p = new Product();
                p.setProductId(id);
                p.setName(request.getParameter("name"));
                p.setBrand(request.getParameter("brand"));
                p.setDescription(request.getParameter("description"));
                p.setPrice(Double.parseDouble(request.getParameter("price")));
                p.setDiscount(request.getParameter("discount") != null && !request.getParameter("discount").isBlank() ? Double.parseDouble(request.getParameter("discount")) : 0.0);
                p.setStock(Integer.parseInt(request.getParameter("stock")));
                p.setImageUrl(request.getParameter("imageUrl"));
                p.setStatus(request.getParameter("status") != null && ("true".equalsIgnoreCase(request.getParameter("status")) || "on".equalsIgnoreCase(request.getParameter("status"))));

                String catIdStr = request.getParameter("categoryId");
                if (catIdStr != null && !catIdStr.isBlank()) {
                    p.setCategoryId(Integer.parseInt(catIdStr));
                }

                productService.updateProduct(p);

            } else if ("delete".equalsIgnoreCase(action)) {
                int id = Integer.parseInt(request.getParameter("productId"));
                productService.deleteProduct(id);
            }

            response.sendRedirect(request.getContextPath() + "/admin/products");

        } catch (Exception e) {
            throw new ServletException("Unable to process product operation: " + e.getMessage(), e);
        }
    }
}
