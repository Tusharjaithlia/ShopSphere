package com.shopsphere.controller;

import com.shopsphere.dao.ReviewDAO;
import com.shopsphere.model.Category;
import com.shopsphere.model.Product;
import com.shopsphere.model.Review;
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

@WebServlet(urlPatterns = {"/products", "/product-details"})
public class ProductServlet extends HttpServlet {

    private final ProductService productService = new ProductService();
    private final CategoryService categoryService = new CategoryService();
    private final ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        try {
            // 1. Single Product Details View
            if ("/product-details".equals(path) || request.getParameter("id") != null && "/product-details".equals(path)) {
                String idParam = request.getParameter("id");
                if (idParam == null || idParam.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/products");
                    return;
                }

                int productId = Integer.parseInt(idParam.trim());
                Product product = productService.getProductById(productId);

                if (product == null) {
                    request.setAttribute("error", "Product not found.");
                    request.getRequestDispatcher("/products.jsp").forward(request, response);
                    return;
                }

                List<Review> reviews = reviewDAO.getReviewsByProductId(productId);
                double avgRating = reviewDAO.getAverageRating(productId);
                int reviewCount = reviewDAO.getReviewCount(productId);

                request.setAttribute("product", product);
                request.setAttribute("reviews", reviews);
                request.setAttribute("avgRating", avgRating);
                request.setAttribute("reviewCount", reviewCount);

                request.getRequestDispatcher("/product-details.jsp").forward(request, response);
                return;
            }

            // 2. Product Catalog View with Search and Filter
            String query = request.getParameter("query");
            String catParam = request.getParameter("category");

            Integer categoryId = null;
            if (catParam != null && !catParam.trim().isEmpty()) {
                try {
                    categoryId = Integer.parseInt(catParam.trim());
                } catch (NumberFormatException ignored) {
                }
            }

            List<Product> products;
            if ((query != null && !query.trim().isEmpty()) || (categoryId != null && categoryId > 0)) {
                products = productService.searchProducts(query, categoryId);
            } else {
                products = productService.getAllProducts();
            }

            List<Category> categories = categoryService.getAllCategories();

            request.setAttribute("products", products);
            request.setAttribute("categories", categories);
            request.setAttribute("selectedCategory", categoryId);
            request.setAttribute("searchQuery", query);

            request.getRequestDispatcher("/products.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/products");
        } catch (SQLException e) {
            throw new ServletException("Unable to load product information.", e);
        }
    }
}