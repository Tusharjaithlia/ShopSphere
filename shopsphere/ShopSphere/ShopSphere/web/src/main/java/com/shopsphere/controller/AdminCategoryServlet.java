package com.shopsphere.controller;

import com.shopsphere.model.Category;
import com.shopsphere.service.CategoryService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/categories")
public class AdminCategoryServlet extends HttpServlet {

    private final CategoryService categoryService = new CategoryService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<Category> categories = categoryService.getAllCategoriesAdmin();
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("/admin/categories.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Unable to load admin categories.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if ("add".equalsIgnoreCase(action)) {
                String name = request.getParameter("name");
                String description = request.getParameter("description");
                boolean status = request.getParameter("status") == null || "true".equalsIgnoreCase(request.getParameter("status")) || "on".equalsIgnoreCase(request.getParameter("status"));

                Category c = new Category();
                c.setName(name);
                c.setDescription(description);
                c.setStatus(status);

                categoryService.addCategory(c);

            } else if ("edit".equalsIgnoreCase(action)) {
                int id = Integer.parseInt(request.getParameter("categoryId"));
                String name = request.getParameter("name");
                String description = request.getParameter("description");
                boolean status = request.getParameter("status") != null && ("true".equalsIgnoreCase(request.getParameter("status")) || "on".equalsIgnoreCase(request.getParameter("status")));

                Category c = new Category();
                c.setCategoryId(id);
                c.setName(name);
                c.setDescription(description);
                c.setStatus(status);

                categoryService.updateCategory(c);

            } else if ("delete".equalsIgnoreCase(action)) {
                int id = Integer.parseInt(request.getParameter("categoryId"));
                categoryService.deleteCategory(id);
            }

            response.sendRedirect(request.getContextPath() + "/admin/categories");

        } catch (Exception e) {
            throw new ServletException("Unable to process category operation.", e);
        }
    }
}
