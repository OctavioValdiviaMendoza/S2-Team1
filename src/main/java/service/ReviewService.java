package service;

import java.util.List;

import dao.ReviewDAO;
import model.Listing;
import model.Review;

public class ReviewService {
    private final ReviewDAO reviewDAO;
    private final ListingService listingService;

    public ReviewService() {
        this.reviewDAO = new ReviewDAO();
        this.listingService = new ListingService();
    }

    public List<Review> getReviewsByListingId(int listingId) {
        return reviewDAO.getReviewsByListingId(listingId);
    }

    public double getAverageRatingByListingId(int listingId) {
        return reviewDAO.getAverageRatingByListingId(listingId);
    }

    public boolean canUserReviewListing(int listingId, int userId) {
        Listing listing = listingService.getListingById(listingId);
        if (listing == null || listing.getUserId() == userId) {
            return false;
        }

        return reviewDAO.hasCompletedRental(listingId, userId)
                && !reviewDAO.hasUserReviewedListing(listingId, userId);
    }

    public boolean hasUserReviewedListing(int listingId, int userId) {
        return reviewDAO.hasUserReviewedListing(listingId, userId);
    }

    public boolean createReview(int listingId, int userId, double rating, String comment) {
        if (rating < 1.0 || rating > 5.0) {
            return false;
        }

        if (comment == null || comment.trim().isEmpty()) {
            return false;
        }

        if (!canUserReviewListing(listingId, userId)) {
            return false;
        }

        Review review = new Review(listingId, userId, rating, comment.trim());
        return reviewDAO.createReview(review);
    }
}
