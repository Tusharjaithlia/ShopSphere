<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - ShopSphere</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <%@ include file="fragments/header.jsp" %>
    <%@ include file="fragments/navbar.jsp" %>

    <main class="home-container">
        <h2>Complete Your Order</h2>

        <c:if test="${not empty error}">
            <div class="alert alert-error">
                <c:out value="${error}"/>
            </div>
        </c:if>

        <c:choose>
            <c:when test="${empty cartItems}">
                <div class="empty-state">
                    <p>Your cart is empty. Please add items before checking out.</p>
                    <a class="btn-primary" href="${pageContext.request.contextPath}/products">Browse Products</a>
                </div>
            </c:when>

            <c:otherwise>
                <div class="checkout-layout">
                    <!-- Left: Delivery & Payment Form -->
                    <div class="checkout-form-container">
                        <form action="${pageContext.request.contextPath}/checkout" method="post" id="checkoutForm">

                            <!-- Address Selection -->
                            <div class="checkout-section">
                                <h3>1. Delivery Address</h3>

                                <c:if test="${not empty savedAddresses}">
                                    <div class="saved-addresses-list">
                                        <p><strong>Choose a saved address:</strong></p>
                                        <c:forEach var="addr" items="${savedAddresses}">
                                            <label class="radio-card">
                                                <input type="radio" name="addressId" value="${addr.addressId}" checked>
                                                <span>
                                                    <strong><c:out value="${addr.addressType}"/>:</strong>
                                                    <c:out value="${addr.fullAddress}"/>
                                                </span>
                                            </label>
                                        </c:forEach>
                                        <p class="divider-text">-- OR enter a new address below --</p>
                                    </div>
                                </c:if>

                                <div class="form-group">
                                    <label for="address">Street / Delivery Address:</label>
                                    <textarea id="address" name="address" rows="3" placeholder="Flat / House No., Building, Street, Area" ${empty savedAddresses ? 'required' : ''}></textarea>
                                </div>

                                <div class="form-row-three">
                                    <div class="form-group">
                                        <label for="city">City:</label>
                                        <input type="text" id="city" name="city" placeholder="City">
                                    </div>
                                    <div class="form-group">
                                        <label for="state">State:</label>
                                        <input type="text" id="state" name="state" placeholder="State">
                                    </div>
                                    <div class="form-group">
                                        <label for="pincode">Pincode:</label>
                                        <input type="text" id="pincode" name="pincode" placeholder="Pincode">
                                    </div>
                                </div>

                                <label class="checkbox-label">
                                    <input type="checkbox" name="saveAddress" value="true" checked>
                                    Save this address to my profile
                                </label>
                            </div>

                            <!-- Payment Method Selection -->
                            <div class="checkout-section">
                                <h3>2. Payment Method</h3>

                                <div class="payment-methods">
                                    <label class="radio-card">
                                        <input type="radio" name="paymentMethod" value="COD" checked>
                                        <span>💵 Cash on Delivery (COD)</span>
                                    </label>
                                    <label class="radio-card">
                                        <input type="radio" name="paymentMethod" value="UPI">
                                        <span>📱 UPI / QR Code (Demo Instant Payment)</span>
                                    </label>
                                    <label class="radio-card">
                                        <input type="radio" name="paymentMethod" value="CARD">
                                        <span>💳 Debit / Credit Card (Demo Instant Payment)</span>
                                    </label>
                                </div>

                                <div class="demo-payment-note">
                                    <p>ℹ️ <strong>Demo Payment Notice:</strong> This project uses an educational demo payment gateway. No real credit card or bank details are requested or stored.</p>
                                </div>
                            </div>

                            <button type="submit" class="btn-primary btn-block btn-lg">Place Order Now</button>
                        </form>
                    </div>

                    <!-- Right: Order Summary -->
                    <div class="checkout-summary-box">
                        <h3>Order Summary</h3>
                        <div class="checkout-items-list">
                            <c:forEach var="item" items="${cartItems}">
                                <div class="checkout-item-row">
                                    <span><c:out value="${item.productName}"/> × ${item.quantity}</span>
                                    <span>₹<c:out value="${item.subtotal}"/></span>
                                </div>
                            </c:forEach>
                        </div>

                        <hr>

                        <div class="summary-line">
                            <span>Subtotal:</span>
                            <span>₹<c:out value="${cartSubtotal}"/></span>
                        </div>

                        <c:if test="${cartDiscount > 0}">
                            <div class="summary-line discount-line">
                                <span>Coupon Discount:</span>
                                <span>- ₹<c:out value="${cartDiscount}"/></span>
                            </div>
                        </c:if>

                        <div class="summary-line">
                            <span>Delivery:</span>
                            <span class="free-badge">FREE</span>
                        </div>

                        <hr>

                        <div class="summary-line total-line">
                            <span>Total Payable:</span>
                            <span class="total-amount">₹<c:out value="${cartTotal}"/></span>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </main>

    <%@ include file="fragments/footer.jsp" %>
    <script src="${pageContext.request.contextPath}/js/script.js"></script>

</body>
</html>