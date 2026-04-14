package servlet;

import java.io.IOException;
import java.util.List;
import javax.servlet.annotation.WebServlet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
        String page = request.getParameter("page");
        String categoryId = request.getParameter("categoryId");
        String search = request.getParameter("search");

        // Fetch listings based on filter
        if (search != null && !search.isEmpty()) {
            listings = ListingService.searchListings(search);
        } else if (categoryId != null && !categoryId.isEmpty()) {
            try {
                int catId = Integer.parseInt(categoryId);
                listings = ListingService.getListingsByCategory(catId);
            } catch (NumberFormatException e) {
                listings = ListingService.getAllListings();
            }
        } else {
            listings = ListingService.getAllListings();
        }

        System.out.println("DEBUG BrowseServlet listings count = " + (listings != null ? listings.size() : -1));

        request.setAttribute("listings", listings);
        request.setAttribute("categories", categories);
        request.setAttribute("listingCount", listings != null ? listings.size() : 0);
        request.getRequestDispatcher("views/Browse.jsp").forward(request, response);
    }
}
