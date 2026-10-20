<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<nav class="navbar admin-navbar">
    <div class="nav-left">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-brand admin-brand">ShopSphere Admin</a>
        <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/products">Products</a>
        <a href="${pageContext.request.contextPath}/admin/categories">Categories</a>
        <a href="${pageContext.request.contextPath}/admin/orders">Orders</a>
        <a href="${pageContext.request.contextPath}/admin/users">Customers</a>
    </div>

    <div class="nav-right">
        <a href="${pageContext.request.contextPath}/products" target="_blank" class="storefront-link">🛍️ View Storefront</a>
        <span class="user-info">Logged in as: <strong><c:out value="${sessionScope.user.name}"/></strong></span>
        <a href="${pageContext.request.contextPath}/logout" class="nav-logout">Logout</a>
    </div>
</nav>
