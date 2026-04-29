<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="model.User" %>
<%@ page import="model.Listing" %>
<%@ page import="model.Booking" %>
<%
    String contextPath = request.getContextPath();

    User user = (User) request.getAttribute("user");
    List<Listing> listings = (List<Listing>) request.getAttribute("listings");
    List<Booking> pendingRequests = (List<Booking>) request.getAttribute("pendingRequests");
    List<Booking> processedRequests = (List<Booking>) request.getAttribute("processedRequests");

    String paymentMethod = (String) request.getAttribute("paymentMethod");
    String verificationStatus = (String) request.getAttribute("verificationStatus");
    String activeTab = (String) request.getAttribute("activeTab");

    String errorMessage = request.getAttribute("error") != null
        ? (String) request.getAttribute("error")
        : request.getParameter("error");

    String successMessage = request.getAttribute("message") != null
        ? (String) request.getAttribute("message")
        : request.getParameter("message");

    if (activeTab == null || activeTab.isEmpty()) {
        activeTab = "profile";
    }

    String fullName = "Unknown User";
    String email = "Not set";
    String phone = "Not set";
    String createdAtText = "Unknown";

    if (user != null) {
        String firstName = user.getFirstName() != null ? user.getFirstName() : "";
        String lastName = user.getLastName() != null ? user.getLastName() : "";
        fullName = (firstName + " " + lastName).trim();

        if (fullName.isEmpty()) {
            fullName = "Unknown User";
        }

        if (user.getEmail() != null && !user.getEmail().isEmpty()) {
            email = user.getEmail();
        }

        if (user.getPhoneNumber() != null && !user.getPhoneNumber().isEmpty()) {
            phone = user.getPhoneNumber();
        }

        if (user.getCreatedAt() != null) {
            SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM d, yyyy");
            createdAtText = dateFormat.format(user.getCreatedAt());
        }
    }

    SimpleDateFormat dateTimeFormat = new SimpleDateFormat("MMM d, yyyy 'at' h:mm a");

    int listingCount = listings != null ? listings.size() : 0;
    int pendingCount = pendingRequests != null ? pendingRequests.size() : 0;
    int processedCount = processedRequests != null ? processedRequests.size() : 0;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Account Settings - Lendr</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= contextPath %>/css/styles.css">
    <link rel="stylesheet" href="<%= contextPath %>/css/settings.css">
