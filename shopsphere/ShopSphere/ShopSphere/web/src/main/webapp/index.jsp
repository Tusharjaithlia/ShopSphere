<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ShopSphere - Modern E-Commerce</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <%@ include file="fragments/header.jsp" %>
    <%@ include file="fragments/navbar.jsp" %>

    <section class="hero-section">
        <div class="hero-content">
            <h1>Discover What's New at ShopSphere</h1>
            <p>Shop top brands, trending electronics, modern fashion, and bestselling books at unmatched prices.</p>
            <div class="hero-actions">
                <a class="btn-primary" href="${pageContext.request.contextPath}/products">Explore Products</a>
                <a class="btn-secondary" href="${pageContext.request.contextPath}/categories">Browse Categories</a>
            </div>
        </div>
    </section>

    <main class="home-container">
        <section class="features-bar">
            <div class="feature-item">
                <div class="feature-icon">🚚</div>
                <h3>Fast Delivery</h3>
                <p>Express shipping directly to your doorstep</p>
            </div>
            <div class="feature-item">
                <div class="feature-icon">🔒</div>
                <h3>Secure Transactions</h3>
                <p>Protected checkout with verified demo payments</p>
            </div>
            <div class="feature-item">
                <div class="feature-icon">🏷️</div>
                <h3>Discount Coupons</h3>
                <p>Use code <strong>WELCOME10</strong> for 10% off</p>
            </div>
            <div class="feature-item">
                <div class="feature-icon">⭐</div>
                <h3>Verified Reviews</h3>
                <p>Read real community ratings and feedback</p>
            </div>
        </section>

        <section class="cta-banner">
            <h2>Ready to Start Shopping?</h2>
            <p>Sign up now to save your cart, build wishlists, and track orders seamlessly.</p>
            <c:choose>
                <c:when test="${empty sessionScope.user}">
                    <a class="btn-primary" href="${pageContext.request.contextPath}/register">Create an Account</a>
                </c:when>
                <c:otherwise>
                    <a class="btn-primary" href="${pageContext.request.contextPath}/products">Browse Catalog</a>
                </c:otherwise>
            </c:choose>
        </section>
    </main>

    <%@ include file="fragments/footer.jsp" %>
    <script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>