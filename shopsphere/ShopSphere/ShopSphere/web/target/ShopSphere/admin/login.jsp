<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Portal - ShopSphere</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="admin-body">

    <header class="header admin-header">
        <h1>ShopSphere Administration Portal</h1>
        <p>Restricted Access - Authorized Staff Only</p>
    </header>

    <main class="form-container">
        <h2>Administrator Login</h2>
        <p class="section-subtitle">Sign in with your administrative credentials.</p>

        <c:if test="${not empty sessionScope.adminError}">
            <div class="alert alert-error">
                <c:out value="${sessionScope.adminError}"/>
                <c:remove var="adminError" scope="session"/>
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert alert-error">
                <c:out value="${error}"/>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/admin/login" method="post" class="auth-form">
            <div class="form-group">
                <label for="admin-email">Admin Email:</label>
                <input type="email" id="admin-email" name="email" value="admin@shopsphere.com" required autofocus>
            </div>

            <div class="form-group">
                <label for="admin-password">Admin Password:</label>
                <input type="password" id="admin-password" name="password" placeholder="Enter admin password" required>
            </div>

            <button type="submit" class="btn-primary btn-block">Access Admin Dashboard</button>
        </form>

        <div class="auth-links">
            <p><a href="${pageContext.request.contextPath}/index.jsp">&larr; Return to Customer Store</a></p>
        </div>
    </main>

    <%@ include file="../fragments/footer.jsp" %>
    <script src="${pageContext.request.contextPath}/js/script.js"></script>

</body>
</html>
