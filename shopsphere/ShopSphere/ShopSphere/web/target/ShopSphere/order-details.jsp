<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order #<c:out value="${order.orderId}"/> Details - ShopSphere</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <%@ include file="fragments/header.jsp" %>
    <%@ include file="fragments/navbar.jsp" %>

    <main class="home-container">
        <c:choose>
            <c:when test="${empty order}">
                <div class="empty-state">
                    <p>Order not found.</p>
                    <a class="btn-primary" href="${pageContext.request.contextPath}/orders">Back to Orders</a>
                </div>
            </c:when>

            <c:otherwise>
                <div class="order-details-card">
                    <div class="order-details-header">
                        <div>
                            <h2>Order #<c:out value="${order.orderId}"/></h2>
                            <p class="text-muted">Placed on: <c:out value="${order.createdAt}"/></p>
                        </div>
                        <div class="header-badges">
                            <span class="status-badge status-${order.orderStatus.toLowerCase()}"><c:out value="${order.orderStatus}"/></span>
                            <span class="badge badge-payment">${order.paymentMethod} - ${order.paymentStatus}</span>
                        </div>
                    </div>

                    <div class="order-info-grid">
                        <div class="info-block">
                            <h4>Shipping Address</h4>
                            <p><c:out value="${order.shippingAddress}"/></p>
                        </div>
                        <div class="info-block">
                            <h4>Payment Details</h4>
                            <p>Method: <strong><c:out value="${order.paymentMethod}"/></strong></p>
                            <p>Status: <strong><c:out value="${order.paymentStatus}"/></strong></p>
                        </div>
                    </div>

                    <h3>Ordered Items</h3>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Product</th>
                                <th>Unit Price</th>
                                <th>Quantity</th>
                                <th>Subtotal</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${orderItems}">
                                <tr>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/product-details?id=${item.productId}">
                                            <strong><c:out value="${item.productName}"/></strong>
                                        </a>
                                    </td>
                                    <td>₹<c:out value="${item.price}"/></td>
                                    <td><c:out value="${item.quantity}"/></td>
                                    <td><strong>₹<c:out value="${item.subtotal}"/></strong></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <div class="order-totals-box">
                        <c:if test="${order.discount > 0}">
                            <div class="summary-line discount-line">
                                <span>Coupon Discount:</span>
                                <span>- ₹<c:out value="${order.discount}"/></span>
                            </div>
                        </c:if>
                        <div class="summary-line total-line">
                            <span>Total Amount:</span>
                            <span class="total-amount">₹<c:out value="${order.totalAmount}"/></span>
                        </div>
                    </div>

                    <div class="order-actions">
                        <a class="btn-secondary" href="${pageContext.request.contextPath}/orders">&larr; Back to Orders</a>
                        <a class="btn-primary" href="${pageContext.request.contextPath}/products">Continue Shopping</a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </main>

    <%@ include file="fragments/footer.jsp" %>
    <script src="${pageContext.request.contextPath}/js/script.js"></script>

</body>
</html>