<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart - ShopSphere</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <%@ include file="fragments/header.jsp" %>
    <%@ include file="fragments/navbar.jsp" %>

    <main class="home-container">
        <h2>Your Shopping Cart</h2>

        <c:if test="${not empty sessionScope.cartError}">
            <div class="alert alert-error">
                <c:out value="${sessionScope.cartError}"/>
                <c:remove var="cartError" scope="session"/>
            </div>
        </c:if>

        <c:if test="${not empty couponError}">
            <div class="alert alert-error">
                <c:out value="${couponError}"/>
            </div>
        </c:if>

        <c:if test="${not empty couponMessage}">
            <div class="alert alert-info">
                <c:out value="${couponMessage}"/>
            </div>
        </c:if>

        <c:choose>
            <c:when test="${empty cartItems}">
                <div class="empty-state">
                    <p>Your shopping cart is currently empty.</p>
                    <a class="btn-primary" href="${pageContext.request.contextPath}/products">Continue Shopping</a>
                </div>
            </c:when>

            <c:otherwise>
                <div class="cart-layout">
                    <!-- Left: Cart Items Table -->
                    <div class="cart-items-wrapper">
                        <table class="cart-table">
                            <thead>
                                <tr>
                                    <th>Product</th>
                                    <th>Price</th>
                                    <th>Quantity</th>
                                    <th>Subtotal</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${cartItems}">
                                    <tr>
                                        <td class="cart-product-cell">
                                            <c:if test="${not empty item.imageUrl}">
                                                <img src="${item.imageUrl}" alt="${item.productName}" class="cart-thumb">
                                            </c:if>
                                            <a href="${pageContext.request.contextPath}/product-details?id=${item.productId}">
                                                <strong><c:out value="${item.productName}"/></strong>
                                            </a>
                                        </td>
                                        <td>₹<c:out value="${item.price}"/></td>
                                        <td>
                                            <form action="${pageContext.request.contextPath}/cart" method="post" class="qty-form">
                                                <input type="hidden" name="action" value="update">
                                                <input type="hidden" name="productId" value="${item.productId}">
                                                <input type="number" name="quantity" value="${item.quantity}" min="1" max="99" class="cart-qty-input">
                                                <button type="submit" class="btn-xs">Update</button>
                                            </form>
                                        </td>
                                        <td><strong>₹<c:out value="${item.subtotal}"/></strong></td>
                                        <td>
                                            <form action="${pageContext.request.contextPath}/cart" method="post" data-confirm="Remove this item from your cart?">
                                                <input type="hidden" name="action" value="remove">
                                                <input type="hidden" name="productId" value="${item.productId}">
                                                <button type="submit" class="btn-danger-sm">Remove</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- Right: Order Summary & Coupon -->
                    <div class="cart-summary-box">
                        <h3>Cart Summary</h3>
                        <div class="summary-line">
                            <span>Subtotal:</span>
                            <span>₹<c:out value="${cartSubtotal}"/></span>
                        </div>

                        <!-- Coupon Form -->
                        <div class="coupon-box">
                            <c:choose>
                                <c:when test="${not empty sessionScope.appliedCoupon}">
                                    <div class="applied-coupon">
                                        <span>Coupon Applied: <strong><c:out value="${sessionScope.appliedCoupon.code}"/></strong></span>
                                        <form action="${pageContext.request.contextPath}/cart" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="removeCoupon">
                                            <button type="submit" class="link-btn">Remove</button>
                                        </form>
                                    </div>
                                    <div class="summary-line discount-line">
                                        <span>Discount:</span>
                                        <span>- ₹<c:out value="${cartDiscount}"/></span>
                                    </div>
                                </c:when>

                                <c:otherwise>
                                    <form action="${pageContext.request.contextPath}/cart" method="post" class="coupon-form">
                                        <input type="hidden" name="action" value="applyCoupon">
                                        <input type="text" name="couponCode" placeholder="Enter coupon (e.g. WELCOME10)" required>
                                        <button type="submit" class="btn-sm">Apply</button>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <hr>

                        <div class="summary-line total-line">
                            <span>Estimated Total:</span>
                            <span class="total-amount">₹<c:out value="${cartTotal}"/></span>
                        </div>

                        <a class="btn-primary btn-block" href="${pageContext.request.contextPath}/checkout">
                            Proceed to Checkout &rarr;
                        </a>

                        <p class="cart-assurance">🔒 100% Secure Checkout guaranteed</p>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </main>

    <%@ include file="fragments/footer.jsp" %>
    <script src="${pageContext.request.contextPath}/js/script.js"></script>

</body>
</html>