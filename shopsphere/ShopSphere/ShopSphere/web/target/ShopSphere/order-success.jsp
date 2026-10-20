<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmed - ShopSphere</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <%@ include file="fragments/header.jsp" %>
    <%@ include file="fragments/navbar.jsp" %>

    <main class="home-container success-container">
        <div class="success-icon">🎉</div>
        <h2>Thank You for Your Order!</h2>
        <p class="success-lead">Your order has been placed successfully and is being processed.</p>

        <c:if test="${not empty order}">
            <div class="order-summary-card">
                <div class="summary-line">
                    <strong>Order ID:</strong>
                    <span>#<c:out value="${order.orderId}"/></span>
                </div>
                <div class="summary-line">
                    <strong>Total Amount:</strong>
                    <span>₹<c:out value="${order.totalAmount}"/></span>
                </div>
                <div class="summary-line">
                    <strong>Payment Method:</strong>
                    <span><c:out value="${order.paymentMethod}"/> (<c:out value="${order.paymentStatus}"/>)</span>
                </div>
                <div class="summary-line">
                    <strong>Order Status:</strong>
                    <span class="status-badge status-${order.orderStatus.toLowerCase()}"><c:out value="${order.orderStatus}"/></span>
                </div>
                <c:if test="${not empty order.shippingAddress}">
                    <div class="summary-line">
                        <strong>Delivery Address:</strong>
                        <span><c:out value="${order.shippingAddress}"/></span>
                    </div>
                </c:if>
            </div>
        </c:if>

        <div class="success-actions">
            <c:if test="${not empty order}">
                <a class="btn-primary" href="${pageContext.request.contextPath}/order-details?id=${order.orderId}">
                    View Order Details
                </a>
            </c:if>
            <a class="btn-secondary" href="${pageContext.request.contextPath}/orders">
                My Orders
            </a>
            <a class="btn-secondary" href="${pageContext.request.contextPath}/products">
                Continue Shopping
            </a>
        </div>
    </main>

    <%@ include file="fragments/footer.jsp" %>
    <script src="${pageContext.request.contextPath}/js/script.js"></script>

</body>
</html>