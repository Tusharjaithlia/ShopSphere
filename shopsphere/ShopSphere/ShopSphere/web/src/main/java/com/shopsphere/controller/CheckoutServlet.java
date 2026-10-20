package com.shopsphere.controller;

import com.shopsphere.dao.AddressDAO;
import com.shopsphere.model.Address;
import com.shopsphere.model.CartItem;
import com.shopsphere.model.Coupon;
import com.shopsphere.model.Order;
import com.shopsphere.model.User;
import com.shopsphere.service.CheckoutService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    
    private final CheckoutService checkoutService = new CheckoutService();
    private final AddressDAO addressDAO = new AddressDAO();

    @SuppressWarnings("unchecked")
    private List<CartItem> getCart(HttpSession session) {
        return (List<CartItem>) session.getAttribute("cartItems");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        List<CartItem> cart = getCart(session);

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        double subtotal = 0.0;
        for (CartItem item : cart) {
            subtotal += item.getSubtotal();
        }
        subtotal = Math.round(subtotal * 100.0) / 100.0;

        Coupon coupon = (Coupon) session.getAttribute("appliedCoupon");
        double discount = (coupon != null) ? coupon.calculateDiscount(subtotal) : 0.0;
        double total = Math.max(0.0, Math.round((subtotal - discount) * 100.0) / 100.0);

        try {
            List<Address> addresses = addressDAO.getAddressesByUserId(user.getUserId());
            request.setAttribute("savedAddresses", addresses);
        } catch (SQLException ignored) {
        }

        request.setAttribute("cartItems", cart);
        request.setAttribute("cartSubtotal", subtotal);
        request.setAttribute("cartDiscount", discount);
        request.setAttribute("cartTotal", total);

        request.getRequestDispatcher("/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        List<CartItem> cart = getCart(session);

        if (cart == null || cart.isEmpty()) {
            request.setAttribute("error", "Your cart is empty.");
            request.getRequestDispatcher("/cart.jsp").forward(request, response);
            return;
        }

        String paymentMethod = request.getParameter("paymentMethod");
        String selectedAddressId = request.getParameter("addressId");
        String customAddress = request.getParameter("address");

        String shippingAddress = "";

        // Check if an existing saved address was selected
        if (selectedAddressId != null && !selectedAddressId.isBlank()) {
            try {
                int addrId = Integer.parseInt(selectedAddressId.trim());
                Address addr = addressDAO.getAddressById(addrId);
                if (addr != null && addr.getUserId() == user.getUserId()) {
                    shippingAddress = addr.getFullAddress();
                }
            } catch (Exception ignored) {
            }
        }

        // If no saved address selected, use the entered address text
        if (shippingAddress.isBlank() && customAddress != null && !customAddress.trim().isEmpty()) {
            shippingAddress = customAddress.trim();

            // Save new address for future convenience
            String saveAddr = request.getParameter("saveAddress");
            if ("true".equalsIgnoreCase(saveAddr) || "on".equalsIgnoreCase(saveAddr)) {
                try {
                    Address newAddr = new Address();
                    newAddr.setUserId(user.getUserId());
                    newAddr.setAddressLine(shippingAddress);
                    newAddr.setCity(request.getParameter("city") != null ? request.getParameter("city").trim() : "City");
                    newAddr.setState(request.getParameter("state") != null ? request.getParameter("state").trim() : "State");
                    newAddr.setPincode(request.getParameter("pincode") != null ? request.getParameter("pincode").trim() : "000000");
                    addressDAO.addAddress(newAddr);
                } catch (Exception ignored) {
                }
            }
        }

        if (shippingAddress.isBlank()) {
            request.setAttribute("error", "Please provide a complete shipping address.");
            doGet(request, response);
            return;
        }

        if (paymentMethod == null || paymentMethod.isBlank()) {
            request.setAttribute("error", "Please select a payment method.");
            doGet(request, response);
            return;
        }

        Coupon coupon = (Coupon) session.getAttribute("appliedCoupon");
        String couponCode = (coupon != null) ? coupon.getCode() : null;

        try {
            Order order = checkoutService.processCheckout(
                    user.getUserId(),
                    shippingAddress,
                    paymentMethod,
                    couponCode,
                    cart
            );

            // Clear session cart and coupon
            session.removeAttribute("cartItems");
            session.removeAttribute("appliedCoupon");
            session.setAttribute("lastPlacedOrder", order);

            response.sendRedirect(request.getContextPath() + "/order-success?orderId=" + order.getOrderId());

        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            doGet(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "Order placement failed: " + e.getMessage());
            doGet(request, response);
        }
    }
}
