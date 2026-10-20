<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders - ShopSphere</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <%@ include file="fragments/header.jsp" %>
    <%@ include file="fragments/navbar.jsp" %>

    <main class="home-container">
        <h2>My Order History</h2>

        <c:choose>
            <c:when test="${empty orders}">
                <div class="empty-state">
                    <p>You have not placed any orders yet.</p>
                    <a class="btn-primary" href="${pageContext.request.contextPath}/products">Start Shopping</a>
                </div>
            </c:when>

            <c:otherwise>
                <div class="orders-table-wrapper">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Order #</th>
                                <th>Date Placed</th>
                                <th>Total Amount</th>
                                <th>Payment</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${orders}">
                                <tr>
                                    <td><strong>#<c:out value="${order.orderId}"/></strong></td>
                                    <td><c:out value="${order.createdAt}"/></td>
                                    <td><strong>₹<c:out value="${order.totalAmount}"/></strong></td>
                                    <td>
                                        <c:out value="${order.paymentMethod}"/>
                                        <span class="badge badge-sm">${order.paymentStatus}</span>
                                    </td>
                                    <td>
                                        <span class="status-badge status-${order.orderStatus.toLowerCase()}">
                                            <c:out value="${order.orderStatus}"/>
                                        </span>
                                    </td>
                                    <td>
                                        <a class="btn-sm" href="${pageContext.request.contextPath}/order-details?id=${order.orderId}">
                                            View Details
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </main>

    <%@ include file="fragments/footer.jsp" %>
    <script src="${pageContext.request.contextPath}/js/script.js"></script>

</body>
</html>