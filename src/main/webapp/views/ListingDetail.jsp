<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Listing" %>
<%
    Listing listing = (Listing) request.getAttribute("listing");
    if (listing == null) {
        response.sendRedirect(request.getContextPath() + "/BrowseServlet");
        return;
    }
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

            <div class="detail-top">
                <div class="detail-image-section">
                    <div class="main-image">
                        <%
                            String imageUrl = listing.getImageUrl();
                            if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                        %>
                            <img src="<%= request.getContextPath() %>/images/<%= imageUrl %>" alt="<%= listing.getTitle() %>">
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

                    <p class="price">$<%= String.format("%.2f", listing.getPrice()) %> / rental</p>

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
                        <a class="btn btn-primary"
						   href="<%= request.getContextPath() %>/CheckoutServlet?listingId=<%= listing.getListingId() %>">
						    Book Now
						</a>

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
                <h2>Map</h2>
                <div class="map-placeholder">
                    Future Google Maps API integration goes here.
                </div>
            </section>

            <section class="detail-section">
                <h2>Owner Contact</h2>
                <div class="info-placeholder">
                    Placeholder for future owner contact info.
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