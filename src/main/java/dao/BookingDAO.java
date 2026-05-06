package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import model.Booking;
import util.DBConnection;

public class BookingDAO {

    public int createBookingRequest(Booking booking) {
        String sql =
            "INSERT INTO bookings (listing_id, user_id, start_time, end_time, status) " +
            "VALUES (?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, booking.getListingId());
            ps.setInt(2, booking.getUserId());
            ps.setTimestamp(3, booking.getStartTime());
            ps.setTimestamp(4, booking.getEndTime());
            ps.setString(5, "pending");

            int rows = ps.executeUpdate();

            if (rows == 0) {
                return -1;
            }

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return -1;
    }
    
    public boolean hasOverlappingConfirmedBooking(int listingId, int bookingId, Timestamp startTime, Timestamp endTime) {
        String sql =
            "SELECT booking_id FROM bookings " +
            "WHERE listing_id = ? " +
            "AND booking_id <> ? " +
            "AND status = 'confirmed' " +
            "AND start_time < ? " +
            "AND end_time > ? " +
            "LIMIT 1";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, listingId);
            ps.setInt(2, bookingId);
            ps.setTimestamp(3, endTime);
            ps.setTimestamp(4, startTime);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return true;
    }

    public List<Integer> getOverlappingPendingBookingIds(int listingId, int bookingId, Timestamp startTime, Timestamp endTime) {
        List<Integer> bookingIds = new ArrayList<>();

        String sql =
            "SELECT booking_id FROM bookings " +
            "WHERE listing_id = ? " +
            "AND booking_id <> ? " +
            "AND status = 'pending' " +
            "AND start_time < ? " +
            "AND end_time > ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, listingId);
            ps.setInt(2, bookingId);
            ps.setTimestamp(3, endTime);
            ps.setTimestamp(4, startTime);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    bookingIds.add(rs.getInt("booking_id"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return bookingIds;
    }

    public boolean denyBookingsByIds(List<Integer> bookingIds) {
        if (bookingIds == null || bookingIds.isEmpty()) {
            return true;
        }

        StringBuilder sql = new StringBuilder("UPDATE bookings SET status = 'denied' WHERE booking_id IN (");

        for (int i = 0; i < bookingIds.size(); i++) {
            sql.append("?");
            if (i < bookingIds.size() - 1) {
                sql.append(",");
            }
        }

        sql.append(")");

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            for (int i = 0; i < bookingIds.size(); i++) {
                ps.setInt(i + 1, bookingIds.get(i));
            }

            return ps.executeUpdate() >= 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
}