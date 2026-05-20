<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.User" %>
<%
    String contextPath = request.getContextPath();
    String userName = (String) session.getAttribute("userName");
    List<User> users = (List<User>) request.getAttribute("users");
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users | QuickWash</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/style.css">
</head>
<body>
<div class="dashboard-shell">
    <aside class="sidebar">
        <a class="brand" href="<%= contextPath %>/admin"><span class="brand-mark">QW</span><span>Admin Panel</span></a>
        <p class="sidebar-label">QuickWash management</p>
        <nav class="side-nav">
            <a href="<%= contextPath %>/admin"><span class="side-icon">DB</span>Dashboard</a>
            <a class="active" href="<%= contextPath %>/admin?action=users"><span class="side-icon">US</span>Manage Users</a>
            <a href="<%= contextPath %>/vendors?action=list"><span class="side-icon">VN</span>Manage Vendors</a>
            <a href="<%= contextPath %>/services?action=list"><span class="side-icon">SV</span>Manage Services</a>
            <a href="<%= contextPath %>/admin?action=orders"><span class="side-icon">OR</span>All Orders</a>
            <a href="<%= contextPath %>/admin?action=reports"><span class="side-icon">RP</span>Reports</a>
        </nav>
        <div class="sidebar-bottom"><nav class="side-nav"><a href="<%= contextPath %>/index.jsp"><span class="side-icon">HM</span>Public Site</a><a class="logout-link" href="<%= contextPath %>/logout"><span class="side-icon">LO</span>Logout</a></nav></div>
    </aside>

    <main class="dashboard-main">
        <header class="dashboard-topbar">
            <h1>Manage Users</h1>
            <div class="topbar-actions"><span class="avatar">A</span><strong><%= userName != null ? userName : "Admin" %></strong></div>
        </header>

        <section class="dashboard-content">
            <% if (success != null) { %><div class="alert alert-success"><%= success %></div><% } %>
            <% if (error != null) { %><div class="alert alert-error"><%= error %></div><% } %>

            <section class="table-card">
                <div class="panel-title">
                    <h2>All Users</h2>
                </div>
                <table>
                    <thead>
                    <tr>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Role</th>
                        <th>Status</th>
                        <th>Approval</th>
                        <th>Created</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% if (users == null || users.isEmpty()) { %>
                        <tr><td colspan="7">No users found.</td></tr>
                    <% } else {
                        Integer currentUserId = (Integer) session.getAttribute("userId");
                        for (User user : users) {
                            boolean isCurrentAdmin = currentUserId != null && currentUserId == user.getUserId();
                    %>
                        <tr>
                            <td><span class="table-main"><%= user.getName() %></span></td>
                            <td><%= user.getEmail() %></td>
                            <td><%= user.getPhone() %></td>
                            <td><span class="badge badge-grey"><%= user.getRole() %></span></td>
                            <td><span class="badge <%= "active".equals(user.getStatus()) ? "badge-green" : "badge-amber" %>"><%= user.getStatus() %></span></td>
                            <td>
                                <% if ("pending".equals(user.getApprovalStatus())) { %>
                                    <span class="badge badge-amber">Pending</span>
                                <% } else if ("approved".equals(user.getApprovalStatus())) { %>
                                    <span class="badge badge-green">Approved</span>
                                <% } else { %>
                                    <span class="badge badge-red">Rejected</span>
                                <% } %>
                            </td>
                            <td><small><%= user.getCreatedAt() %></small></td>
                            <td class="table-actions">
                                <% if ("pending".equals(user.getApprovalStatus())) { %>
                                    <form action="<%= contextPath %>/admin?action=approve-user" method="POST" style="display:inline;">
                                        <input type="hidden" name="csrf_token" value="<%= session.getAttribute("csrfToken") %>">
                                        <input type="hidden" name="id" value="<%= user.getUserId() %>">
                                        <button type="submit" class="btn btn-primary btn-small">Approve</button>
                                    </form>
                                    <form action="<%= contextPath %>/admin?action=reject-user" method="POST" style="display:inline;">
                                        <input type="hidden" name="csrf_token" value="<%= session.getAttribute("csrfToken") %>">
                                        <input type="hidden" name="id" value="<%= user.getUserId() %>">
                                        <button type="submit" class="btn btn-danger btn-small">Reject</button>
                                    </form>
                                <% } else { %>
                                    <form action="<%= contextPath %>/admin?action=toggle-user-status" method="POST" style="display:inline;">
                                        <input type="hidden" name="csrf_token" value="<%= session.getAttribute("csrfToken") %>">
                                        <input type="hidden" name="id" value="<%= user.getUserId() %>">
                                        <button type="submit" class="btn btn-secondary btn-small"><%= "active".equals(user.getStatus()) ? "Deactivate" : "Activate" %></button>
                                    </form>
                                    <% if (!isCurrentAdmin) { %>
                                        <form action="<%= contextPath %>/admin?action=delete-user" method="POST" style="display:inline;" onsubmit="return confirm('Delete this user?');">
                                            <input type="hidden" name="csrf_token" value="<%= session.getAttribute("csrfToken") %>">
                                            <input type="hidden" name="id" value="<%= user.getUserId() %>">
                                            <button type="submit" class="btn btn-danger btn-small">Delete</button>
                                        </form>
                                    <% } %>
                                <% } %>
                            </td>
                        </tr>
                    <% } } %>
                    </tbody>
                </table>
            </section>
        </section>
    </main>
</div>
</body>
</html>
