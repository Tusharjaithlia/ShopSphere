<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - ShopSphere</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <%@ include file="fragments/header.jsp" %>
    <%@ include file="fragments/navbar.jsp" %>

    <main class="home-container">
        <h2>My Account & Profile</h2>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">
                <c:out value="${successMessage}"/>
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert alert-error">
                <c:out value="${error}"/>
            </div>
        </c:if>

        <c:choose>
            <c:when test="${empty sessionScope.user}">
                <div class="empty-state">
                    <p>Please log in to manage your profile.</p>
                    <a class="btn-primary" href="${pageContext.request.contextPath}/login">Login</a>
                </div>
            </c:when>

            <c:otherwise>
                <div class="profile-layout">
                    <!-- Left: Profile Info & Update Form -->
                    <div class="profile-card">
                        <h3>Personal Information</h3>
                        <form action="${pageContext.request.contextPath}/profile" method="post">
                            <input type="hidden" name="action" value="updateProfile">

                            <div class="form-group">
                                <label for="prof-name">Full Name:</label>
                                <input type="text" id="prof-name" name="name" value="${sessionScope.user.name}" required>
                            </div>

                            <div class="form-group">
                                <label for="prof-email">Email Address:</label>
                                <input type="email" id="prof-email" value="${sessionScope.user.email}" disabled>
                                <small class="text-muted">Email cannot be changed.</small>
                            </div>

                            <div class="form-group">
                                <label for="prof-phone">Mobile / Phone:</label>
                                <input type="text" id="prof-phone" name="phone" value="${sessionScope.user.phone}" placeholder="10-digit mobile number">
                            </div>

                            <div class="form-group">
                                <label>Account Role:</label>
                                <span class="badge"><c:out value="${sessionScope.user.role}"/></span>
                            </div>

                            <button type="submit" class="btn-primary">Update Profile</button>
                        </form>
                    </div>

                    <!-- Right: Password Change Form -->
                    <div class="profile-card">
                        <h3>Security & Password</h3>
                        <form action="${pageContext.request.contextPath}/profile" method="post">
                            <input type="hidden" name="action" value="changePassword">

                            <div class="form-group">
                                <label for="oldPassword">Current Password:</label>
                                <input type="password" id="oldPassword" name="oldPassword" required>
                            </div>

                            <div class="form-group">
                                <label for="newPassword">New Password:</label>
                                <input type="password" id="newPassword" name="newPassword" minlength="6" required>
                            </div>

                            <div class="form-group">
                                <label for="confirmPassword">Confirm New Password:</label>
                                <input type="password" id="confirmPassword" name="confirmPassword" minlength="6" required>
                            </div>

                            <button type="submit" class="btn-secondary">Change Password</button>
                        </form>

                        <hr style="margin: 20px 0;">

                        <div class="quick-profile-links">
                            <a class="btn-secondary btn-block" href="${pageContext.request.contextPath}/orders">📦 View Order History</a>
                            <a class="btn-secondary btn-block" href="${pageContext.request.contextPath}/wishlist">❤️ View My Wishlist</a>
                        </div>
                    </div>
                </div>

                <!-- Saved Addresses Section -->
                <c:if test="${not empty addresses}">
                    <section class="saved-addresses-section">
                        <h3>Saved Delivery Addresses</h3>
                        <div class="category-grid">
                            <c:forEach var="addr" items="${addresses}">
                                <div class="category-card address-card">
                                    <span class="badge badge-sm"><c:out value="${addr.addressType}"/></span>
                                    <p><c:out value="${addr.fullAddress}"/></p>
                                </div>
                            </c:forEach>
                        </div>
                    </section>
                </c:if>

            </c:otherwise>
        </c:choose>
    </main>

    <%@ include file="fragments/footer.jsp" %>
    <script src="${pageContext.request.contextPath}/js/script.js"></script>

</body>
</html>