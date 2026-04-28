<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Listing" %>
<%
    Listing listing = (Listing) request.getAttribute("listing");
    if (listing == null) {
        response.sendRedirect(request.getContextPath() + "/BrowseServlet");
        return;
    }
    Integer currentUserId = (Integer) session.getAttribute("userId");
    boolean ownerViewing = currentUserId != null && currentUserId.intValue() == listing.getUserId();
    String pageMessage = request.getParameter("message");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= listing.getTitle() %> - Listing Details</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/listing-detail.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>

    <nav class="navbar">
        <a class="logo" href="<%= request.getContextPath() %>/BrowseServlet">Lendr</a>
        <div class="nav-links">
            <a href="<%= request.getContextPath() %>/BrowseServlet">Browse</a>
            <a href="<%= request.getContextPath() %>/SettingsServlet">Settings</a>
        </div>
    </nav>

    <main class="detail-shell">
        <div class="detail-card">
            <% if (pageMessage != null && !pageMessage.trim().isEmpty()) { %>
                <div style="margin-bottom: 20px; padding: 14px 18px; border-radius: 12px; background: #dcfce7; color: #166534; font-weight: 500;">
                    <%= pageMessage %>
                </div>
            <% } %>

            <div class="detail-top">
                <div class="detail-image-section">
                    <div class="main-image">
                        <%
                            String imageUrl = listing.getImageUrl();
                            if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                                String imageSrc = (imageUrl.startsWith("http://") || imageUrl.startsWith("https://"))
                                        ? imageUrl
                                        : request.getContextPath() + "/images/" + imageUrl;
                        %>
                            <img src="<%= imageSrc %>" alt="<%= listing.getTitle() %>">
                        <%
                            } else {
                        %>
                            <div class="image-placeholder">No Image Available</div>
                        <%
                            }
                        %>
                    </div>

                    <div class="gallery-placeholder">
                        <h3>Image Gallery</h3>
                        <p>Placeholder for future scrolling images / thumbnails.</p>
                    </div>
                </div>

                <div class="detail-info-section">
                    <span class="category-badge">
                        <%= listing.getCategoryName() != null ? listing.getCategoryName() : "Uncategorized" %>
                    </span>

                    <h1><%= listing.getTitle() %></h1>

                    <p class="price">$<%= String.format("%.2f", listing.getPrice()) %> / <%= listing.getPricingUnit() != null && !listing.getPricingUnit().isEmpty() ? listing.getPricingUnit() : "day" %></p>

                    <p class="availability">
                        Status:
                        <strong>
                            <%= listing.isAvailability() ? "Available" : "Unavailable" %>
                        </strong>
                    </p>

                    <p class="location">
                        Location:
                        <strong>
                            <%= listing.getLocation() != null ? listing.getLocation() : "Location not available" %>
                        </strong>
                    </p>

                    <div class="action-group">
                        <% if (ownerViewing) { %>
                            <a class="btn btn-primary"
                               href="<%= request.getContextPath() %>/EditListingServlet?listingId=<%= listing.getListingId() %>">
                                Edit Listing
                            </a>
                        <% } else { %>
                            <a class="btn btn-primary"
                               href="<%= request.getContextPath() %>/CheckoutServlet?listingId=<%= listing.getListingId() %>">
                                Book Now
                            </a>
                        <% } %>

                        <a class="btn btn-secondary"
                           href="<%= request.getContextPath() %>/BrowseServlet">
                            Back to Browse
                        </a>
                    </div>
                </div>
            </div>

            <section class="detail-section">
                <h2>Description</h2>
                <p>
                    <%= listing.getDescription() != null ? listing.getDescription() : "No description provided." %>
                </p>
            </section>

            <section class="detail-section">
                <h2>Rental Preferences</h2>
                <p><strong>Accepted payments:</strong> <%= listing.getAcceptedPaymentMethods() != null && !listing.getAcceptedPaymentMethods().isEmpty() ? listing.getAcceptedPaymentMethods() : "Not specified" %></p>
                <p><strong>Contact method:</strong> <%= listing.getContactMethod() != null && !listing.getContactMethod().isEmpty() ? listing.getContactMethod() : "Not specified" %></p>
                <p><strong>Contact info:</strong> <%= listing.getContactInfo() != null && !listing.getContactInfo().isEmpty() ? listing.getContactInfo() : "Not specified" %></p>
                <p><strong>Pickup / drop-off:</strong> <%= listing.getFulfillmentMethod() != null && !listing.getFulfillmentMethod().isEmpty() ? listing.getFulfillmentMethod() : "Not specified" %></p>
            </section>

            <section class="detail-section">
                <h2>Map</h2>
                <div class="map-placeholder">
                    Future Google Maps API integration goes here.
                </div>
            </section>

            <section class="detail-section">
                <h2>Owner Contact</h2>
                <div class="info-placeholder">
                    Reach out by <strong><%= listing.getContactMethod() != null && !listing.getContactMethod().isEmpty() ? listing.getContactMethod() : "the listed contact method" %></strong>
                    at <strong><%= listing.getContactInfo() != null && !listing.getContactInfo().isEmpty() ? listing.getContactInfo() : "the contact details above" %></strong>.
                </div>
            </section>

            <section class="detail-section">
                <h2>Related Listings</h2>
                <div class="info-placeholder">
                    Placeholder for future related listings.
                </div>
            </section>

        </div>
    </main>

</body>
</html>
