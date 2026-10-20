package com.shopsphere.controller;

import com.shopsphere.dao.CartDAO;
import com.shopsphere.dao.CouponDAO;
import com.shopsphere.dao.ProductDAO;
import com.shopsphere.model.CartItem;
import com.shopsphere.model.Coupon;
import com.shopsphere.model.Product;
import com.shopsphere.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final CartDAO cartDAO = new CartDAO();
    private final CouponDAO couponDAO = new CouponDAO();

    @SuppressWarnings("unchecked")
    private List<CartItem> getSessionCart(HttpSession session) {
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cartItems");
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cartItems", cart);
        }
        return cart;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        List<CartItem> cart = getSessionCart(session);

        double subtotal = 0.0;
        for (CartItem item : cart) {
            subtotal += item.getSubtotal();
        }
        subtotal = Math.round(subtotal * 100.0) / 100.0;

        Coupon coupon = (Coupon) session.getAttribute("appliedCoupon");
        double discount = 0.0;
        if (coupon != null) {
            discount = coupon.calculateDiscount(subtotal);
            if (discount <= 0 && subtotal < coupon.getMinimumOrder()) {
                request.setAttribute("couponMessage", "Minimum order value of ₹" + coupon.getMinimumOrder() + " required for coupon " + coupon.getCode());
            }
        }

        double total = Math.max(0.0, Math.round((subtotal - discount) * 100.0) / 100.0);

        request.setAttribute("cartItems", cart);
        request.setAttribute("cartSubtotal", subtotal);
        request.setAttribute("cartDiscount", discount);
        request.setAttribute("cartTotal", total);

        String couponErr = (String) session.getAttribute("couponError");
        if (couponErr != null) {
            request.setAttribute("couponError", couponErr);
            session.removeAttribute("couponError");
        }

        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        List<CartItem> cart = getSessionCart(session);
        User user = (User) session.getAttribute("user");

        String action = request.getParameter("action");

        try {
            if ("add".equalsIgnoreCase(action)) {
                int productId = Integer.parseInt(request.getParameter("productId"));
                int quantity = 1;
                if (request.getParameter("quantity") != null) {
                    quantity = Integer.parseInt(request.getParameter("quantity"));
                }
                if (quantity < 1) quantity = 1;

                Product product = productDAO.getProductById(productId);
                if (product == null) {
                    response.sendRedirect(request.getContextPath() + "/products");
                    return;
                }

                CartItem existingItem = null;
                for (CartItem item : cart) {
                    if (item.getProductId() == productId) {
                        existingItem = item;
                        break;
                    }
                }

                int totalQty = (existingItem != null ? existingItem.getQuantity() : 0) + quantity;
                if (totalQty > product.getStock()) {
                    session.setAttribute("cartError", "Requested quantity exceeds available stock (" + product.getStock() + " available).");
                    response.sendRedirect(request.getContextPath() + "/cart");
                    return;
                }

                if (existingItem != null) {
                    existingItem.setQuantity(totalQty);
                } else {
                    CartItem newItem = new CartItem(
                            product.getProductId(),
                            product.getName(),
                            product.getEffectivePrice(),
                            quantity,
                            product.getImageUrl()
                    );
                    newItem.setProduct(product);
                    cart.add(newItem);
                }

                if (user != null) {
                    cartDAO.addToCart(user.getUserId(), productId, quantity);
                }

            } else if ("update".equalsIgnoreCase(action)) {
                int productId = Integer.parseInt(request.getParameter("productId"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));

                Product product = productDAO.getProductById(productId);
                if (product != null && quantity > product.getStock()) {
                    session.setAttribute("cartError", "Cannot set quantity to " + quantity + ". Only " + product.getStock() + " in stock.");
                    response.sendRedirect(request.getContextPath() + "/cart");
                    return;
                }

                if (quantity <= 0) {
                    cart.removeIf(item -> item.getProductId() == productId);
                    if (user != null) cartDAO.removeFromCart(user.getUserId(), productId);
                } else {
                    for (CartItem item : cart) {
                        if (item.getProductId() == productId) {
                            item.setQuantity(quantity);
                            break;
                        }
                    }
                    if (user != null) cartDAO.updateQuantity(user.getUserId(), productId, quantity);
                }

            } else if ("remove".equalsIgnoreCase(action)) {
                int productId = Integer.parseInt(request.getParameter("productId"));
                cart.removeIf(item -> item.getProductId() == productId);
                if (user != null) {
                    cartDAO.removeFromCart(user.getUserId(), productId);
                }

            } else if ("applyCoupon".equalsIgnoreCase(action)) {
                String code = request.getParameter("couponCode");
                if (code != null && !code.trim().isEmpty()) {
                    Coupon coupon = couponDAO.getCouponByCode(code.trim());
                    if (coupon != null) {
                        session.setAttribute("appliedCoupon", coupon);
                    } else {
                        session.setAttribute("couponError", "Invalid or inactive coupon code.");
                    }
                }

            } else if ("removeCoupon".equalsIgnoreCase(action)) {
                session.removeAttribute("appliedCoupon");
            }

            session.setAttribute("cartItems", cart);
            response.sendRedirect(request.getContextPath() + "/cart");

        } catch (Exception e) {
            session.setAttribute("cartError", "Error updating cart: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
}