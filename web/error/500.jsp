<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Server Error | QuickWash</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/style.css">
</head>
<body>
<main class="error-page-shell">
    <section class="error-card">
        <a class="brand error-brand" href="<%= contextPath %>/index.jsp">
            <span class="brand-mark">QW</span>
            <span>QuickWash</span>
        </a>
        <span class="error-code">500</span>
        <h1>Something went wrong</h1>
        <p>QuickWash could not complete this request right now. Please try again or return to your dashboard.</p>
        <div class="error-actions">
            <a class="btn btn-primary" href="<%= contextPath %>/index.jsp">Go Home</a>
            <a class="btn btn-secondary" href="<%= contextPath %>/login.jsp">Login</a>
        </div>
    </section>
</main>
</body>
</html>
