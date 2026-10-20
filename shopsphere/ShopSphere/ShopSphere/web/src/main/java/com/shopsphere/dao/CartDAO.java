package com.shopsphere.dao;

import com.shopsphere.model.CartItem;
import com.shopsphere.model.Product;
import com.shopsphere.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {

    public List<CartItem> getCartByUserId(int userId) throws SQLException {
        List<CartItem> list = new ArrayList<>();
        String sql = "SELECT ci.cart_id, ci.user_id, ci.product_id, ci.quantity, " +
                     "p.name, p.brand, p.price, p.discount, p.stock, p.image_url " +
                     "FROM cart_items ci " +
                     "JOIN products p ON ci.product_id = p.product_id " +
                     "WHERE ci.user_id = ? ORDER BY ci.cart_id ASC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setProductId(rs.getInt("product_id"));
                    p.setName(rs.getString("name"));
                    p.setBrand(rs.getString("brand"));
                    p.setPrice(rs.getDouble("price"));
                    p.setDiscount(rs.getDouble("discount"));
                    p.setStock(rs.getInt("stock"));
                    p.setImageUrl(rs.getString("image_url"));

                    CartItem item = new CartItem();
                    item.setCartId(rs.getInt("cart_id"));
                    item.setUserId(rs.getInt("user_id"));
                    item.setProductId(p.getProductId());
                    item.setProductName(p.getName());
                    item.setPrice(p.getEffectivePrice());
                    item.setQuantity(rs.getInt("quantity"));
                    item.setImageUrl(p.getImageUrl());
                    item.setProduct(p);

                    list.add(item);
                }
            }
        }
        return list;
    }

    public boolean addToCart(int userId, int productId, int quantity) throws SQLException {
        String checkSql = "SELECT cart_id, quantity FROM cart_items WHERE user_id = ? AND product_id = ?";
        String updateSql = "UPDATE cart_items SET quantity = quantity + ? WHERE cart_id = ?";
        String insertSql = "INSERT INTO cart_items (user_id, product_id, quantity) VALUES (?, ?, ?)";

        try (Connection con = DBConnection.getConnection()) {
            try (PreparedStatement ps = con.prepareStatement(checkSql)) {
                ps.setInt(1, userId);
                ps.setInt(2, productId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        int cartId = rs.getInt("cart_id");
                        try (PreparedStatement ups = con.prepareStatement(updateSql)) {
                            ups.setInt(1, quantity);
                            ups.setInt(2, cartId);
                            return ups.executeUpdate() > 0;
                        }
                    }
                }
            }

            try (PreparedStatement ips = con.prepareStatement(insertSql)) {
                ips.setInt(1, userId);
                ips.setInt(2, productId);
                ips.setInt(3, quantity);
                return ips.executeUpdate() > 0;
            }
        }
    }

    public boolean updateQuantity(int userId, int productId, int quantity) throws SQLException {
        if (quantity <= 0) {
            return removeFromCart(userId, productId);
        }
        String sql = "UPDATE cart_items SET quantity = ? WHERE user_id = ? AND product_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, userId);
            ps.setInt(3, productId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean removeFromCart(int userId, int productId) throws SQLException {
        String sql = "DELETE FROM cart_items WHERE user_id = ? AND product_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean clearCart(int userId) throws SQLException {
        String sql = "DELETE FROM cart_items WHERE user_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() >= 0;
        }
    }
}
