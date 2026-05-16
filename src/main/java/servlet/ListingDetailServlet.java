package servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Address;
import model.Listing;
import model.Review;
import model.User;
import service.UserService;
import service.AddressService;
import service.ListingService;
import service.ReviewService;
import model.ListingPreference;
import service.ListingPreferenceService;

@WebServlet("/ListingDetailServlet")
public class ListingDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final ListingService listingService = new ListingService();
    private final AddressService addressService = new AddressService();
    private final ReviewService reviewService = new ReviewService();
    private UserService userService = new UserService();
    private final ListingPreferenceService listingPreferenceService = new ListingPreferenceService();

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

            List<String> imageUrls = listingService.getImageUrlsByListingId(listingId);
            ListingPreference listingPreference = listingPreferenceService.getListingPreferenceByListingId(listingId);
            List<Review> reviews = reviewService.getReviewsByListingId(listingId);

            HttpSession session = request.getSession(false);
            Integer currentUserId = session != null ? (Integer) session.getAttribute("userId") : null;
            boolean loggedIn = currentUserId != null;
            
            User currentUser = null; 	
            
            if(currentUserId != null) {
            		currentUser = userService.getUserById(currentUserId);
            }

            boolean canReview = false;
            boolean hasReviewed = false;

            if (currentUserId != null) {
                canReview = reviewService.canUserReviewListing(listingId, currentUserId);
                hasReviewed = reviewService.hasUserReviewedListing(listingId, currentUserId);
            }

            Address pickupAddress = null;
            if (listing.getAddressId() > 0) {
                pickupAddress = addressService.getAddressById(listing.getAddressId());
            }

            String googleMapsApiKey = System.getenv("GOOGLE_MAPS_API_KEY");

            request.setAttribute("listing", listing);
            request.setAttribute("imageUrls", imageUrls);
            request.setAttribute("listingPreference", listingPreference);

            request.setAttribute("pickupAddress", pickupAddress);
            request.setAttribute("googleMapsApiKey", googleMapsApiKey);

            request.setAttribute("reviews", reviews);
            request.setAttribute("reviewCount", reviews.size());
            request.setAttribute("averageRating", reviewService.getAverageRatingByListingId(listingId));
            request.setAttribute("canReview", canReview);
            request.setAttribute("hasReviewed", hasReviewed);
            request.setAttribute("currentUser", currentUser);
            request.setAttribute("loggedIn", loggedIn);

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