<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - ShopSphere</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <%@ include file="fragments/header.jsp" %>
    <%@ include file="fragments/navbar.jsp" %>

    <main class="form-container">
        <h2>Customer Login</h2>
        <p class="section-subtitle">Welcome back! Sign in to access your orders and cart.</p>

        <c:if test="${param.registered eq 'true'}">
            <div class="alert alert-success">
                Registration successful! Please sign in with your credentials.
            </div>
        </c:if>

        <c:if test="${not empty sessionScope.authMessage}">
            <div class="alert alert-info">
                <c:out value="${sessionScope.authMessage}"/>
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert alert-error">
                <c:out value="${error}"/>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post" class="auth-form">
            <div class="form-group">
                <label for="email">Email Address:</label>
                <input type="email" id="email" name="email" placeholder="name@example.com" required autofocus>
            </div>

            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" placeholder="Enter your password" required>
            </div>

            <button type="submit" class="btn-primary btn-block">Sign In</button>
        </form>

        <div class="auth-links">
            <p>Don't have an account? <a href="${pageContext.request.contextPath}/register">Register here</a></p>
            <p>Are you a store manager? <a href="${pageContext.request.contextPath}/admin/login">Admin Login</a></p>
        </div>
    </main>

    <%@ include file="fragments/footer.jsp" %>
    <script src="${pageContext.request.contextPath}/js/script.js"></script>

</body>
</html>