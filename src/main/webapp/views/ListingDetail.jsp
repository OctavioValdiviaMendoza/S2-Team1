<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Listing" %>
<%@ page import="model.Review" %>
<%@ page import="model.User" %>
<%@ page import="model.Address" %>
<%
    Listing listing = (Listing) request.getAttribute("listing");
    if (listing == null) {
        response.sendRedirect(request.getContextPath() + "/BrowseServlet");
        return;
    }

    List<String> imageUrls = (List<String>) request.getAttribute("imageUrls");
    List<Review> reviews = (List<Review>) request.getAttribute("reviews");
    Integer reviewCount = (Integer) request.getAttribute("reviewCount");
    Double averageRating = (Double) request.getAttribute("averageRating");
    Boolean canReview = (Boolean) request.getAttribute("canReview");
    Boolean hasReviewed = (Boolean) request.getAttribute("hasReviewed");

    Integer currentUserId = (Integer) session.getAttribute("userId");
    User loggedInUser = (User) request.getAttribute("currentUser");

    Boolean loggedInAttr = (Boolean) request.getAttribute("loggedIn");
    boolean isLoggedIn = Boolean.TRUE.equals(loggedInAttr) && loggedInUser != null;

    String firstName = isLoggedIn && loggedInUser.getFirstName() != null && !loggedInUser.getFirstName().trim().isEmpty()
        ? loggedInUser.getFirstName()
        : "User";

    boolean ownerViewing = currentUserId != null && currentUserId.intValue() == listing.getUserId();
    boolean showReviewForm = Boolean.TRUE.equals(canReview);
    boolean userAlreadyReviewed = Boolean.TRUE.equals(hasReviewed);

    String pageMessage = request.getParameter("message");
    String searchValue = request.getParameter("search");
    if (searchValue == null) {
        searchValue = "";
    }
    
    Address pickupAddress = (Address) request.getAttribute("pickupAddress");

    boolean hasMapLocation = pickupAddress != null
            && pickupAddress.getLatitude() != 0
            && pickupAddress.getLongitude() != 0;

    String directionsUrl = "";
    if (hasMapLocation) {
        directionsUrl = "https://www.google.com/maps/dir/?api=1&destination="
                + pickupAddress.getLatitude()
                + ","
                + pickupAddress.getLongitude();
    }
    
    String googleMapsApiKey = (String) request.getAttribute("googleMapsApiKey");
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
    <style>
        .gallery-strip {
            margin-top: 16px;
            display: flex;
            gap: 12px;
            overflow-x: auto;
            padding-bottom: 6px;
        }

        .gallery-thumb {
            flex: 0 0 auto;
            width: 92px;
            height: 92px;
            border-radius: 12px;
            overflow: hidden;
            border: 1px solid #e5e7eb;
            background: #f8fafc;
        }

        .gallery-thumb img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }

        .gallery-empty {
            margin-top: 12px;
            color: #6b7280;
        }
    </style>
