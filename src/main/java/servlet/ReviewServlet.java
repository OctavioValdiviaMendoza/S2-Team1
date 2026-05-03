package servlet;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import service.ReviewService;

@WebServlet("/ReviewServlet")
public class ReviewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final ReviewService reviewService = new ReviewService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/views/Login.jsp");
            return;
        }

        String listingIdParam = request.getParameter("listingId");
        String ratingParam = request.getParameter("rating");
        String comment = request.getParameter("comment");

        try {
            int listingId = Integer.parseInt(listingIdParam);
            int userId = (Integer) session.getAttribute("userId");
            double rating = Double.parseDouble(ratingParam);

            boolean created = reviewService.createReview(listingId, userId, rating, comment);
            if (created) {
                redirectToListing(response, request, listingId, "Review submitted");
            } else {
                redirectToListing(response, request, listingId,
                        "Review could not be submitted. You may need a completed rental first.");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/BrowseServlet?error=invalidReview");
        }
    }

    private void redirectToListing(HttpServletResponse response, HttpServletRequest request, int listingId, String message)
            throws IOException {
        String encodedMessage = URLEncoder.encode(message, StandardCharsets.UTF_8.name());
        response.sendRedirect(request.getContextPath() + "/ListingDetailServlet?listingId=" + listingId + "&message=" + encodedMessage);
    }
}
