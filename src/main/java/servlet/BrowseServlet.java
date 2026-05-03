package servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.annotation.WebServlet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Listing;
import model.Category;
import service.ListingService;
import service.CategoryService;

@WebServlet("/BrowseServlet")
public class BrowseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ListingService listingService = new ListingService();
    private CategoryService categoryService = new CategoryService();

    public BrowseServlet() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Listing> listings = null;
        List<Category> categories = categoryService.getAllCategories();

        // Original parameters
        String page = request.getParameter("page");
        String categoryId = request.getParameter("categoryId");
        String search = request.getParameter("search");

        // New parameters
        String maxPrice = request.getParameter("maxPrice");
        String location = request.getParameter("location");
        String condition = request.getParameter("condition");
        String view = request.getParameter("view");

        // New session/login logic
        HttpSession session = request.getSession(false);
        Integer currentUserId = session != null ? (Integer) session.getAttribute("userId") : null;
        boolean loggedIn = currentUserId != null;
        String viewMode = "all";

        if (loggedIn) {
            viewMode = "mine".equalsIgnoreCase(view) ? "mine" : "others";
        }

        Integer parsedCategoryId = null;
        Double parsedMaxPrice = null;
        boolean invalidCategoryId = false;

        if (categoryId != null && !categoryId.trim().isEmpty()) {
            try {
                parsedCategoryId = Integer.parseInt(categoryId);
            } catch (NumberFormatException e) {
                parsedCategoryId = null;
                invalidCategoryId = true; // preserve original invalid category fallback behavior
            }
        }

        if (maxPrice != null && !maxPrice.trim().isEmpty()) {
            try {
                parsedMaxPrice = Double.parseDouble(maxPrice);
            } catch (NumberFormatException e) {
                parsedMaxPrice = null;
            }
        }

        boolean hasExtendedFilters =
                parsedCategoryId != null ||
                (search != null && !search.trim().isEmpty()) ||
                parsedMaxPrice != null ||
                (location != null && !location.trim().isEmpty());

        // Preserve original behavior first where appropriate
        if (invalidCategoryId) {
            listings = listingService.getAllListings();
        } else if (hasExtendedFilters) {
            listings = listingService.filterListings(parsedCategoryId, search, parsedMaxPrice, location);
        } else {
            // Original uploaded logic
            if (search != null && !search.isEmpty()) {
                listings = listingService.searchListings(search);
            } else if (categoryId != null && !categoryId.isEmpty()) {
                try {
                    int catId = Integer.parseInt(categoryId);
                    listings = listingService.getListingsByCategory(catId);
                } catch (NumberFormatException e) {
                    listings = listingService.getAllListings();
                }
            } else {
                listings = listingService.getAllListings();
            }
        }

        // New owner/view filtering logic
        if (loggedIn && listings != null) {
            List<Listing> filteredByOwner = new ArrayList<>();
            for (Listing listing : listings) {
                boolean belongsToCurrentUser = listing.getUserId() == currentUserId;
                if ("mine".equals(viewMode) && belongsToCurrentUser) {
                    filteredByOwner.add(listing);
                } else if ("others".equals(viewMode) && !belongsToCurrentUser) {
                    filteredByOwner.add(listing);
                }
            }
            listings = filteredByOwner;
        }

        // Preserve original DEBUG line
        System.out.println("DEBUG BrowseServlet listings count = " + (listings != null ? listings.size() : -1));

        // Original attributes
        request.setAttribute("listings", listings);
        request.setAttribute("categories", categories);
        request.setAttribute("listingCount", listings != null ? listings.size() : 0);

        // New attributes
        request.setAttribute("selectedCategoryId", categoryId);
        request.setAttribute("searchTerm", search);
        request.setAttribute("selectedMaxPrice", maxPrice);
        request.setAttribute("selectedLocation", location);
        request.setAttribute("selectedCondition", condition);
        request.setAttribute("viewMode", viewMode);
        request.setAttribute("loggedIn", loggedIn);

        // Preserve original page attribute if your JSP ever uses it
        request.setAttribute("page", page);

        request.getRequestDispatcher("views/Browse.jsp").forward(request, response);
    }
}
