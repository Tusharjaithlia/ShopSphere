<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${product.name}"/> - ShopSphere</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <%@ include file="fragments/header.jsp" %>
    <%@ include file="fragments/navbar.jsp" %>

    <main class="home-container">
        <c:choose>
            <c:when test="${empty product}">
                <div class="empty-state">
                    <p>Product not found.</p>
                    <a class="btn-primary" href="${pageContext.request.contextPath}/products">Back to Products</a>
                </div>
            </c:when>

            <c:otherwise>
                <div class="details-layout">
                    <!-- Left: Product Image -->
                    <div class="details-image-box">
                        <c:choose>
                            <c:when test="${not empty product.imageUrl}">
                                <img src="${product.imageUrl}" alt="${product.name}" class="details-image">
                            </c:when>
                            <c:otherwise>
                                <div class="product-placeholder large">📦</div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Right: Product Info -->
                    <div class="details-info-box">
                        <c:if test="${not empty product.categoryName}">
                            <span class="category-tag"><c:out value="${product.categoryName}"/></span>
                        </c:if>

                        <h2><c:out value="${product.name}"/></h2>
                        <p class="brand-text">Brand: <strong><c:out value="${product.brand}"/></strong></p>

                        <!-- Rating summary -->
                        <div class="rating-summary">
                            <span class="stars">
                                <c:forEach begin="1" end="5" var="i">
                                    <c:choose>
                                        <c:when test="${i <= avgRating}">★</c:when>
                                        <c:otherwise>☆</c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </span>
                            <span class="rating-text">${avgRating > 0 ? avgRating : 'No ratings yet'} (${reviewCount} reviews)</span>
                        </div>

                        <div class="product-price-row large">
                            <span class="price-current">₹<c:out value="${product.effectivePrice}"/></span>
                            <c:if test="${product.discount > 0}">
                                <span class="price-original">₹<c:out value="${product.price}"/></span>
                                <span class="discount-badge">${product.discount}% OFF</span>
                            </c:if>
                        </div>

                        <div class="description-section">
                            <h4>Description</h4>
                            <p><c:out value="${product.description}"/></p>
                        </div>

                        <p class="stock-status ${product.stock > 0 ? 'in-stock' : 'out-of-stock'}">
                            <strong>Availability:</strong> ${product.stock > 0 ? 'In Stock (' += product.stock += ' units available)' : 'Currently Out of Stock'}
                        </p>

                        <div class="details-action-buttons">
                            <c:if test="${product.stock > 0}">
                                <form action="${pageContext.request.contextPath}/cart" method="post" class="add-cart-form-large">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="productId" value="${product.productId}">
                                    <label for="detail-qty">Qty:</label>
                                    <input type="number" id="detail-qty" name="quantity" value="1" min="1" max="${product.stock}" class="qty-input">
                                    <button type="submit" class="btn-primary">Add to Shopping Cart</button>
                                </form>
                            </c:if>

                            <form action="${pageContext.request.contextPath}/wishlist" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="productId" value="${product.productId}">
                                <button type="submit" class="btn-secondary">❤️ Save to Wishlist</button>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Reviews and Ratings Section -->
                <section class="reviews-section">
                    <h3>Customer Reviews & Ratings</h3>

                    <!-- Write a Review Form -->
                    <div class="write-review-box">
                        <h4>Leave a Review</h4>
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <form action="${pageContext.request.contextPath}/review" method="post">
                                    <input type="hidden" name="productId" value="${product.productId}">

                                    <div class="form-row">
                                        <label for="reviewRating">Rating:</label>
                                        <select name="rating" id="reviewRating" required>
                                            <option value="5">⭐⭐⭐⭐⭐ (5 - Excellent)</option>
                                            <option value="4">⭐⭐⭐⭐ (4 - Very Good)</option>
                                            <option value="3">⭐⭐⭐ (3 - Good)</option>
                                            <option value="2">⭐⭐ (2 - Fair)</option>
                                            <option value="1">⭐ (1 - Poor)</option>
                                        </select>
                                    </div>

                                    <div class="form-row">
                                        <label for="reviewComment">Your Review:</label>
                                        <textarea id="reviewComment" name="reviewText" rows="3" placeholder="Share your experience with this product..." required></textarea>
                                    </div>

                                    <button type="submit" class="btn-primary">Submit Review</button>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <p><a href="${pageContext.request.contextPath}/login">Log in</a> to submit a review for this product.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Reviews List -->
                    <div class="reviews-list">
                        <c:choose>
                            <c:when test="${empty reviews}">
                                <p class="no-reviews">No reviews yet. Be the first to review this product!</p>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="rev" items="${reviews}">
                                    <div class="review-card">
                                        <div class="review-header">
                                            <strong><c:out value="${rev.userName}"/></strong>
                                            <span class="review-stars">
                                                <c:forEach begin="1" end="${rev.rating}">★</c:forEach>
                                                <c:forEach begin="${rev.rating + 1}" end="5">☆</c:forEach>
                                            </span>
                                            <span class="review-date"><c:out value="${rev.createdAt}"/></span>
                                        </div>
                                        <p class="review-content"><c:out value="${rev.reviewText}"/></p>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </section>

            </c:otherwise>
        </c:choose>
    </main>

    <%@ include file="fragments/footer.jsp" %>
    <script src="${pageContext.request.contextPath}/js/script.js"></script>

</body>
</html>