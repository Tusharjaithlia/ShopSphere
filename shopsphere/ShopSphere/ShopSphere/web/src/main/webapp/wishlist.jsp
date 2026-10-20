<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Wishlist - ShopSphere</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <%@ include file="fragments/header.jsp" %>
    <%@ include file="fragments/navbar.jsp" %>

    <main class="home-container">
        <h2>My Wishlist ❤️</h2>

        <c:choose>
            <c:when test="${empty wishlistItems}">
                <div class="empty-state">
                    <p>Your wishlist is currently empty.</p>
                    <a class="btn-primary" href="${pageContext.request.contextPath}/products">Explore Products</a>
                </div>
            </c:when>

            <c:otherwise>
                <div class="product-grid">
                    <c:forEach var="item" items="${wishlistItems}">
                        <div class="product-card">
                            <div class="product-image-container">
                                <c:choose>
                                    <c:when test="${not empty item.imageUrl}">
                                        <img src="${item.imageUrl}" alt="${item.productName}" class="product-thumb">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="product-placeholder">📦</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <h3 class="product-title">
                                <a href="${pageContext.request.contextPath}/product-details?id=${item.productId}">
                                    <c:out value="${item.productName}"/>
                                </a>
                            </h3>

                            <div class="product-price-row">
                                <span class="price-current">₹<c:out value="${item.price}"/></span>
                            </div>

                            <div class="product-card-actions">
                                <form action="${pageContext.request.contextPath}/cart" method="post" style="flex:1;">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="productId" value="${item.productId}">
                                    <input type="hidden" name="quantity" value="1">
                                    <button type="submit" class="btn-add-cart">Move to Cart</button>
                                </form>

                                <form action="${pageContext.request.contextPath}/wishlist" method="post">
                                    <input type="hidden" name="action" value="remove">
                                    <input type="hidden" name="productId" value="${item.productId}">
                                    <button type="submit" class="btn-danger-sm" title="Remove from Wishlist">✕</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </main>

    <%@ include file="fragments/footer.jsp" %>
    <script src="${pageContext.request.contextPath}/js/script.js"></script>

</body>
</html>