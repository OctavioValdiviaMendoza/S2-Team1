<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Listing" %>
<%@ page import="model.User" %>
<%
    String contextPath = request.getContextPath();

    Listing listing = (Listing) request.getAttribute("listing");
    if (listing == null) {
        response.sendRedirect(contextPath + "/BrowseServlet");
        return;
    }

    User loggedInUser = (User) session.getAttribute("user");
    boolean isLoggedIn = session.getAttribute("userId") != null && loggedInUser != null;
    String firstName = isLoggedIn && loggedInUser.getFirstName() != null && !loggedInUser.getFirstName().trim().isEmpty()
        ? loggedInUser.getFirstName()
        : "User";
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

    <div class="navbar">
	    <a href="<%= contextPath %>/BrowseServlet" class="logo">Lendr</a>
	
	    <div class="nav-center">
	        <div class="search-bar">
	            <input type="text" id="listingSearchInput" placeholder="Search items...">
	            <button class="search-btn" type="button" id="listingSearchBtn">Search</button>
	        </div>
	    </div>
	
	    <div class="nav-buttons">
	        <% if (!isLoggedIn) { %>
	            <button class="nav-btn login-btn" type="button">Login</button>
	            <button class="nav-btn signup-btn" type="button">Sign Up</button>
	        <% } else { %>
	            <div class="profile-menu">
	                <span class="welcome-text">Hi, <%= firstName %></span>
	
	                <button class="profile-trigger" type="button" id="profileMenuButton" aria-haspopup="true" aria-expanded="false">
	                    <span class="profile-avatar">👤</span>
	                </button>
	
	                <div class="profile-dropdown" id="profileDropdown">
	                    <a href="javascript:void(0);" class="dropdown-item">My Listings</a>
	                    <a href="javascript:void(0);" class="dropdown-item">My Rentings</a>
	                    <a href="<%= contextPath %>/SettingsServlet" class="dropdown-item">Account Settings</a>
	                    <a href="<%= contextPath %>/LogoutServlet" class="dropdown-item logout-item">Log Out</a>
	                </div>
	            </div>
	        <% } %>
	    </div>
	</div>

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
    
    <script>
	    const loginBtn = document.querySelector('.login-btn');
	    const signupBtn = document.querySelector('.signup-btn');
	    const searchBtn = document.getElementById('listingSearchBtn');
	    const searchInput = document.getElementById('listingSearchInput');
	
	    if (loginBtn) {
	        loginBtn.addEventListener('click', function() {
	            window.location.href = '<%= contextPath %>/views/Login.jsp';
	        });
	    }
	
	    if (signupBtn) {
	        signupBtn.addEventListener('click', function() {
	            window.location.href = '<%= contextPath %>/views/SignUp.jsp';
	        });
	    }
	
	    if (searchBtn && searchInput) {
	        searchBtn.addEventListener('click', function() {
	            const searchValue = searchInput.value.trim();
	            if (searchValue) {
	                window.location.href = '<%= contextPath %>/BrowseServlet?search=' + encodeURIComponent(searchValue);
	            } else {
	                window.location.href = '<%= contextPath %>/BrowseServlet';
	            }
	        });
	
	        searchInput.addEventListener('keypress', function(e) {
	            if (e.key === 'Enter') {
	                searchBtn.click();
	            }
	        });
	    }
	
	    const profileMenuButton = document.getElementById('profileMenuButton');
	    const profileDropdown = document.getElementById('profileDropdown');
	
	    if (profileMenuButton && profileDropdown) {
	        profileMenuButton.addEventListener('click', function(e) {
	            e.stopPropagation();
	            profileDropdown.classList.toggle('show');
	
	            const isExpanded = profileDropdown.classList.contains('show');
	            profileMenuButton.setAttribute('aria-expanded', isExpanded ? 'true' : 'false');
	        });
	
	        document.addEventListener('click', function(e) {
	            if (!profileDropdown.contains(e.target) && !profileMenuButton.contains(e.target)) {
	                profileDropdown.classList.remove('show');
	                profileMenuButton.setAttribute('aria-expanded', 'false');
	            }
	        });
	    }
	</script>

</body>
</html>