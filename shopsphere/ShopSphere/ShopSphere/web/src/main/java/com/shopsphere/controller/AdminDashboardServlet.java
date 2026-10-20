package com.shopsphere.controller;

import com.shopsphere.model.Order;
import com.shopsphere.service.CategoryService;
import com.shopsphere.service.OrderService;
import com.shopsphere.service.ProductService;
import com.shopsphere.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final ProductService productService = new ProductService();
    private final CategoryService categoryService = new CategoryService();
    private final OrderService orderService = new OrderService();
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int productCount = productService.getProductCount();
            int categoryCount = categoryService.getCategoryCount();
            int orderCount = orderService.getOrderCount();
            int userCount = userService.getUserCount();
            double totalRevenue = orderService.getTotalRevenue();
            List<Order> allOrders = orderService.getAllOrders();

            request.setAttribute("productCount", productCount);
            request.setAttribute("categoryCount", categoryCount);
            request.setAttribute("orderCount", orderCount);
            request.setAttribute("userCount", userCount);
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("recentOrders", allOrders.size() > 5 ? allOrders.subList(0, 5) : allOrders);

            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Unable to load admin dashboard statistics.", e);
        }
    }
}
