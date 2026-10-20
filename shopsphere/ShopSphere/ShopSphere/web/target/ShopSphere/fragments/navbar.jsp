<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<nav class="navbar">
    <div class="nav-left">
        <a href="${pageContext.request.contextPath}/index.jsp" class="nav-brand">ShopSphere</a>
        <a href="${pageContext.request.contextPath}/products">Products</a>
        <a href="${pageContext.request.contextPath}/categories">Categories</a>
    </div>

    <div class="nav-search">
        <form action="${pageContext.request.contextPath}/products" method="get">
            <input type="text" name="query" placeholder="Search products, brands..." value="${param.query}">
            <button type="submit">Search</button>
        </form>
    </div>

    <div class="nav-right">
        <a href="${pageContext.request.contextPath}/cart">
            🛒 Cart
            <c:if test="${not empty sessionScope.cartItems && sessionScope.cartItems.size() > 0}">
                <span class="badge">${sessionScope.cartItems.size()}</span>
            </c:if>
        </a>

        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                <a href="${pageContext.request.contextPath}/wishlist">❤️ Wishlist</a>
                <a href="${pageContext.request.contextPath}/orders">📦 My Orders</a>
                <a href="${pageContext.request.contextPath}/profile">👤 <c:out value="${sessionScope.user.name}"/></a>

                <c:if test="${sessionScope.user.admin}">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="admin-badge-link">⚡ Admin Panel</a>
                </c:if>

                <a href="${pageContext.request.contextPath}/logout" class="nav-logout">Logout</a>
            </c:when>

            <c:otherwise>
                <a href="${pageContext.request.contextPath}/login">Login</a>
                <a href="${pageContext.request.contextPath}/register">Register</a>
                <a href="${pageContext.request.contextPath}/admin/login" class="admin-link">Admin</a>
            </c:otherwise>
        </c:choose>
    </div>
</nav>