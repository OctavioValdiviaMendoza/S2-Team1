package servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Address;
import model.Listing;
import model.Review;
import service.AddressService;
import service.ListingService;
import service.ReviewService;

@WebServlet("/ListingDetailServlet")
public class ListingDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final ListingService listingService = new ListingService();
    private final AddressService addressService = new AddressService();
    private final ReviewService reviewService = new ReviewService();

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
            List<Review> reviews = reviewService.getReviewsByListingId(listingId);

            Integer currentUserId = null;
            if (request.getSession(false) != null
                    && request.getSession(false).getAttribute("userId") != null) {
                currentUserId = (Integer) request.getSession(false).getAttribute("userId");
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

            request.setAttribute("pickupAddress", pickupAddress);
            request.setAttribute("googleMapsApiKey", googleMapsApiKey);

            request.setAttribute("reviews", reviews);
            request.setAttribute("reviewCount", reviews.size());
            request.setAttribute("averageRating", reviewService.getAverageRatingByListingId(listingId));
            request.setAttribute("canReview", canReview);
            request.setAttribute("hasReviewed", hasReviewed);

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