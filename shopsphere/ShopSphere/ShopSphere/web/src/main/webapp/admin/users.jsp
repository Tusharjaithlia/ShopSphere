<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Management - ShopSphere Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="admin-body">

    <%@ include file="fragments/adminNav.jsp" %>

    <main class="home-container admin-container">
        <div class="admin-page-header">
            <div>
                <h2>Customer & User Accounts</h2>
                <p class="text-muted">View registered accounts, verify roles, and activate or deactivate user logins.</p>
            </div>
        </div>

        <div class="admin-card">
            <h3>Registered Users (<c:out value="${users.size()}"/>)</h3>

            <c:choose>
                <c:when test="${empty users}">
                    <p class="empty-state-sm">No registered accounts found.</p>
                </c:when>
                <c:otherwise>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>User ID</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Mobile</th>
                                <th>Role</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="u" items="${users}">
                                <tr>
                                    <td>#<c:out value="${u.userId}"/></td>
                                    <td><strong><c:out value="${u.name}"/></strong></td>
                                    <td><c:out value="${u.email}"/></td>
                                    <td><c:out value="${u.mobile != null ? u.mobile : 'N/A'}"/></td>
                                    <td>
                                        <span class="badge ${u.admin ? 'badge-admin' : 'badge-customer'}">
                                            <c:out value="${u.role}"/>
                                        </span>
                                    </td>
                                    <td>
                                        <span class="status-badge ${u.status ? 'status-active' : 'status-inactive'}">
                                            ${u.status ? 'Active' : 'Disabled'}
                                        </span>
                                    </td>
                                    <td>
                                        <c:if test="${!u.admin}">
                                            <form action="${pageContext.request.contextPath}/admin/users" method="post" style="display:inline;">
                                                <input type="hidden" name="action" value="toggleStatus">
                                                <input type="hidden" name="userId" value="${u.userId}">
                                                <input type="hidden" name="status" value="${!u.status}">
                                                <button type="submit" class="btn-xs ${u.status ? 'btn-danger-sm' : 'btn-sm'}">
                                                    ${u.status ? 'Deactivate' : 'Activate'}
                                                </button>
                                            </form>
                                        </c:if>
                                        <c:if test="${u.admin}">
                                            <small class="text-muted">Protected</small>
                                        </c:if>
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
