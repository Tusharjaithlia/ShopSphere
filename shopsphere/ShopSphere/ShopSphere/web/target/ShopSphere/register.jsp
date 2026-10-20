<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - ShopSphere</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <%@ include file="fragments/header.jsp" %>
    <%@ include file="fragments/navbar.jsp" %>

    <main class="form-container">
        <h2>Create an Account</h2>
        <p class="section-subtitle">Join ShopSphere to enjoy easy ordering, wishlists, and discounts.</p>

        <c:if test="${not empty error}">
            <div class="alert alert-error">
                <c:out value="${error}"/>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/register" method="post" class="auth-form">
            <div class="form-group">
                <label for="name">Full Name:</label>
                <input type="text" id="name" name="name" placeholder="John Doe" required autofocus>
            </div>

            <div class="form-group">
                <label for="email">Email Address:</label>
                <input type="email" id="email" name="email" placeholder="john@example.com" required>
            </div>

            <div class="form-group">
                <label for="phone">Mobile Number:</label>
                <input type="tel" id="phone" name="phone" placeholder="10-digit mobile number" pattern="[0-9]{10}" required>
            </div>

            <div class="form-group">
                <label for="password">Password (minimum 6 characters):</label>
                <input type="password" id="password" name="password" minlength="6" placeholder="Choose a secure password" required>
            </div>

            <button type="submit" class="btn-primary btn-block">Register Account</button>
        </form>

        <div class="auth-links">
            <p>Already have an account? <a href="${pageContext.request.contextPath}/login">Sign in here</a></p>
        </div>
    </main>

    <%@ include file="fragments/footer.jsp" %>
    <script src="${pageContext.request.contextPath}/js/script.js"></script>

</body>
</html>