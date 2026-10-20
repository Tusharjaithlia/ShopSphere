<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ attribute name="score" required="true" type="java.lang.Number" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<span class="stars">
    <c:forEach begin="1" end="5" var="i">
        <c:choose>
            <c:when test="${i <= score}">★</c:when>
            <c:otherwise>☆</c:otherwise>
        </c:choose>
    </c:forEach>
</span>
