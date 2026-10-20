package com.shopsphere.service;

import com.shopsphere.dao.CategoryDAO;
import com.shopsphere.model.Category;

import java.sql.SQLException;
import java.util.List;

public class CategoryService {

    private final CategoryDAO categoryDAO = new CategoryDAO();

    public List<Category> getAllCategories() throws SQLException {
        return categoryDAO.getAllCategories();
    }

    public List<Category> getAllCategoriesAdmin() throws SQLException {
        return categoryDAO.getAllCategoriesAdmin();
    }

    public Category getCategoryById(int id) throws SQLException {
        return categoryDAO.getCategoryById(id);
    }

    public boolean addCategory(Category category) throws SQLException {
        if (category == null || category.getName() == null || category.getName().trim().isEmpty()) {
            return false;
        }
        return categoryDAO.addCategory(category);
    }

    public boolean updateCategory(Category category) throws SQLException {
        if (category == null || category.getCategoryId() <= 0 || category.getName() == null || category.getName().trim().isEmpty()) {
            return false;
        }
        return categoryDAO.updateCategory(category);
    }

    public boolean deleteCategory(int id) throws SQLException {
        return categoryDAO.deleteCategory(id);
    }

    public int getCategoryCount() throws SQLException {
        return categoryDAO.getCategoryCount();
    }
}