</head>
<body>

    <nav class="navbar">
        <a class="logo" href="<%= request.getContextPath() %>/BrowseServlet">Lendr</a>

        <div class="nav-center">
            <div class="search-bar">
                <input
                    type="text"
                    id="navSearchInput"
                    placeholder="Search listings..."
                    value="<%= searchValue %>">
                <button type="button" class="search-btn" onclick="performSearch()">Search</button>
            </div>
        </div>

        <% if (isLoggedIn) { %>
            <div class="profile-menu">
                <span class="welcome-text">
                    Hi, <%= firstName %>
                </span>

                <button type="button" class="profile-trigger" onclick="toggleProfileDropdown(event)">
                    <span class="profile-avatar">👤</span>
                </button>

                <div id="profileDropdown" class="profile-dropdown">
                    <a href="<%= request.getContextPath() %>/BrowseServlet?view=mine" class="dropdown-item">My Listings</a>
					<a href="<%= request.getContextPath() %>/SettingsServlet?action=rentings" class="dropdown-item">My Rentings</a>
					<a href="<%= request.getContextPath() %>/SettingsServlet" class="dropdown-item">Account Settings</a>
					<a href="<%= request.getContextPath() %>/LogoutServlet" class="dropdown-item logout-item">Log Out</a>
                </div>
            </div>
        <% } else { %>
            <div class="nav-buttons">
                <button type="button" class="nav-btn login-btn" onclick="goToLogin()">Login</button>
                <button type="button" class="nav-btn signup-btn" onclick="goToSignup()">Sign Up</button>
            </div>
        <% } %>
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

                    <div>
                        <h3>Image Gallery</h3>

                        <%
                            if (imageUrls != null && !imageUrls.isEmpty()) {
                        %>
                            <div class="gallery-strip">
                                <%
                                    for (String url : imageUrls) {
                                        if (url != null && !url.trim().isEmpty()) {
                                            String thumbSrc = (url.startsWith("http://") || url.startsWith("https://"))
                                                    ? url
                                                    : request.getContextPath() + "/images/" + url;
                                %>
                                    <div class="gallery-thumb">
                                        <img src="<%= thumbSrc %>" alt="<%= listing.getTitle() %> image">
                                    </div>
                                <%
                                        }
                                    }
                                %>
                            </div>
                        <%
                            } else {
                        %>
                            <p class="gallery-empty">No additional images available.</p>
                        <%
                            }
                        %>
                    </div>
                </div>

                <div class="detail-info-section">
                    <span class="category-badge">
                        <%= listing.getCategoryName() != null && !listing.getCategoryName().trim().isEmpty()
                                ? listing.getCategoryName()
                                : "Uncategorized" %>
                    </span>

                    <h1><%= listing.getTitle() %></h1>

                    <p class="price">
                        $<%= String.format("%.2f", listing.getPrice()) %> /
                        <%= listing.getPricingUnit() != null && !listing.getPricingUnit().trim().isEmpty()
                                ? listing.getPricingUnit()
                                : "day" %>
                    </p>

                    <p class="availability">
                        Status:
                        <strong><%= listing.isAvailability() ? "Available" : "Unavailable" %></strong>
                    </p>

                    <p class="listing-rating-summary">
                        Rating:
                        <strong>
                            <% if (reviewCount != null && reviewCount > 0) { %>
                                <%= String.format("%.1f", averageRating != null ? averageRating : 0.0) %>/5
                                (<%= reviewCount %> <%= reviewCount == 1 ? "review" : "reviews" %>)
                            <% } else { %>
                                No reviews yet
                            <% } %>
                        </strong>
                    </p>

                    <p class="location">
                        Location:
                        <strong>
                            <%= listing.getLocation() != null && !listing.getLocation().trim().isEmpty()
                                    ? listing.getLocation()
                                    : "Location not available" %>
                        </strong>
                    </p>

                    <div class="action-group">
                        <% if (ownerViewing) { %>
                            <a class="btn btn-primary"
                               href="<%= request.getContextPath() %>/EditListingServlet?listingId=<%= listing.getListingId() %>">
                                Edit Listing
                            </a>
                        <% } else if (isLoggedIn && !loggedInUser.isVerifiedStatus()) { %>
                            <a class="btn btn-primary disabled" style="pointer-events: none; opacity: 0.65;">
                                Verify Email to Book
                            </a>
                            <a class="btn btn-secondary"
                               href="<%= request.getContextPath() %>/SettingsServlet?action=profile">
                                Verify Email
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
                    <%= listing.getDescription() != null && !listing.getDescription().trim().isEmpty()
                            ? listing.getDescription()
                            : "No description provided." %>
                </p>
            </section>

            <section class="detail-section reviews-section">
                <div class="reviews-heading">
                    <div>
                        <h2>Reviews</h2>
                        <p class="reviews-summary">
                            <% if (reviewCount != null && reviewCount > 0) { %>
                                Average rating: <strong><%= String.format("%.1f", averageRating != null ? averageRating : 0.0) %>/5</strong>
                            <% } else { %>
                                This listing has not been reviewed yet.
                            <% } %>
                        </p>
                    </div>
                </div>

                <% if (showReviewForm) { %>
                    <form class="review-form" action="<%= request.getContextPath() %>/ReviewServlet" method="post">
                        <input type="hidden" name="listingId" value="<%= listing.getListingId() %>">

                        <div class="review-form-grid">
                            <div class="review-field">
                                <label for="rating">Rating</label>
                                <select id="rating" name="rating" required>
                                    <option value="">Select rating</option>
                                    <option value="5">5 - Excellent</option>
                                    <option value="4">4 - Good</option>
                                    <option value="3">3 - Okay</option>
                                    <option value="2">2 - Poor</option>
                                    <option value="1">1 - Bad</option>
                                </select>
                            </div>
                        </div>

                        <div class="review-field">
                            <label for="comment">Comment</label>
                            <textarea id="comment" name="comment" rows="4" maxlength="1000" required></textarea>
                        </div>

                        <button type="submit" class="btn btn-primary review-submit">Submit Review</button>
                    </form>
                <% } else if (isLoggedIn && userAlreadyReviewed) { %>
                    <div class="review-note">You have already reviewed this listing.</div>
                <% } else if (isLoggedIn && !ownerViewing) { %>
                    <div class="review-note">You can review this listing after you have a completed rental.</div>
                <% } %>

                <div class="review-list">
                    <% if (reviews != null && !reviews.isEmpty()) {
                        for (Review review : reviews) {
                    %>
                        <article class="review-card">
                            <div class="review-card-header">
                                <strong><%= review.getReviewerName() != null ? review.getReviewerName() : "Renter" %></strong>
                                <span><%= String.format("%.1f", review.getRating()) %>/5</span>
                            </div>
                            <p><%= review.getComment() != null ? review.getComment() : "" %></p>
                        </article>
                    <%  }
                       } else {
                    %>
                        <div class="info-placeholder">No renter reviews yet.</div>
                    <% } %>
                </div>
            </section>

            <section class="detail-section">
                <h2>Rental Preferences</h2>
                <p>
                    <strong>Accepted payments:</strong>
                    <%= listing.getAcceptedPaymentMethods() != null && !listing.getAcceptedPaymentMethods().trim().isEmpty()
                            ? listing.getAcceptedPaymentMethods()
                            : "Not specified" %>
                </p>
                <p>
                    <strong>Contact method:</strong>
                    <%= listing.getContactMethod() != null && !listing.getContactMethod().trim().isEmpty()
                            ? listing.getContactMethod()
                            : "Not specified" %>
                </p>
                <p>
                    <strong>Contact info:</strong>
                    <%= listing.getContactInfo() != null && !listing.getContactInfo().trim().isEmpty()
                            ? listing.getContactInfo()
                            : "Not specified" %>
                </p>
                <p>
                    <strong>Pickup / drop-off:</strong>
                    <%= listing.getFulfillmentMethod() != null && !listing.getFulfillmentMethod().trim().isEmpty()
                            ? listing.getFulfillmentMethod()
                            : "Not specified" %>
                </p>
            </section>

            <section class="detail-section">
                <h2>Map</h2>
                <section class="listing-map-section">
    <h2>Pickup Location</h2>

    <% if (pickupAddress != null) { %>
        <p>
            <%= pickupAddress.getLine1() %>
            <%= pickupAddress.getLine2() != null && !pickupAddress.getLine2().trim().isEmpty() ? ", " + pickupAddress.getLine2() : "" %>,
            <%= pickupAddress.getCity() %>, <%= pickupAddress.getState() %> <%= pickupAddress.getZip() %>
        </p>
    <% } %>

    <% if (hasMapLocation) { %>
        <div id="listing-map" style="width: 100%; height: 350px; border-radius: 16px; margin-top: 12px;"></div>

        <a
            href="<%= directionsUrl %>"
            target="_blank"
            rel="noopener noreferrer"
            class="primary-btn"
            style="display: inline-block; margin-top: 12px; text-decoration: none;"
        >
            Get Directions
        </a>
    <% } else { %>
        <p>Map location is not available for this listing yet.</p>
    <% } %>
</section>
            </section>

            <section class="detail-section">
                <h2>Owner Contact</h2>
                <div class="info-placeholder">
                    Reach out by
                    <strong>
                        <%= listing.getContactMethod() != null && !listing.getContactMethod().trim().isEmpty()
                                ? listing.getContactMethod()
                                : "the listed contact method" %>
                    </strong>
                    at
                    <strong>
                        <%= listing.getContactInfo() != null && !listing.getContactInfo().trim().isEmpty()
                                ? listing.getContactInfo()
                                : "the contact details above" %>
                    </strong>.
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

    <script>
        function performSearch() {
            const input = document.getElementById("navSearchInput");
            const query = input ? input.value.trim() : "";

            if (query.length === 0) {
                window.location.href = "<%= request.getContextPath() %>/BrowseServlet";
                return;
            }

            window.location.href =
                "<%= request.getContextPath() %>/BrowseServlet?search=" + encodeURIComponent(query);
        }

        function goToLogin() {
            window.location.href = "<%= request.getContextPath() %>/views/Login.jsp";
        }

        function goToSignup() {
            window.location.href = "<%= request.getContextPath() %>/views/SignUp.jsp";
        }

        function toggleProfileDropdown(event) {
            event.stopPropagation();
            const dropdown = document.getElementById("profileDropdown");
            if (dropdown) {
                dropdown.classList.toggle("show");
            }
        }

        document.addEventListener("click", function(event) {
            const dropdown = document.getElementById("profileDropdown");
            const trigger = document.querySelector(".profile-trigger");

            if (!dropdown || !trigger) return;

            if (!dropdown.contains(event.target) && !trigger.contains(event.target)) {
                dropdown.classList.remove("show");
            }
        });

        document.getElementById("navSearchInput")?.addEventListener("keypress", function(event) {
            if (event.key === "Enter") {
                performSearch();
            }
        });
    </script>
    <% if (hasMapLocation) { %>
<script>
    function initListingMap() {
        const pickupLocation = {
            lat: <%= pickupAddress.getLatitude() %>,
            lng: <%= pickupAddress.getLongitude() %>
        };

        const map = new google.maps.Map(document.getElementById("listing-map"), {
            center: pickupLocation,
            zoom: 15
        });

        const marker = new google.maps.Marker({
            position: pickupLocation,
            map: map,
            title: "Pickup Location"
        });

        marker.addListener("click", function () {
            window.open("<%= directionsUrl %>", "_blank");
        });
    }
</script>

<script async defer
    src="https://maps.googleapis.com/maps/api/js?key=<%= googleMapsApiKey %>&callback=initListingMap">
</script>
<% } %>

</body>
</html>
