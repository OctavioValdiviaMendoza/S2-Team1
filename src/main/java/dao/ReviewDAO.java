package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import model.Review;
import util.DBConnection;

public class ReviewDAO {

    public ReviewDAO() {
        ensureReviewsTable();
    }

    public List<Review> getReviewsByListingId(int listingId) {
        List<Review> reviews = new ArrayList<>();
        String sql =
                "SELECT r.review_id, r.listing_id, r.user_id, r.rating, r.comment, " +
                "COALESCE(NULLIF(TRIM(CONCAT(u.first_name, ' ', u.last_name)), ''), u.email, 'Renter') AS reviewer_name " +
                "FROM reviews r " +
                "LEFT JOIN users u ON r.user_id = u.user_id " +
                "WHERE r.listing_id = ? " +
                "ORDER BY r.review_id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, listingId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    reviews.add(mapReview(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return reviews;
    }

    public boolean createReview(Review review) {
        String sql = "INSERT INTO reviews (listing_id, user_id, rating, comment) VALUES (?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, review.getListingId());
            ps.setInt(2, review.getUserId());
            ps.setDouble(3, review.getRating());
            ps.setString(4, review.getComment());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean hasCompletedRental(int listingId, int userId) {
        String sql =
                "SELECT booking_id FROM bookings " +
                "WHERE listing_id = ? AND user_id = ? AND LOWER(status) = 'completed' " +
                "LIMIT 1";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, listingId);
            ps.setInt(2, userId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean hasUserReviewedListing(int listingId, int userId) {
        String sql = "SELECT review_id FROM reviews WHERE listing_id = ? AND user_id = ? LIMIT 1";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, listingId);
            ps.setInt(2, userId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public double getAverageRatingByListingId(int listingId) {
        String sql = "SELECT AVG(rating) AS average_rating FROM reviews WHERE listing_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, listingId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("average_rating");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0.0;
    }

    private Review mapReview(ResultSet rs) throws SQLException {
        Review review = new Review();
        review.setReviewId(rs.getInt("review_id"));
        review.setListingId(rs.getInt("listing_id"));
        review.setUserId(rs.getInt("user_id"));
        review.setRating(rs.getDouble("rating"));
        review.setComment(rs.getString("comment"));
        review.setReviewerName(rs.getString("reviewer_name"));
        return review;
    }

    private void ensureReviewsTable() {
        String sql =
                "CREATE TABLE IF NOT EXISTS reviews (" +
                "review_id INT NOT NULL AUTO_INCREMENT, " +
                "listing_id INT DEFAULT NULL, " +
                "user_id INT DEFAULT NULL, " +
                "rating DECIMAL(2,1) DEFAULT NULL, " +
                "comment TEXT, " +
                "PRIMARY KEY (review_id), " +
                "KEY listing_id (listing_id), " +
                "KEY user_id (user_id), " +
                "CONSTRAINT reviews_ibfk_1 FOREIGN KEY (listing_id) REFERENCES listings (listing_id) ON DELETE CASCADE ON UPDATE CASCADE, " +
                "CONSTRAINT reviews_ibfk_2 FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE ON UPDATE CASCADE" +
                ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci";

        try (Connection con = DBConnection.getConnection();
             Statement statement = con.createStatement()) {
            statement.execute(sql);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
