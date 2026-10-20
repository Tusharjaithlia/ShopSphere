<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Categories - ShopSphere Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="admin-body">

    <%@ include file="fragments/adminNav.jsp" %>

    <main class="home-container admin-container">
        <div class="admin-page-header">
            <div>
                <h2>Category Management</h2>
                <p class="text-muted">Organize your store catalog by creating and managing product categories.</p>
            </div>
        </div>

        <div class="admin-two-col">
            <!-- Left: Add New Category Form -->
            <div class="admin-card">
                <h3>Add New Category</h3>
                <form action="${pageContext.request.contextPath}/admin/categories" method="post">
                    <input type="hidden" name="action" value="add">

                    <div class="form-group">
                        <label for="cat-name">Category Name:</label>
                        <input type="text" id="cat-name" name="name" placeholder="e.g. Footwear" required>
                    </div>

                    <div class="form-group">
                        <label for="cat-desc">Description:</label>
                        <textarea id="cat-desc" name="description" rows="3" placeholder="Category description..."></textarea>
                    </div>

                    <label class="checkbox-label">
                        <input type="checkbox" name="status" value="true" checked>
                        Active (Visible on storefront)
                    </label>

                    <button type="submit" class="btn-primary btn-block">Save Category</button>
                </form>
            </div>

            <!-- Right: Existing Categories List -->
            <div class="admin-card">
                <h3>Existing Categories</h3>

                <c:choose>
                    <c:when test="${empty categories}">
                        <p class="empty-state-sm">No categories created yet.</p>
                    </c:when>
                    <c:otherwise>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="c" items="${categories}">
                                    <tr>
                                        <td>#<c:out value="${c.categoryId}"/></td>
                                        <td>
                                            <strong><c:out value="${c.name}"/></strong>
                                            <p class="table-subtext"><c:out value="${c.description}"/></p>
                                        </td>
                                        <td>
                                            <span class="status-badge ${c.status ? 'status-active' : 'status-inactive'}">
                                                ${c.status ? 'Active' : 'Inactive'}
                                            </span>
                                        </td>
                                        <td>
                                            <div class="table-actions">
                                                <form action="${pageContext.request.contextPath}/admin/categories" method="post" data-confirm="Delete category '${c.name}'?">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="categoryId" value="${c.categoryId}">
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
        </div>
    </main>

    <%@ include file="../fragments/footer.jsp" %>
    <script src="${pageContext.request.contextPath}/js/script.js"></script>

</body>
</html>
