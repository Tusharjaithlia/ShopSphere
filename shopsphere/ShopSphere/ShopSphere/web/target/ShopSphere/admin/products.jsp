<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Products - ShopSphere Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="admin-body">

    <%@ include file="fragments/adminNav.jsp" %>

    <main class="home-container admin-container">
        <div class="admin-page-header">
            <div>
                <h2>Product Catalog Management</h2>
                <p class="text-muted">Add, update, or remove products and maintain accurate inventory stocks.</p>
            </div>
        </div>

        <!-- Add Product Form Card -->
        <div class="admin-card">
            <h3>Add New Product</h3>
            <form action="${pageContext.request.contextPath}/admin/products" method="post" class="product-admin-form">
                <input type="hidden" name="action" value="add">

                <div class="form-row-three">
                    <div class="form-group">
                        <label for="p-name">Product Name *</label>
                        <input type="text" id="p-name" name="name" placeholder="e.g. Sony WH-1000XM5" required>
                    </div>

                    <div class="form-group">
                        <label for="p-category">Category *</label>
                        <select id="p-category" name="categoryId" required>
                            <option value="">Select Category</option>
                            <c:forEach var="c" items="${categories}">
                                <option value="${c.categoryId}"><c:out value="${c.name}"/></option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="p-brand">Brand</label>
                        <input type="text" id="p-brand" name="brand" placeholder="e.g. Sony">
                    </div>
                </div>

                <div class="form-row-three">
                    <div class="form-group">
                        <label for="p-price">Price (₹) *</label>
                        <input type="number" step="0.01" id="p-price" name="price" placeholder="2999.00" required>
                    </div>

                    <div class="form-group">
                        <label for="p-discount">Discount (%)</label>
                        <input type="number" step="0.01" id="p-discount" name="discount" value="0.0" placeholder="0">
                    </div>

                    <div class="form-group">
                        <label for="p-stock">Stock Inventory *</label>
                        <input type="number" id="p-stock" name="stock" value="10" min="0" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="p-image">Image URL</label>
                    <input type="url" id="p-image" name="imageUrl" placeholder="https://images.unsplash.com/...">
                </div>

                <div class="form-group">
                    <label for="p-desc">Description</label>
                    <textarea id="p-desc" name="description" rows="2" placeholder="Product features and specifications..."></textarea>
                </div>

                <label class="checkbox-label">
                    <input type="checkbox" name="status" value="true" checked>
                    Product is Active and visible for sale
                </label>

                <button type="submit" class="btn-primary">Add Product to Store</button>
            </form>
        </div>

        <!-- Products Table -->
        <div class="admin-card" style="margin-top: 25px;">
            <h3>Current Inventory (<c:out value="${products.size()}"/> Products)</h3>

            <c:choose>
                <c:when test="${empty products}">
                    <p class="empty-state-sm">No products in inventory.</p>
                </c:when>
                <c:otherwise>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Item</th>
                                <th>Category</th>
                                <th>Price</th>
                                <th>Stock</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${products}">
                                <tr>
                                    <td class="cart-product-cell">
                                        <c:if test="${not empty p.imageUrl}">
                                            <img src="${p.imageUrl}" alt="${p.name}" class="cart-thumb">
                                        </c:if>
                                        <div>
                                            <strong><c:out value="${p.name}"/></strong>
                                            <p class="table-subtext"><c:out value="${p.brand}"/></p>
                                        </div>
                                    </td>
                                    <td><c:out value="${p.categoryName}"/></td>
                                    <td>
                                        ₹<c:out value="${p.price}"/>
                                        <c:if test="${p.discount > 0}"><small class="text-discount">(${p.discount}% off)</small></c:if>
                                    </td>
                                    <td>
                                        <span class="stock-badge ${p.stock <= 5 ? 'stock-low' : 'stock-ok'}">
                                            <c:out value="${p.stock}"/> units
                                        </span>
                                    </td>
                                    <td>
                                        <span class="status-badge ${p.status ? 'status-active' : 'status-inactive'}">
                                            ${p.status ? 'Active' : 'Inactive'}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="table-actions">
                                            <a href="${pageContext.request.contextPath}/product-details?id=${p.productId}" target="_blank" class="btn-xs">View</a>
                                            <form action="${pageContext.request.contextPath}/admin/products" method="post" data-confirm="Delete product '${p.name}'?">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="productId" value="${p.productId}">
                                                <button type="submit" class="btn-danger-sm">Delete</button>
                                            </form>
                                        </div>
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
