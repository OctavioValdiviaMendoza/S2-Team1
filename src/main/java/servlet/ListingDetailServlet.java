package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Listing;
import service.ListingService;

@WebServlet("/ListingDetailServlet")
public class ListingDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private ListingService listingService = new ListingService();

    public ListingDetailServlet() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String listingIdParam = request.getParameter("listingId");

        if (listingIdParam == null || listingIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/BrowseServlet?error=missingListingId");
            return;
        }

        try {
            int listingId = Integer.parseInt(listingIdParam);
            Listing listing = listingService.getListingById(listingId);

            if (listing == null) {
                response.sendRedirect(request.getContextPath() + "/BrowseServlet?error=listingNotFound");
                return;
            }

            
            request.setAttribute("listing", listing);
            request.setAttribute("imageUrls", listingService.getImageUrlsByListingId(listingId));
            request.getRequestDispatcher("/views/ListingDetail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/BrowseServlet?error=invalidListingId");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Unable to load listing details.");
            request.getRequestDispatcher("/views/Browse.jsp").forward(request, response);
        }
    }
}