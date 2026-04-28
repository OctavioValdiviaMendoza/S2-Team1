<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Listing" %>
<%@ page import="model.Category" %>
<%
    String contextPath = request.getContextPath();
    String selectedCategoryId = (String) request.getAttribute("selectedCategoryId");
    String searchTerm = (String) request.getAttribute("searchTerm");
    String selectedMaxPrice = (String) request.getAttribute("selectedMaxPrice");
    String selectedLocation = (String) request.getAttribute("selectedLocation");
    String selectedCondition = (String) request.getAttribute("selectedCondition");
    String viewMode = (String) request.getAttribute("viewMode");
    Boolean loggedIn = (Boolean) request.getAttribute("loggedIn");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    List<Listing> listings = (List<Listing>) request.getAttribute("listings");
    String priceValue = (selectedMaxPrice != null && !selectedMaxPrice.isEmpty()) ? selectedMaxPrice : "500";
    boolean isLoggedIn = loggedIn != null && loggedIn.booleanValue();
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
        <a href="<%= contextPath %>/views/JDBCDemo.jsp" class="logo">Lendr</a>
        <div class="nav-center">
            <div class="search-bar">
                <input type="text" placeholder="Search items..." value="<%= searchTerm != null ? searchTerm : "" %>">
                <button class="search-btn">Search</button>
            </div>
        </div>
        <div class="nav-buttons">
            <% if (isLoggedIn) { %>
                <button class="nav-btn login-btn profile-btn">Profile</button>
            <% } else { %>
                <button class="nav-btn login-btn">Login</button>
                <button class="nav-btn signup-btn">Sign Up</button>
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
                <input type="hidden" id="view-hidden" name="view" value="<%= viewMode != null ? viewMode : "all" %>">

                <div class="filter-group">
                    <label for="category">Category</label>
                    <select id="category" name="categoryId">
                        <option value="">All Categories</option>
                        <% if (categories != null) {
                            for (Category category : categories) {
                        %>
                        <option value="<%= category.getCategoryId() %>" <%= String.valueOf(category.getCategoryId()).equals(selectedCategoryId) ? "selected" : "" %>><%= category.getCategoryName() %></option>
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
                <button type="button" class="filter-btn clear-btn">Clear All</button>
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
                            String pricingUnit = listing.getPricingUnit() != null && !listing.getPricingUnit().isEmpty() ? listing.getPricingUnit() : "day";
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
                        <p class="item-price">$<%= listing.getPrice() %>/<%= pricingUnit %></p>
                        <p class="item-location">📍 <%= location %></p>
                        <p class="item-category"><%= categoryName %></p>
                        <p class="item-description"><%= description.length() > 50 ? description.substring(0, 50) + "..." : description %></p>
                        <a href="<%= request.getContextPath() %>/ListingDetailServlet?listingId=<%= listing.getListingId() %>">
						    <button class="view-btn">View Details</button>
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
                <button class="page-btn">Previous</button>
                <button class="page-btn active">1</button>
                <button class="page-btn">2</button>
                <button class="page-btn">3</button>
                <button class="page-btn">Next</button>
            </div>

        </main>

    </div>

    

    <script>
        // Price range slider
        const priceRange = document.getElementById('price-range');
        const priceDisplay = document.querySelector('.price-display');
        priceRange.addEventListener('input', function() {
        		priceDisplay.textContent = '$0 - $' + this.value;
        });

        // Navigation buttons
        const loginBtn = document.querySelector('.login-btn');
        if (loginBtn) {
            loginBtn.addEventListener('click', function() {
                window.location.href = '<%= isLoggedIn ? contextPath + "/SettingsServlet?action=requests" : contextPath + "/views/Login.jsp" %>';
            });
        }

        const signupBtn = document.querySelector('.signup-btn');
        if (signupBtn) {
            signupBtn.addEventListener('click', function() {
                window.location.href = '<%= contextPath %>/views/SignUp.jsp';
            });
        }

        // Search functionality
        document.querySelector('.search-btn').addEventListener('click', function() {
            const searchTerm = document.querySelector('.search-bar input').value;
            document.getElementById('search-hidden').value = searchTerm;
            document.getElementById('filter-form').submit();
        });

        // Clear filters
        document.querySelector('.clear-btn').addEventListener('click', function() {
            const viewValue = document.getElementById('view-hidden').value;
            const baseUrl = '<%= contextPath %>/BrowseServlet';
            window.location.href = viewValue && viewValue !== 'all'
                ? baseUrl + '?view=' + encodeURIComponent(viewValue)
                : baseUrl;
        });

        document.querySelector('.search-bar input').addEventListener('keydown', function(event) {
            if (event.key === 'Enter') {
                event.preventDefault();
                document.getElementById('search-hidden').value = this.value;
                document.getElementById('filter-form').submit();
            }
        });

        document.getElementById('filter-form').addEventListener('submit', function() {
            document.getElementById('search-hidden').value = document.querySelector('.search-bar input').value;
        });

        const toggleViewBtn = document.getElementById('toggle-view-btn');
        if (toggleViewBtn) {
            toggleViewBtn.addEventListener('click', function() {
                const params = new URLSearchParams(window.location.search);
                const nextView = '<%= showingMine ? "others" : "mine" %>';
                params.set('view', nextView);
                window.location.href = '<%= contextPath %>/BrowseServlet?' + params.toString();
            });
        }

        document.getElementById('condition').addEventListener('change', function() {
            if (this.value) {
                console.warn('Condition filter is selected in the UI, but the current database schema does not store listing condition yet.');
            }
        });

        if (document.getElementById('condition').value) {
            console.warn('Condition is preserved in the filters, but no server-side condition filtering is possible until a condition column exists in the database.');
        }

        // View details function
        function viewListingDetails(listingId) {
            window.location.href = '<%= contextPath %>/ListingDetailServlet?listingId=' + listingId;
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
		        session.removeAttribute("successMessage"); // prevent repeat
    }
	%>

</body>
</html>
