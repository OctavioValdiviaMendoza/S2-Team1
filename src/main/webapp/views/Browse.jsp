<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Listing" %>
<%@ page import="model.Category" %>
<%
    String contextPath = request.getContextPath();
    String selectedCategoryId = request.getParameter("categoryId");
    String searchTerm = request.getParameter("search");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    List<Listing> listings = (List<Listing>) request.getAttribute("listings");
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
            <button class="nav-btn login-btn">Login</button>
            <button class="nav-btn signup-btn">Sign Up</button>
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
                    <option value="<%= category.getCategoryId() %>" <%= String.valueOf(category.getCategoryId()).equals(selectedCategoryId) ? "selected" : "" %>><%= category.getCategoryName() %></option>
                    <%  }
                       }
                    %>
                </select>
            </div>

            <div class="filter-group">
                <label for="price-range">Price Range</label>
                <input type="range" id="price-range" min="0" max="500" step="10">
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

            <button class="filter-btn">Apply Filters</button>
            <button class="filter-btn clear-btn">Clear All</button>
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
                        <button class="view-btn" onclick="viewListingDetails(<%= listing.getListingId() %>)">View Details</button>
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

    <!-- FOOTER -->
    <footer class="footer">
        <p>&copy; 2024 Lendr. All rights reserved.</p>
    </footer>

    <script>
        // Price range slider
        const priceRange = document.getElementById('price-range');
        const priceDisplay = document.querySelector('.price-display');
        priceRange.addEventListener('input', function() {
        		priceDisplay.textContent = '$0 - $' + this.value;
        });

        // Navigation buttons
        document.querySelector('.login-btn').addEventListener('click', function() {
            window.location.href = '<%= contextPath %>/views/Login.jsp';
        });
        document.querySelector('.signup-btn').addEventListener('click', function() {
            window.location.href = '<%= contextPath %>/views/SignUp.jsp';
        });

        // Search functionality
        document.querySelector('.search-btn').addEventListener('click', function() {
            const searchTerm = document.querySelector('.search-bar input').value;
            if (searchTerm) {
                window.location.href = '<%= contextPath %>/BrowseServlet?search=' + encodeURIComponent(searchTerm);
            } else {
                window.location.href = '<%= contextPath %>/BrowseServlet';
            }
        });

        // Filter apply
        document.querySelector('.filter-btn').addEventListener('click', function() {
            const categoryId = document.getElementById('category').value;
            if (categoryId) {
                window.location.href = '<%= contextPath %>/BrowseServlet?categoryId=' + encodeURIComponent(categoryId);
            } else {
                window.location.href = '<%= contextPath %>/BrowseServlet';
            }
        });

        // Clear filters
        document.querySelector('.clear-btn').addEventListener('click', function() {
            document.getElementById('category').value = '';
            document.getElementById('condition').value = '';
            document.getElementById('location').value = '';
            document.getElementById('price-range').value = '500';
            priceDisplay.textContent = '$0 - $500';
            window.location.href = '<%= contextPath %>/BrowseServlet';
        });

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
