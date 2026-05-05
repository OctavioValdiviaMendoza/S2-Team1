<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Listing" %>
<%@ page import="model.Category" %>
<%@ page import="model.User" %>
<%
    String contextPath = request.getContextPath();

    String selectedCategoryId = request.getAttribute("selectedCategoryId") != null
        ? (String) request.getAttribute("selectedCategoryId")
        : request.getParameter("categoryId");

    String searchTerm = request.getAttribute("searchTerm") != null
        ? (String) request.getAttribute("searchTerm")
        : request.getParameter("search");

    String selectedMaxPrice = (String) request.getAttribute("selectedMaxPrice");
    String selectedLocation = (String) request.getAttribute("selectedLocation");
    String selectedCondition = (String) request.getAttribute("selectedCondition");
    String viewMode = (String) request.getAttribute("viewMode");

    if (selectedMaxPrice == null) {
        selectedMaxPrice = request.getParameter("maxPrice");
    }
    if (selectedLocation == null) {
        selectedLocation = request.getParameter("location");
    }
    if (selectedCondition == null) {
        selectedCondition = request.getParameter("condition");
    }
    if (viewMode == null) {
        viewMode = request.getParameter("view");
    }
    if (viewMode == null || viewMode.trim().isEmpty()) {
        viewMode = "all";
    }

    List<Category> categories = (List<Category>) request.getAttribute("categories");
    List<Listing> listings = (List<Listing>) request.getAttribute("listings");

	Integer  userId = (Integer) session.getAttribute("userId");
	User loggedInUser = (User) request.getAttribute("currentUser");
	
	boolean isLoggedIn = userId != null && loggedInUser != null;
	
    String firstName = isLoggedIn && loggedInUser.getFirstName() != null && !loggedInUser.getFirstName().trim().isEmpty()
        ? loggedInUser.getFirstName()
        : "User";

    String priceValue = (selectedMaxPrice != null && !selectedMaxPrice.isEmpty()) ? selectedMaxPrice : "500";
    boolean showingMine = "mine".equals(viewMode);
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
                <input type="text" id="navbar-search-input" placeholder="Search items..." value="<%= searchTerm != null ? searchTerm : "" %>">
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
                        <a href="javascript:void(0);" class="dropdown-item" id="myListingsLink">My Listings</a>
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

            <form id="filter-form" action="<%= contextPath %>/BrowseServlet" method="get">
                <input type="hidden" id="search-hidden" name="search" value="<%= searchTerm != null ? searchTerm : "" %>">
                <input type="hidden" id="view-hidden" name="view" value="<%= viewMode %>">

                <div class="filter-group">
                    <label for="category">Category</label>
                    <select id="category" name="categoryId">
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
                    <input type="range" id="price-range" name="maxPrice" min="0" max="500" step="10" value="<%= priceValue %>">
                    <span class="price-display">$0 - $<%= priceValue %></span>
                </div>

                <div class="filter-group">
                    <label for="location">Location</label>
                    <input type="text" id="location" name="location" placeholder="City or zip code" value="<%= selectedLocation != null ? selectedLocation : "" %>">
                </div>

                <div class="filter-group">
                    <label for="condition">Condition</label>
                    <select id="condition" name="condition">
                        <option value="">All Conditions</option>
                        <option value="new" <%= "new".equals(selectedCondition) ? "selected" : "" %>>New</option>
                        <option value="like-new" <%= "like-new".equals(selectedCondition) ? "selected" : "" %>>Like New</option>
                        <option value="good" <%= "good".equals(selectedCondition) ? "selected" : "" %>>Good</option>
                        <option value="fair" <%= "fair".equals(selectedCondition) ? "selected" : "" %>>Fair</option>
                    </select>
                </div>

                <button type="submit" class="filter-btn">Apply Filters</button>
                <button type="button" class="filter-btn clear-btn" id="clearFiltersBtn">Clear All</button>
            </form>
        </aside>

        <!-- MAIN LISTINGS AREA -->
        <main class="listings-area">
            <div class="sort-options">
                <div class="results-copy">
                    <span>Showing <%= request.getAttribute("listingCount") != null ? request.getAttribute("listingCount") : 0 %> results</span>
                    <% if (isLoggedIn) { %>
                        <p><%= showingMine ? "Viewing listings that belong to you." : "Viewing listings from other users." %></p>
                    <% } %>
                </div>

                <div class="browse-actions">
                    <% if (isLoggedIn) { %>
                        <button type="button" class="toggle-btn <%= showingMine ? "secondary-toggle" : "" %>" id="toggle-view-btn">
                            <%= showingMine ? "Show Other Listings" : "Show My Listings" %>
                        </button>

                        <% if (showingMine) { %>
                            <a href="<%= contextPath %>/CreateListingServlet" class="create-listing-link">Create Listing</a>
                        <% } %>
                    <% } %>

                    <select id="sort">
                        <option value="newest">Newest First</option>
                        <option value="price-low">Price: Low to High</option>
                        <option value="price-high">Price: High to Low</option>
                        <option value="relevance">Relevance</option>
                    </select>
                </div>
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
        const contextPath = '<%= contextPath %>';

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
                window.location.href = contextPath + '/views/Login.jsp';
            });
        }

        if (signupBtn) {
            signupBtn.addEventListener('click', function() {
                window.location.href = contextPath + '/views/SignUp.jsp';
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

        // My Listings link in old dropdown
        const myListingsLink = document.getElementById('myListingsLink');
        if (myListingsLink) {
            myListingsLink.addEventListener('click', function() {
                const params = new URLSearchParams(window.location.search);
                params.set('view', 'mine');
                window.location.href = contextPath + '/BrowseServlet?' + params.toString();
            });
        }

        // Search functionality integrated with filter form
        const searchBtn = document.querySelector('.search-btn');
        const searchInput = document.getElementById('navbar-search-input');
        const searchHidden = document.getElementById('search-hidden');
        const filterForm = document.getElementById('filter-form');

        if (searchBtn && searchInput && searchHidden && filterForm) {
            searchBtn.addEventListener('click', function() {
                searchHidden.value = searchInput.value.trim();
                filterForm.submit();
            });

            searchInput.addEventListener('keydown', function(event) {
                if (event.key === 'Enter') {
                    event.preventDefault();
                    searchHidden.value = searchInput.value.trim();
                    filterForm.submit();
                }
            });

            filterForm.addEventListener('submit', function() {
                searchHidden.value = searchInput.value.trim();
            });
        }

        // Clear filters
        const clearFiltersBtn = document.getElementById('clearFiltersBtn');
        if (clearFiltersBtn) {
            clearFiltersBtn.addEventListener('click', function() {
                const viewValue = document.getElementById('view-hidden').value;
                const baseUrl = contextPath + '/BrowseServlet';

                window.location.href = viewValue && viewValue !== 'all'
                    ? baseUrl + '?view=' + encodeURIComponent(viewValue)
                    : baseUrl;
            });
        }

        // Toggle mine / others view
        const toggleViewBtn = document.getElementById('toggle-view-btn');
        if (toggleViewBtn) {
            toggleViewBtn.addEventListener('click', function() {
                const params = new URLSearchParams(window.location.search);
                const nextView = '<%= showingMine ? "others" : "mine" %>';
                params.set('view', nextView);
                window.location.href = contextPath + '/BrowseServlet?' + params.toString();
            });
        }

        // UI-only warning for condition until backend/schema supports it
        const conditionSelect = document.getElementById('condition');
        if (conditionSelect) {
            conditionSelect.addEventListener('change', function() {
                if (this.value) {
                    console.warn('Condition filter is selected in the UI, but the current database schema does not store listing condition yet.');
                }
            });

            if (conditionSelect.value) {
                console.warn('Condition is preserved in the filters, but no server-side condition filtering is possible until a condition column exists in the database.');
            }
        }
    </script>

</body>
</html>