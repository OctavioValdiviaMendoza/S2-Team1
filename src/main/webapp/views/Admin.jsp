<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Log" %>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/Admin.css">
</head>
<body>

<div class="page-container">

    <!-- Header -->
    <div class="admin-header">
        <h1 class="admin-title">Admin Dashboard</h1>
        <p class="admin-subtitle">Recent User Activity</p>
    </div>

    <!-- Logs Section -->
    <div class="logs-container">

        <table class="logs-table">
            <thead>
                <tr class="logs-table-header">
                    <th>Log ID</th>
                    <th>User ID</th>
                    <th>Action</th>
                    <th>Details</th>
                    <th>Created At</th>
                </tr>
            </thead>

            <tbody class="logs-table-body">

            <%
                List<Log> logs = (List<Log>) request.getAttribute("logs");

                if (logs != null && !logs.isEmpty()) {
                    for (Log log : logs) {
            %>
                        <tr class="log-row">
                            <td class="log-id"><%= log.getLogId() %></td>

                            <td class="log-user">
                                <%= log.getUserId() == null ? "System" : log.getUserId() %>
                            </td>

                            <td class="log-action"><%= log.getAction() %></td>

                            <td class="log-details"><%= log.getDetails() %></td>

                            <td class="log-time"><%= log.getCreatedAt() %></td>
                        </tr>
            <%
                    }
                } else {
            %>
                    <tr class="no-logs-row">
                        <td colspan="5" class="no-logs-message">No logs found.</td>
                    </tr>
            <%
                }
            %>

            </tbody>
        </table>
    </div>

    <!-- Footer / Navigation -->
    <div class="admin-footer">
        <a class="back-link" href="<%= request.getContextPath() %>/BrowseServlet">
            Back to Browse
        </a>
    </div>

</div>

</body>
</html>