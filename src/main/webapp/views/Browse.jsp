<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Listing" %>
<%@ page import="model.Category" %>
<%@ page import="model.User" %>
<%
    String contextPath = request.getContextPath();
    String selectedCategoryId = request.getParameter("categoryId");
    String searchTerm = request.getParameter("search");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    List<Listing> listings = (List<Listing>) request.getAttribute("listings");

    User loggedInUser = (User) session.getAttribute("user");
    boolean isLoggedIn = session.getAttribute("userId") != null && loggedInUser != null;
    String firstName = isLoggedIn && loggedInUser.getFirstName() != null && !loggedInUser.getFirstName().trim().isEmpty()
        ? loggedInUser.getFirstName()
        : "User";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse Items - Lendr</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link
        href="<%= contextPath %>/css/browse.css"
        rel="stylesheet"
        onerror="this.onerror=null;this.href='../css/browse.css';">
</head>
<body>

    <!-- NAVBAR -->
    <div class="navbar">
        <a href="<%= contextPath %>/BrowseServlet" class="logo">Lendr</a>

        <div class="nav-center">
            <div class="search-bar">
                <input type="text" placeholder="Search items..." value="<%= searchTerm != null ? searchTerm : "" %>">
                <button class="search-btn" type="button">Search</button>
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

    <!-- MAIN CONTENT -->
    <div class="browse-container">

        <!-- SIDEBAR FILTERS -->
        <aside class="sidebar">
            <h3>Filters</h3>

            <div class="filter-group">
                <label for="category">Category</label>
                <select id="category">
                    <option value="">All Categories</option>
                    <% if (categories != null) {
                        for (Category category : categories) {
                    %>
                    <option value="<%= category.getCategoryId() %>" <%= String.valueOf(category.getCategoryId()).equals(selectedCategoryId) ? "selected" : "" %>>
                        <%= category.getCategoryName() %>
                    </option>
                    <%  }
                       }
                    %>
                </select>
            </div>

            <div class="filter-group">
                <label for="price-range">Price Range</label>
                <input type="range" id="price-range" min="0" max="500" step="10" value="500">
                <span class="price-display">$0 - $500</span>
            </div>

            <div class="filter-group">
                <label for="location">Location</label>
                <input type="text" id="location" placeholder="City or zip code">
            </div>

            <div class="filter-group">
                <label for="condition">Condition</label>
                <select id="condition">
                    <option value="">All Conditions</option>
                    <option value="new">New</option>
                    <option value="like-new">Like New</option>
                    <option value="good">Good</option>
                    <option value="fair">Fair</option>
                </select>
            </div>

            <button class="filter-btn" id="applyFiltersBtn" type="button">Apply Filters</button>
            <button class="filter-btn clear-btn" id="clearFiltersBtn" type="button">Clear All</button>
        </aside>

        <!-- MAIN LISTINGS AREA -->
        <main class="listings-area">
            <div class="sort-options">
                <span>Showing <%= request.getAttribute("listingCount") != null ? request.getAttribute("listingCount") : 0 %> results</span>
                <select id="sort">
                    <option value="newest">Newest First</option>
                    <option value="price-low">Price: Low to High</option>
                    <option value="price-high">Price: High to Low</option>
                    <option value="relevance">Relevance</option>
                </select>
            </div>

            <!-- LISTINGS GRID -->
            <div class="listings-grid">
                <% if (listings != null && !listings.isEmpty()) {
                        for (Listing listing : listings) {
                            String title = listing.getTitle() != null ? listing.getTitle() : "Untitled Listing";
                            String description = listing.getDescription() != null ? listing.getDescription() : "No description available.";
                            String location = listing.getLocation() != null ? listing.getLocation() : "Location not specified";
                            String categoryName = listing.getCategoryName() != null ? listing.getCategoryName() : "Uncategorized";
                            String imageUrl = listing.getImageUrl();
                            String imageSrc = (imageUrl != null && (imageUrl.startsWith("http://") || imageUrl.startsWith("https://")))
                                ? imageUrl
                                : "https://via.placeholder.com/250x250?text=" + title.replaceAll(" ", "+");
                %>

                <!-- LISTING CARD -->
                <div class="item-card">
                    <div class="item-image">
                        <img src="<%= imageSrc %>" alt="<%= title %>">
                        <span class="item-badge"><%= listing.isAvailability() ? "Available" : "Unavailable" %></span>
                    </div>
                    <div class="item-info">
                        <h3 class="item-title"><%= title %></h3>
                        <p class="item-price">$<%= listing.getPrice() %>/day</p>
                        <p class="item-location">📍 <%= location %></p>
                        <p class="item-category"><%= categoryName %></p>
                        <p class="item-description"><%= description.length() > 50 ? description.substring(0, 50) + "..." : description %></p>
                        <a class="view-btn" href="<%= contextPath %>/ListingDetailServlet?listingId=<%= listing.getListingId() %>">
                            View Details
                        </a>
                    </div>
                </div>

                <%
                        }
                    } else {
                %>
                <div style="grid-column: 1 / -1; text-align: center; padding: 40px;">
                    <p>No listings found. Try adjusting your filters.</p>
                </div>
                <%
                    }
                %>
            </div>

            <!-- PAGINATION -->
            <div class="pagination">
                <button class="page-btn" type="button">Previous</button>
                <button class="page-btn active" type="button">1</button>
                <button class="page-btn" type="button">2</button>
                <button class="page-btn" type="button">3</button>
                <button class="page-btn" type="button">Next</button>
            </div>
        </main>
    </div>

    <!-- FOOTER -->
    <footer class="footer">
        <p>&copy; 2026 Lendr. All rights reserved.</p>
    </footer>

    <script>
        // Price range slider
        const priceRange = document.getElementById('price-range');
        const priceDisplay = document.querySelector('.price-display');

        if (priceRange && priceDisplay) {
            priceRange.addEventListener('input', function() {
                priceDisplay.textContent = '$0 - $' + this.value;
            });
        }

        // Navigation buttons
        const loginBtn = document.querySelector('.login-btn');
        const signupBtn = document.querySelector('.signup-btn');

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

        // Profile dropdown
        const profileMenuButton = document.getElementById('profileMenuButton');
        const profileDropdown = document.getElementById('profileDropdown');

        if (profileMenuButton && profileDropdown) {
            profileMenuButton.addEventListener('click', function(event) {
                event.stopPropagation();
                profileDropdown.classList.toggle('show');

                const expanded = profileDropdown.classList.contains('show');
                profileMenuButton.setAttribute('aria-expanded', expanded);
            });

            document.addEventListener('click', function(event) {
                if (!event.target.closest('.profile-menu')) {
                    profileDropdown.classList.remove('show');
                    profileMenuButton.setAttribute('aria-expanded', 'false');
                }
            });
        }

        // Search functionality
        const searchBtn = document.querySelector('.search-btn');
        const searchInput = document.querySelector('.search-bar input');

        if (searchBtn && searchInput) {
            searchBtn.addEventListener('click', function() {
                const term = searchInput.value.trim();
                if (term) {
                    window.location.href = '<%= contextPath %>/BrowseServlet?search=' + encodeURIComponent(term);
                } else {
                    window.location.href = '<%= contextPath %>/BrowseServlet';
                }
            });

            searchInput.addEventListener('keypress', function(event) {
                if (event.key === 'Enter') {
                    searchBtn.click();
                }
            });
        }

        // Apply filters
        const applyFiltersBtn = document.getElementById('applyFiltersBtn');
        if (applyFiltersBtn) {
            applyFiltersBtn.addEventListener('click', function() {
                const categoryId = document.getElementById('category').value;
                if (categoryId) {
                    window.location.href = '<%= contextPath %>/BrowseServlet?categoryId=' + encodeURIComponent(categoryId);
                } else {
                    window.location.href = '<%= contextPath %>/BrowseServlet';
                }
            });
        }

        // Clear filters
        const clearFiltersBtn = document.getElementById('clearFiltersBtn');
        if (clearFiltersBtn) {
            clearFiltersBtn.addEventListener('click', function() {
                document.getElementById('category').value = '';
                document.getElementById('condition').value = '';
                document.getElementById('location').value = '';
                document.getElementById('price-range').value = '500';
                priceDisplay.textContent = '$0 - $500';
                window.location.href = '<%= contextPath %>/BrowseServlet';
            });
        }
    </script>

    <%
        String successMessage = (String) session.getAttribute("successMessage");
        if (successMessage != null) {
    %>
        <script>
            alert("<%= successMessage %>");
        </script>
    <%
            session.removeAttribute("successMessage");
        }
    %>

</body>
</html>