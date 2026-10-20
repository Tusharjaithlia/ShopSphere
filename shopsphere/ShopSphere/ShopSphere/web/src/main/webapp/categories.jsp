<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Categories - ShopSphere</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <%@ include file="fragments/header.jsp" %>
    <%@ include file="fragments/navbar.jsp" %>

    <main class="home-container">
        <h2>Product Categories</h2>
        <p class="section-subtitle">Browse products curated by department</p>

        <c:choose>
            <c:when test="${empty categories}">
                <div class="empty-state">
                    <p>No categories found.</p>
                    <a class="btn-primary" href="${pageContext.request.contextPath}/products">Browse All Products</a>
                </div>
            </c:when>

            <c:otherwise>
                <div class="category-grid">
                    <c:forEach var="category" items="${categories}">
                        <div class="category-card">
                            <div class="category-icon">📂</div>
                            <h3><c:out value="${category.name}"/></h3>
                            <p><c:out value="${category.description}"/></p>
                            <a class="btn-secondary" href="${pageContext.request.contextPath}/products?category=${category.categoryId}">
                                Explore ${category.name} &rarr;
                            </a>
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