</head>
<body>
	<div class="navbar">
	    <a href="<%= contextPath %>/BrowseServlet" class="logo">Lendr</a>
	</div>
    <div class="settings-shell">
        <div class="settings-container">
            <div class="settings-header">
                <h1>Account Settings</h1>
                <p>Manage your profile, listings, and rental requests.</p>
            </div>

            <% if (successMessage != null && !successMessage.isEmpty()) { %>
                <div class="alert alert-success" style="display:block; margin-bottom: 16px;">
                    <%= successMessage %>
                </div>
            <% } %>

            <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
                <div class="alert alert-danger" style="display:block; margin-bottom: 16px;">
                    <%= errorMessage %>
                </div>
            <% } %>

            <div class="tabs">
                <button class="tab-btn <%= "profile".equals(activeTab) ? "active" : "" %>" type="button"
                        data-href="<%= contextPath %>/SettingsServlet?action=profile">
                    Profile Settings
                </button>
                <button class="tab-btn <%= "listings".equals(activeTab) ? "active" : "" %>" type="button"
                        data-href="<%= contextPath %>/SettingsServlet?action=listings">
                    My Listings
                </button>
                <button class="tab-btn <%= "requests".equals(activeTab) ? "active" : "" %>" type="button"
                        data-href="<%= contextPath %>/SettingsServlet?action=requests">
                    Rental Requests
                </button>
            </div>

            <div id="profile" class="tab-content <%= "profile".equals(activeTab) ? "active" : "" %>">
                <div class="profile-info">
                    <div class="profile-info-row">
                        <span class="profile-info-label">Name:</span>
                        <span class="profile-info-value"><%= fullName %></span>
                    </div>
                    <div class="profile-info-row">
                        <span class="profile-info-label">Email:</span>
                        <span class="profile-info-value"><%= email %></span>
                    </div>
                    <div class="profile-info-row">
                        <span class="profile-info-label">Phone:</span>
                        <span class="profile-info-value"><%= phone %></span>
                    </div>
                    <div class="profile-info-row">
                        <span class="profile-info-label">Identity Verification:</span>
                        <span class="profile-info-value">
                            <span class="status-badge <%= "Verified".equals(verificationStatus) ? "status-confirmed" : "status-pending" %>">
                                <%= verificationStatus != null ? verificationStatus : "Unknown" %>
                            </span>
                        </span>
                    </div>
                    <div class="profile-info-row">
                        <span class="profile-info-label">Payment Method on File:</span>
                        <span class="profile-info-value"><%= paymentMethod != null && !paymentMethod.isEmpty() ? paymentMethod : "Not Set" %></span>
                    </div>
                    <div class="profile-info-row">
                        <span class="profile-info-label">Account Created:</span>
                        <span class="profile-info-value"><%= createdAtText %></span>
                    </div>
                </div>

                <h3>Change Password</h3>
                <form action="<%= contextPath %>/SettingsServlet" method="post">
                    <input type="hidden" name="action" value="changePassword">

                    <div class="form-group">
                        <label for="currentPassword">Current Password</label>
                        <input type="password" id="currentPassword" name="currentPassword" placeholder="Current password">
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="newPassword">New Password</label>
                            <input type="password" id="newPassword" name="newPassword" placeholder="New password">
                        </div>
                        <div class="form-group">
                            <label for="confirmPassword">Confirm Password</label>
                            <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm new password">
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">Update Password</button>
                    </div>
                </form>

                <hr style="margin: 40px 0; border: none; border-top: 1px solid #e0e0e0;">

                <h3>Delete Account</h3>
                <div class="confirmation-alert">
                    <p><strong>Warning:</strong> This action cannot be undone.</p>
                    <p>Deleting your account will permanently remove all your data from the system, including your listings and booking history.</p>
                </div>

                <form action="<%= contextPath %>/SettingsServlet" method="post" onsubmit="return confirmDeleteAccount();">
                    <input type="hidden" name="action" value="deleteAccount">
                    <input type="hidden" name="confirmDelete" value="yes">

                    <div class="form-actions">
                        <button type="submit" class="btn btn-danger">Delete My Account</button>
                    </div>
                </form>
            </div>

            <div id="listings" class="tab-content <%= "listings".equals(activeTab) ? "active" : "" %>">
                <h3>Your Listings</h3>

                <% if (listings != null && !listings.isEmpty()) { %>
                    <p style="margin-bottom: 20px;">You currently have <strong><%= listingCount %></strong> listing(s).</p>

                    <% for (Listing listing : listings) {
                        String listingTitle = listing.getTitle() != null ? listing.getTitle() : "Untitled Listing";
                        String listingDescription = listing.getDescription() != null ? listing.getDescription() : "No description provided.";
                        String listingLocation = listing.getLocation() != null ? listing.getLocation() : "Location not specified";
                        String listingCategory = listing.getCategoryName() != null ? listing.getCategoryName() : "Uncategorized";
                    %>
                        <div class="listing-card">
                            <h4><%= listingTitle %></h4>
                            <div class="listing-meta">
                                <p>Category: <%= listingCategory %></p>
                                <p>Price: $<%= String.format("%.2f", listing.getPrice()) %> / <%= listing.getPricingUnit() != null && !listing.getPricingUnit().isEmpty() ? listing.getPricingUnit() : "day" %></p>
                                <p>Location: <%= listingLocation %></p>
                                <p>Status:
                                    <span class="status-badge <%= listing.isAvailability() ? "status-confirmed" : "status-denied" %>">
                                        <%= listing.isAvailability() ? "Available" : "Unavailable" %>
                                    </span>
                                </p>
                            </div>
                            <p><%= listingDescription.length() > 160 ? listingDescription.substring(0, 160) + "..." : listingDescription %></p>
                            <div class="listing-actions">
                                <a class="btn btn-primary" href="<%= contextPath %>/ListingDetailServlet?listingId=<%= listing.getListingId() %>">View Listing</a>
                                <a class="btn btn-secondary" href="<%= contextPath %>/EditListingServlet?listingId=<%= listing.getListingId() %>">Edit Listing</a>
                            </div>
                        </div>
                    <% } %>
                <% } else { %>
                    <div class="empty-state">
                        <div class="empty-state-icon">📦</div>
                        <h4>No Listings Yet</h4>
                        <p>Your listings will show up here once you add them.</p>
                        <a class="btn btn-primary" href="<%= contextPath %>/CreateListingServlet">Create Listing</a>
                    </div>
                <% } %>
            </div>

            <div id="requests" class="tab-content <%= "requests".equals(activeTab) ? "active" : "" %>">
                <h3>Rental Requests</h3>

                <div style="margin-bottom: 20px;">
                    <p><strong>Pending Requests:</strong> <%= pendingCount %></p>
                    <p><strong>Processed Requests:</strong> <%= processedCount %></p>
                </div>

                <h3>Pending Rental Requests</h3>
                <% if (pendingRequests != null && !pendingRequests.isEmpty()) { %>
                    <% for (Booking booking : pendingRequests) { %>
                        <div class="booking-card">
                            <h4><%= booking.getListingTitle() != null ? booking.getListingTitle() : "Listing" %></h4>
                            <div class="booking-meta">
                                <p>Renter: <%= booking.getRenterName() != null ? booking.getRenterName() : "Unknown renter" %></p>
                                <p>Dates:
                                    <%= booking.getStartTime() != null ? dateTimeFormat.format(booking.getStartTime()) : "N/A" %>
                                    to
                                    <%= booking.getEndTime() != null ? dateTimeFormat.format(booking.getEndTime()) : "N/A" %>
                                </p>
                                <p>Payment Method: <%= booking.getPaymentMethod() != null ? booking.getPaymentMethod() : "Not provided" %></p>
                                <p>Rate: $<%= String.format("%.2f", booking.getRentPrice()) %></p>
                                <p>Status: <span class="status-badge status-pending">Pending</span></p>
                            </div>
                            <div class="booking-actions">
                                <form action="<%= contextPath %>/SettingsServlet" method="post">
                                    <input type="hidden" name="action" value="acceptRequest">
                                    <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>">
                                    <button type="submit" class="btn btn-success">Accept Request</button>
                                </form>
                                <form action="<%= contextPath %>/SettingsServlet" method="post">
                                    <input type="hidden" name="action" value="denyRequest">
                                    <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>">
                                    <button type="submit" class="btn btn-danger">Deny Request</button>
                                </form>
                            </div>
                        </div>
                    <% } %>
                <% } else { %>
                    <div class="empty-state">
                        <div class="empty-state-icon">📭</div>
                        <h4>No Pending Rental Requests</h4>
                        <p>When someone books one of your items, you will be able to accept or deny the request here.</p>
                    </div>
                <% } %>

                <h3 style="margin-top:32px;">Processed Requests</h3>
                <% if (processedRequests != null && !processedRequests.isEmpty()) { %>
                    <% for (Booking booking : processedRequests) { %>
                        <div class="booking-card">
                            <h4><%= booking.getListingTitle() != null ? booking.getListingTitle() : "Listing" %></h4>
                            <div class="booking-meta">
                                <p>Renter: <%= booking.getRenterName() != null ? booking.getRenterName() : "Unknown renter" %></p>
                                <p>Dates:
                                    <%= booking.getStartTime() != null ? dateTimeFormat.format(booking.getStartTime()) : "N/A" %>
                                    to
                                    <%= booking.getEndTime() != null ? dateTimeFormat.format(booking.getEndTime()) : "N/A" %>
                                </p>
                                <p>Payment Method: <%= booking.getPaymentMethod() != null ? booking.getPaymentMethod() : "Not provided" %></p>
                                <p>Rate: $<%= String.format("%.2f", booking.getRentPrice()) %></p>
                                <p>Status:
                                    <span class="status-badge <%= statusClass(booking.getStatus()) %>">
                                        <%= booking.getStatus() != null ? booking.getStatus() : "Unknown" %>
                                    </span>
                                </p>
                            </div>
                        </div>
                    <% } %>
                <% } else { %>
                    <div class="empty-state">
                        <div class="empty-state-icon">🧾</div>
                        <h4>No Processed Requests Yet</h4>
                        <p>Accepted, denied, completed, and cancelled requests will appear here.</p>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const tabButtons = document.querySelectorAll('.tab-btn');

            tabButtons.forEach(function (button) {
                button.addEventListener('click', function () {
                    const href = button.getAttribute('data-href');
                    if (href) {
                        window.location.href = href;
                    }
                });
            });
        });

        function confirmDeleteAccount() {
            return confirm('Are you sure you want to permanently delete your account? This action cannot be undone.');
        }
    </script>
</body>
</html>

<%!
    private String statusClass(String status) {
        if (status == null) {
            return "status-pending";
        }
        if ("confirmed".equalsIgnoreCase(status)) {
            return "status-confirmed";
        }
        if ("denied".equalsIgnoreCase(status) || "cancelled".equalsIgnoreCase(status)) {
            return "status-denied";
        }
        if ("completed".equalsIgnoreCase(status)) {
            return "status-completed";
        }
        return "status-pending";
    }
%>