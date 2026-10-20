<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Orders - ShopSphere Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="admin-body">

    <%@ include file="fragments/adminNav.jsp" %>

    <main class="home-container admin-container">
        <div class="admin-page-header">
            <div>
                <h2>Customer Orders Management</h2>
                <p class="text-muted">Track customer orders, verify payments, and update fulfillment statuses.</p>
            </div>
        </div>

        <!-- Order Detail & Status Update Drawer (if order selected) -->
        <c:if test="${not empty selectedOrder}">
            <div class="admin-card order-edit-box">
                <div class="order-details-header">
                    <h3>Managing Order #<c:out value="${selectedOrder.orderId}"/></h3>
                    <a href="${pageContext.request.contextPath}/admin/orders" class="link-btn">&times; Close Detail</a>
                </div>

                <div class="order-info-grid">
                    <div class="info-block">
                        <p><strong>Customer:</strong> <c:out value="${selectedOrder.userName}"/> (<c:out value="${selectedOrder.userEmail}"/>)</p>
                        <p><strong>Shipping Address:</strong> <c:out value="${selectedOrder.shippingAddress}"/></p>
                        <p><strong>Date Placed:</strong> <c:out value="${selectedOrder.createdAt}"/></p>
                    </div>
                    <div class="info-block">
                        <p><strong>Total Amount:</strong> ₹<c:out value="${selectedOrder.totalAmount}"/></p>
                        <p><strong>Payment Method:</strong> <c:out value="${selectedOrder.paymentMethod}"/></p>
                        <p><strong>Current Status:</strong> <span class="status-badge status-${selectedOrder.orderStatus.toLowerCase()}">${selectedOrder.orderStatus}</span></p>
                    </div>
                </div>

                <!-- Update Status Form -->
                <div class="status-forms-row">
                    <form action="${pageContext.request.contextPath}/admin/orders" method="post" class="status-inline-form">
                        <input type="hidden" name="action" value="updateStatus">
                        <input type="hidden" name="orderId" value="${selectedOrder.orderId}">
                        <label for="orderStatus"><strong>Change Fulfillment Status:</strong></label>
                        <select name="orderStatus" id="orderStatus">
                            <option value="PLACED" ${selectedOrder.orderStatus eq 'PLACED' ? 'selected' : ''}>PLACED</option>
                            <option value="PROCESSING" ${selectedOrder.orderStatus eq 'PROCESSING' ? 'selected' : ''}>PROCESSING</option>
                            <option value="SHIPPED" ${selectedOrder.orderStatus eq 'SHIPPED' ? 'selected' : ''}>SHIPPED</option>
                            <option value="DELIVERED" ${selectedOrder.orderStatus eq 'DELIVERED' ? 'selected' : ''}>DELIVERED</option>
                            <option value="CANCELLED" ${selectedOrder.orderStatus eq 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
                        </select>
                        <button type="submit" class="btn-sm">Update Status</button>
                    </form>

                    <form action="${pageContext.request.contextPath}/admin/orders" method="post" class="status-inline-form">
                        <input type="hidden" name="action" value="updatePayment">
                        <input type="hidden" name="orderId" value="${selectedOrder.orderId}">
                        <label for="paymentStatus"><strong>Change Payment Status:</strong></label>
                        <select name="paymentStatus" id="paymentStatus">
                            <option value="PENDING" ${selectedOrder.paymentStatus eq 'PENDING' ? 'selected' : ''}>PENDING</option>
                            <option value="COMPLETED" ${selectedOrder.paymentStatus eq 'COMPLETED' ? 'selected' : ''}>COMPLETED</option>
                            <option value="FAILED" ${selectedOrder.paymentStatus eq 'FAILED' ? 'selected' : ''}>FAILED</option>
                            <option value="REFUNDED" ${selectedOrder.paymentStatus eq 'REFUNDED' ? 'selected' : ''}>REFUNDED</option>
                        </select>
                        <button type="submit" class="btn-sm">Update Payment</button>
                    </form>
                </div>

                <h4 style="margin-top: 15px;">Ordered Items</h4>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Item Name</th>
                            <th>Unit Price</th>
                            <th>Quantity</th>
                            <th>Subtotal</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${orderItems}">
                            <tr>
                                <td><strong><c:out value="${item.productName}"/></strong></td>
                                <td>₹<c:out value="${item.price}"/></td>
                                <td><c:out value="${item.quantity}"/></td>
                                <td><strong>₹<c:out value="${item.subtotal}"/></strong></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>

        <!-- All Orders Table -->
        <div class="admin-card">
            <h3>All Customer Orders</h3>

            <c:choose>
                <c:when test="${empty orders}">
                    <p class="empty-state-sm">No orders found.</p>
                </c:when>
                <c:otherwise>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Order #</th>
                                <th>Customer</th>
                                <th>Date</th>
                                <th>Total</th>
                                <th>Payment</th>
                                <th>Fulfillment</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="o" items="${orders}">
                                <tr>
                                    <td><strong>#<c:out value="${o.orderId}"/></strong></td>
                                    <td><c:out value="${o.userName}"/><br><small class="text-muted"><c:out value="${o.userEmail}"/></small></td>
                                    <td><c:out value="${o.createdAt}"/></td>
                                    <td><strong>₹<c:out value="${o.totalAmount}"/></strong></td>
                                    <td>
                                        <span class="badge badge-sm">${o.paymentMethod}</span><br>
                                        <small class="badge badge-xs">${o.paymentStatus}</small>
                                    </td>
                                    <td>
                                        <span class="status-badge status-${o.orderStatus.toLowerCase()}">
                                            <c:out value="${o.orderStatus}"/>
                                        </span>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/orders?id=${o.orderId}" class="btn-sm">
                                            Manage Order
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

    <%@ include file="../fragments/footer.jsp" %>
    <script src="${pageContext.request.contextPath}/js/script.js"></script>

</body>
</html>
