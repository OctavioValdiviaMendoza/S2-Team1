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

@WebServlet("/BrowseServlet")
public class BrowseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public BrowseServlet() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Listing> listings = null;
        List<Category> categories = ListingService.getAllCategories();
        String categoryId = request.getParameter("categoryId");
        String search = request.getParameter("search");
        String maxPrice = request.getParameter("maxPrice");
        String location = request.getParameter("location");
        String condition = request.getParameter("condition");
        String view = request.getParameter("view");

        HttpSession session = request.getSession(false);
        Integer currentUserId = session != null ? (Integer) session.getAttribute("userId") : null;
        boolean loggedIn = currentUserId != null;
        String viewMode = "all";

        if (loggedIn) {
            viewMode = "mine".equalsIgnoreCase(view) ? "mine" : "others";
        }

        Integer parsedCategoryId = null;
        Double parsedMaxPrice = null;

        if (categoryId != null && !categoryId.trim().isEmpty()) {
            try {
                parsedCategoryId = Integer.parseInt(categoryId);
            } catch (NumberFormatException e) {
                parsedCategoryId = null;
            }
        }

        if (maxPrice != null && !maxPrice.trim().isEmpty()) {
            try {
                parsedMaxPrice = Double.parseDouble(maxPrice);
            } catch (NumberFormatException e) {
                parsedMaxPrice = null;
            }
        }

        boolean hasFilters =
                parsedCategoryId != null ||
                (search != null && !search.trim().isEmpty()) ||
                parsedMaxPrice != null ||
                (location != null && !location.trim().isEmpty());

        if (hasFilters) {
            listings = ListingService.filterListings(parsedCategoryId, search, parsedMaxPrice, location);
        } else {
            listings = ListingService.getAllListings();
        }

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

        request.setAttribute("listings", listings);
        request.setAttribute("categories", categories);
        request.setAttribute("listingCount", listings != null ? listings.size() : 0);
        request.setAttribute("selectedCategoryId", categoryId);
        request.setAttribute("searchTerm", search);
        request.setAttribute("selectedMaxPrice", maxPrice);
        request.setAttribute("selectedLocation", location);
        request.setAttribute("selectedCondition", condition);
        request.setAttribute("viewMode", viewMode);
        request.setAttribute("loggedIn", loggedIn);
        request.getRequestDispatcher("views/Browse.jsp").forward(request, response);
    }
}
