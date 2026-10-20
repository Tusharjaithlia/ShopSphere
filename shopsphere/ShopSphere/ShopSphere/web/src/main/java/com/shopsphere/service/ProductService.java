package com.shopsphere.service;

import com.shopsphere.dao.ProductDAO;
import com.shopsphere.model.Product;

import java.sql.SQLException;
import java.util.List;

public class ProductService {

    private final ProductDAO productDAO = new ProductDAO();

    public List<Product> getAllProducts() throws SQLException {
        return productDAO.getAllProducts();
    }

    public List<Product> getAllProductsAdmin() throws SQLException {
        return productDAO.getAllProductsAdmin();
    }

    public Product getProductById(int id) throws SQLException {
        if (id <= 0) return null;
        return productDAO.getProductById(id);
    }

    public List<Product> getProductsByCategory(int categoryId) throws SQLException {
        if (categoryId <= 0) return getAllProducts();
        return productDAO.getProductsByCategory(categoryId);
    }

    public List<Product> searchProducts(String query, Integer categoryId) throws SQLException {
        return productDAO.searchProducts(query, categoryId);
    }

    public boolean addProduct(Product product) throws SQLException {
        if (product == null || product.getName() == null || product.getName().trim().isEmpty()) {
            return false;
        }
        return productDAO.addProduct(product);
    }

    public boolean updateProduct(Product product) throws SQLException {
        if (product == null || product.getProductId() <= 0 || product.getName() == null) {
            return false;
        }
        return productDAO.updateProduct(product);
    }

    public boolean deleteProduct(int id) throws SQLException {
        return productDAO.deleteProduct(id);
    }

    public int getProductCount() throws SQLException {
        return productDAO.getProductCount();
    }
}