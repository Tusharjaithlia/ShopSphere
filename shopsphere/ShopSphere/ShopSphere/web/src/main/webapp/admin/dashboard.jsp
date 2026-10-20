<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - ShopSphere</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="admin-body">

    <%@ include file="fragments/adminNav.jsp" %>

    <main class="home-container admin-container">
        <div class="admin-page-header">
            <div>
                <h2>Dashboard Overview</h2>
                <p class="text-muted">Welcome back, Administrator. Real-time store statistics.</p>
            </div>
            <div class="admin-header-actions">
                <a href="${pageContext.request.contextPath}/admin/products" class="btn-primary">+ Manage Products</a>
                <a href="${pageContext.request.contextPath}/admin/categories" class="btn-secondary">+ Manage Categories</a>
            </div>
        </div>

        <!-- Metric KPI Cards -->
        <div class="metrics-grid">
            <div class="metric-card revenue">
                <div class="metric-icon">💰</div>
                <div class="metric-content">
                    <span class="metric-title">Total Revenue</span>
                    <h3>₹<c:out value="${totalRevenue}"/></h3>
                </div>
            </div>

            <div class="metric-card orders">
                <div class="metric-icon">📦</div>
                <div class="metric-content">
                    <span class="metric-title">Total Orders</span>
                    <h3><c:out value="${orderCount}"/></h3>
                </div>
            </div>

            <div class="metric-card products">
                <div class="metric-icon">🏷️</div>
                <div class="metric-content">
                    <span class="metric-title">Total Products</span>
                    <h3><c:out value="${productCount}"/></h3>
                </div>
            </div>

            <div class="metric-card categories">
                <div class="metric-icon">📂</div>
                <div class="metric-content">
                    <span class="metric-title">Categories</span>
                    <h3><c:out value="${categoryCount}"/></h3>
                </div>
            </div>

            <div class="metric-card users">
                <div class="metric-icon">👥</div>
                <div class="metric-content">
                    <span class="metric-title">Customers</span>
                    <h3><c:out value="${userCount}"/></h3>
                </div>
            </div>
        </div>

        <!-- Recent Orders Section -->
        <section class="admin-section">
            <div class="section-header">
                <h3>Recent Customer Orders</h3>
                <a href="${pageContext.request.contextPath}/admin/orders" class="link-btn">View All Orders &rarr;</a>
            </div>

            <c:choose>
                <c:when test="${empty recentOrders}">
                    <p class="empty-state-sm">No orders recorded yet.</p>
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
                                <th>Order Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="ord" items="${recentOrders}">
                                <tr>
                                    <td><strong>#<c:out value="${ord.orderId}"/></strong></td>
                                    <td><c:out value="${ord.userName}"/> (<c:out value="${ord.userEmail}"/>)</td>
                                    <td><c:out value="${ord.createdAt}"/></td>
                                    <td><strong>₹<c:out value="${ord.totalAmount}"/></strong></td>
                                    <td><span class="badge badge-sm">${ord.paymentStatus}</span></td>
                                    <td>
                                        <span class="status-badge status-${ord.orderStatus.toLowerCase()}">
                                            <c:out value="${ord.orderStatus}"/>
                                        </span>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/orders?id=${ord.orderId}" class="btn-xs">Manage</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </section>
    </main>

    <%@ include file="../fragments/footer.jsp" %>
    <script src="${pageContext.request.contextPath}/js/script.js"></script>

</body>
</html>
