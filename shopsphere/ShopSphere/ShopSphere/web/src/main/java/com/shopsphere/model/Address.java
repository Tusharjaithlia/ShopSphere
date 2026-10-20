package com.shopsphere.model;

import java.io.Serializable;

public class Address implements Serializable {
    private static final long serialVersionUID = 1L;

    private int addressId;
    private int userId;
    private String addressLine;
    private String city;
    private String state;
    private String pincode;
    private String addressType = "HOME";

    public Address() {
    }

    public Address(int addressId, int userId, String addressLine, String city, String state, String pincode, String addressType) {
        this.addressId = addressId;
        this.userId = userId;
        this.addressLine = addressLine;
        this.city = city;
        this.state = state;
        this.pincode = pincode;
        this.addressType = addressType != null ? addressType : "HOME";
    }

    public int getAddressId() { return addressId; }
    public void setAddressId(int id) { this.addressId = id; }

    public int getUserId() { return userId; }
    public void setUserId(int id) { this.userId = id; }

    public String getAddressLine() { return addressLine; }
    public void setAddressLine(String line) { this.addressLine = line; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public String getState() { return state; }
    public void setState(String state) { this.state = state; }

    public String getPincode() { return pincode; }
    public void setPincode(String pincode) { this.pincode = pincode; }

    public String getAddressType() { return addressType; }
    public void setAddressType(String type) { this.addressType = type; }

    public String getFullAddress() {
        StringBuilder sb = new StringBuilder();
        if (addressLine != null && !addressLine.isBlank()) sb.append(addressLine);
        if (city != null && !city.isBlank()) sb.append(", ").append(city);
        if (state != null && !state.isBlank()) sb.append(", ").append(state);
        if (pincode != null && !pincode.isBlank()) sb.append(" - ").append(pincode);
        return sb.toString();
    }
}
