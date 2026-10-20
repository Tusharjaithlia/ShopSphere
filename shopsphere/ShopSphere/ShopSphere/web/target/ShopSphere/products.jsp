<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products - ShopSphere</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <%@ include file="fragments/header.jsp" %>
    <%@ include file="fragments/navbar.jsp" %>

    <main class="home-container">

        <div class="catalog-header">
            <div>
                <h2>Product Catalog</h2>
                <c:if test="${not empty searchQuery || not empty selectedCategory}">
                    <p class="filter-indicator">
                        Filtered by:
                        <c:if test="${not empty searchQuery}">Keyword "<strong><c:out value="${searchQuery}"/></strong>" </c:if>
                        <c:if test="${not empty selectedCategory}">
                            <c:forEach var="c" items="${categories}">
                                <c:if test="${c.categoryId == selectedCategory}">Category "<strong><c:out value="${c.name}"/></strong>"</c:if>
                            </c:forEach>
                        </c:if>
                        | <a href="${pageContext.request.contextPath}/products">Clear Filters</a>
                    </p>
                </c:if>
            </div>

            <!-- Category & Search Filter Bar -->
            <form action="${pageContext.request.contextPath}/products" method="get" class="filter-form">
                <input type="text" name="query" placeholder="Filter by name..." value="${param.query}">
                <select name="category" onchange="this.form.submit()">
                    <option value="">All Categories</option>
                    <c:forEach var="cat" items="${categories}">
                        <option value="${cat.categoryId}" ${selectedCategory == cat.categoryId ? 'selected' : ''}>
                            <c:out value="${cat.name}"/>
                        </option>
                    </c:forEach>
                </select>
                <button type="submit" class="btn-sm">Filter</button>
            </form>
        </div>

        <c:choose>
            <c:when test="${empty products}">
                <div class="empty-state">
                    <p>No products found matching your criteria.</p>
                    <a class="btn-primary" href="${pageContext.request.contextPath}/products">View All Products</a>
                </div>
            </c:when>

            <c:otherwise>
                <div class="product-grid">
                    <c:forEach var="product" items="${products}">
                        <div class="product-card">
                            <div class="product-image-container">
                                <c:choose>
                                    <c:when test="${not empty product.imageUrl}">
                                        <img src="${product.imageUrl}" alt="${product.name}" class="product-thumb">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="product-placeholder">📦</div>
                                    </c:otherwise>
                                </c:choose>
                                <c:if test="${product.discount > 0}">
                                    <span class="discount-badge">${product.discount}% OFF</span>
                                </c:if>
                            </div>

                            <c:if test="${not empty product.categoryName}">
                                <span class="category-tag"><c:out value="${product.categoryName}"/></span>
                            </c:if>

                            <h3 class="product-title">
                                <a href="${pageContext.request.contextPath}/product-details?id=${product.productId}">
                                    <c:out value="${product.name}"/>
                                </a>
                            </h3>

                            <p class="product-brand"><c:out value="${product.brand}"/></p>

                            <div class="product-price-row">
                                <span class="price-current">₹<c:out value="${product.effectivePrice}"/></span>
                                <c:if test="${product.discount > 0}">
                                    <span class="price-original">₹<c:out value="${product.price}"/></span>
                                </c:if>
                            </div>

                            <p class="product-stock ${product.stock > 0 ? 'in-stock' : 'out-of-stock'}">
                                ${product.stock > 0 ? 'In Stock (' += product.stock += ' left)' : 'Out of Stock'}
                            </p>

                            <div class="product-card-actions">
                                <c:choose>
                                    <c:when test="${product.stock > 0}">
                                        <form action="${pageContext.request.contextPath}/cart" method="post" class="add-cart-form">
                                            <input type="hidden" name="action" value="add">
                                            <input type="hidden" name="productId" value="${product.productId}">
                                            <input type="number" name="quantity" value="1" min="1" max="${product.stock}" class="qty-input" required>
                                            <button type="submit" class="btn-add-cart">Add to Cart</button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <button class="btn-disabled" disabled>Out of Stock</button>
                                    </c:otherwise>
                                </c:choose>

                                <!-- Wishlist Button -->
                                <form action="${pageContext.request.contextPath}/wishlist" method="post" class="wishlist-form">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="productId" value="${product.productId}">
                                    <button type="submit" class="btn-wishlist" title="Add to Wishlist">❤️</button>
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