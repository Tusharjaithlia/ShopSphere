package com.shopsphere.dao;

import com.shopsphere.model.Address;
import com.shopsphere.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class AddressDAO {

    public int addAddress(Address address) throws SQLException {
        String sql = "INSERT INTO addresses (user_id, address_line, city, state, pincode, address_type) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, address.getUserId());
            ps.setString(2, address.getAddressLine());
            ps.setString(3, address.getCity());
            ps.setString(4, address.getState());
            ps.setString(5, address.getPincode());
            ps.setString(6, address.getAddressType() != null ? address.getAddressType() : "HOME");

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int id = rs.getInt(1);
                        address.setAddressId(id);
                        return id;
                    }
                }
            }
        }
        return -1;
    }

    public List<Address> getAddressesByUserId(int userId) throws SQLException {
        List<Address> list = new ArrayList<>();
        String sql = "SELECT * FROM addresses WHERE user_id = ? ORDER BY address_id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Address a = new Address();
                    a.setAddressId(rs.getInt("address_id"));
                    a.setUserId(rs.getInt("user_id"));
                    a.setAddressLine(rs.getString("address_line"));
                    a.setCity(rs.getString("city"));
                    a.setState(rs.getString("state"));
                    a.setPincode(rs.getString("pincode"));
                    a.setAddressType(rs.getString("address_type"));
                    list.add(a);
                }
            }
        }
        return list;
    }

    public Address getAddressById(int addressId) throws SQLException {
        String sql = "SELECT * FROM addresses WHERE address_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, addressId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Address a = new Address();
                    a.setAddressId(rs.getInt("address_id"));
                    a.setUserId(rs.getInt("user_id"));
                    a.setAddressLine(rs.getString("address_line"));
                    a.setCity(rs.getString("city"));
                    a.setState(rs.getString("state"));
                    a.setPincode(rs.getString("pincode"));
                    a.setAddressType(rs.getString("address_type"));
                    return a;
                }
            }
        }
        return null;
    }
}
