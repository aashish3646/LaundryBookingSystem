<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>QuickWash Login</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="form-container">
        <h2>Login to QuickWash</h2>

        <%
            String errorMessage = (String) request.getAttribute("errorMessage");
            if (errorMessage != null) {
        %>
            <p style="color: red;"><%= errorMessage %></p>
        <%
            }
        %>

        <form action="login" method="post">
            <label>Email:</label><br>
            <input type="email" name="email" placeholder="Enter your email" required><br><br>

            <label>Password:</label><br>
            <input type="password" name="password" placeholder="Enter your password" required><br><br>

            <button type="submit">Login</button>
        </form>

        <p>
            Don't have an account?
            <a href="register.jsp">Register here</a>
        </p>
    </div>
</body>
</html>