package service;

import model.User;
import model.Booking;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;

public class UserService {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/team1?autoReconnect=true&useSSL=false";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "Mendoza_101!";

    // Get user by ID
    public static User getUserById(int userId) {
        User user = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            String sql = "SELECT * FROM users WHERE user_id = ?";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                user = new User(
                    rs.getInt("user_id"),
                    rs.getString("name").split(" ")[0], // First name
                    rs.getString("name").contains(" ") ? rs.getString("name").substring(rs.getString("name").indexOf(" ") + 1) : "", // Last name
                    rs.getString("email"),
                    rs.getString("phone_number"),
                    rs.getString("password_hash"),
                    rs.getString("verification_token"),
                    rs.getBoolean("verified"),
                    rs.getString("gov_id"),
                    rs.getTimestamp("created_at")
                );
            }

            rs.close();
            pstmt.close();
            con.close();
        } catch(Exception e) {
            System.out.println("Error fetching user: " + e);
        }

        return user;
    }

    // Get user by email
    public static User getUserByEmail(String email) {
        User user = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            String sql = "SELECT * FROM users WHERE email = ?";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                user = new User(
                    rs.getInt("user_id"),
                    rs.getString("name").split(" ")[0],
                    rs.getString("name").contains(" ") ? rs.getString("name").substring(rs.getString("name").indexOf(" ") + 1) : "",
                    rs.getString("email"),
                    rs.getString("phone_number"),
                    rs.getString("password_hash"),
                    rs.getString("verification_token"),
                    rs.getBoolean("verified"),
                    rs.getString("gov_id"),
                    rs.getTimestamp("created_at")
                );
            }

            rs.close();
            pstmt.close();
            con.close();
        } catch(Exception e) {
            System.out.println("Error fetching user by email: " + e);
        }

        return user;
    }

    // Get payment method for user
    public static String getPaymentMethod(int userId) {
        String paymentMethod = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            String sql = "SELECT p.payment_method FROM payments p " +
                        "JOIN bookings b ON p.booking_id = b.booking_id " +
                        "WHERE b.user_id = ? AND p.payment_status = 'completed' " +
                        "ORDER BY p.created_at DESC LIMIT 1";

            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                paymentMethod = rs.getString("payment_method");
            } else {
                paymentMethod = "Not Set";
            }

            rs.close();
            pstmt.close();
            con.close();
        } catch(Exception e) {
            System.out.println("Error fetching payment method: " + e);
            paymentMethod = "Not Set";
        }

        return paymentMethod;
    }

    // Change user password
    public static boolean changePassword(int userId, String currentPassword, String newPassword) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // First, verify current password
            String selectSql = "SELECT password_hash FROM users WHERE user_id = ?";
            PreparedStatement selectStmt = con.prepareStatement(selectSql);
            selectStmt.setInt(1, userId);
            ResultSet rs = selectStmt.executeQuery();

            if (!rs.next()) {
                return false;
            }

            String storedHash = rs.getString("password_hash");
            String currentHash = hashPassword(currentPassword);

            // Simple password verification (in production, use bcrypt or similar)
            if (!storedHash.equals(currentHash)) {
                return false;
            }

            // Update password
            String updateSql = "UPDATE users SET password_hash = ? WHERE user_id = ?";
            PreparedStatement updateStmt = con.prepareStatement(updateSql);
            updateStmt.setString(1, hashPassword(newPassword));
            updateStmt.setInt(2, userId);
            
            int result = updateStmt.executeUpdate();

            rs.close();
            selectStmt.close();
            updateStmt.close();
            con.close();

            return result > 0;
        } catch(Exception e) {
            System.out.println("Error changing password: " + e);
            return false;
        }
    }

    // Delete user account
    public static boolean deleteAccount(int userId) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // Delete user (cascade will handle related data)
            String sql = "DELETE FROM users WHERE user_id = ?";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, userId);

            int result = pstmt.executeUpdate();

            pstmt.close();
            con.close();

            return result > 0;
        } catch(Exception e) {
            System.out.println("Error deleting account: " + e);
            return false;
        }
    }

    // Get pending rental requests (for user who owns listings)
    public static List<Booking> getPendingRentalRequests(int userId) {
        List<Booking> requests = new ArrayList<>();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            String sql = "SELECT b.*, l.title as listing_title, l.price, u.name as renter_name, " +
                        "(SELECT payment_method FROM payments WHERE booking_id = b.booking_id LIMIT 1) as payment_method " +
                        "FROM bookings b " +
                        "JOIN listings l ON b.listing_id = l.listing_id " +
                        "JOIN users u ON b.user_id = u.user_id " +
                        "WHERE l.user_id = ? AND b.status = 'pending' " +
                        "ORDER BY b.created_at DESC";

            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Booking booking = new Booking(
                    rs.getInt("booking_id"),
                    rs.getInt("listing_id"),
                    rs.getInt("user_id"),
                    rs.getTimestamp("start_time"),
                    rs.getTimestamp("end_time"),
                    rs.getString("status"),
                    rs.getTimestamp("created_at")
                );
                booking.setListingTitle(rs.getString("listing_title"));
                booking.setRenterName(rs.getString("renter_name"));
                booking.setRentPrice(rs.getDouble("price"));
                booking.setPaymentMethod(rs.getString("payment_method"));
                requests.add(booking);
            }

            rs.close();
            pstmt.close();
            con.close();
        } catch(Exception e) {
            System.out.println("Error fetching pending requests: " + e);
        }

        return requests;
    }

    // Get processed rental requests (accepted/denied)
    public static List<Booking> getProcessedRentalRequests(int userId) {
        List<Booking> requests = new ArrayList<>();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            String sql = "SELECT b.*, l.title as listing_title, l.price, u.name as renter_name, " +
                        "(SELECT payment_method FROM payments WHERE booking_id = b.booking_id LIMIT 1) as payment_method " +
                        "FROM bookings b " +
                        "JOIN listings l ON b.listing_id = l.listing_id " +
                        "JOIN users u ON b.user_id = u.user_id " +
                        "WHERE l.user_id = ? AND b.status IN ('confirmed', 'denied', 'completed', 'cancelled') " +
                        "ORDER BY b.created_at DESC";

            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Booking booking = new Booking(
                    rs.getInt("booking_id"),
                    rs.getInt("listing_id"),
                    rs.getInt("user_id"),
                    rs.getTimestamp("start_time"),
                    rs.getTimestamp("end_time"),
                    rs.getString("status"),
                    rs.getTimestamp("created_at")
                );
                booking.setListingTitle(rs.getString("listing_title"));
                booking.setRenterName(rs.getString("renter_name"));
                booking.setRentPrice(rs.getDouble("price"));
                booking.setPaymentMethod(rs.getString("payment_method"));
                requests.add(booking);
            }

            rs.close();
            pstmt.close();
            con.close();
        } catch(Exception e) {
            System.out.println("Error fetching processed requests: " + e);
        }

        return requests;
    }

    // Update booking status
    public static boolean updateBookingStatus(int bookingId, String status) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            String sql = "UPDATE bookings SET status = ? WHERE booking_id = ?";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setString(1, status);
            pstmt.setInt(2, bookingId);

            int result = pstmt.executeUpdate();

            pstmt.close();
            con.close();

            return result > 0;
        } catch(Exception e) {
            System.out.println("Error updating booking status: " + e);
            return false;
        }
    }

    // Helper method to hash password
    private static String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes());
            return Base64.getEncoder().encodeToString(hashedBytes);
        } catch(Exception e) {
            System.out.println("Error hashing password: " + e);
            return password;
        }
    }
}
