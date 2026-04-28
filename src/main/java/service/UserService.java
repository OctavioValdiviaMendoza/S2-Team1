package service;

import model.User;
import util.DBConnection;
import model.Booking;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import dao.UserDAO;

public class UserService {
	
	private UserDAO userDAO = new UserDAO();
	
	public User getUserById(int userId) {
		User user = userDAO.getUserById(userId);
		
		return user;
		
	}
    public static String getPaymentMethod(int userId) {
        String paymentMethod = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DBConnection.getConnection();

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
        } catch (Exception e) {
            System.out.println("Error fetching payment method: " + e);
            paymentMethod = "Not Set";
        }

        return paymentMethod;
    }

    // Change user password found in User Settings
    public boolean changePassword(int userId, String currentPassword, String newPassword) {
        // Get stored password hash from DB
        String storedHash = userDAO.getPasswordHashByUserId(userId);

        if (storedHash == null) {
            return false; // user not found
        }

        // Check current password input field for User settings
        if (!checkPassword(currentPassword, storedHash)) {
            return false;
        }

        // Hash new password
        String newHashedPassword = hashPassword(newPassword);

        // Update password with new password in DB
        return userDAO.updatePassword(userId, newHashedPassword);
    }

    // Delete user account
    public static boolean deleteAccount(int userId) {
    	   UserDAO userDAO = new UserDAO();
       boolean deletedAccount = userDAO.deleteAccount(userId);
       return deletedAccount;
    }

    // Get pending rental requests (for user who owns listings)
    public static List<Booking> getPendingRentalRequests(int userId) {
        List<Booking> requests = new ArrayList<>();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DBConnection.getConnection();

            String sql = "SELECT b.*, l.title as listing_title, l.price, " +
                        "CONCAT(u.first_name, ' ', u.last_name) as renter_name, " +
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
        } catch (Exception e) {
            System.out.println("Error fetching pending requests: " + e);
        }

        return requests;
    }

    // Get processed rental requests (accepted/denied)
    public static List<Booking> getProcessedRentalRequests(int userId) {
        List<Booking> requests = new ArrayList<>();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DBConnection.getConnection();

            String sql = "SELECT b.*, l.title as listing_title, l.price, " +
                        "CONCAT(u.first_name, ' ', u.last_name) as renter_name, " +
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
        } catch (Exception e) {
            System.out.println("Error fetching processed requests: " + e);
        }

        return requests;
    }

    // Update booking status
    public static boolean updateBookingStatus(int bookingId, String status) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DBConnection.getConnection();

            String sql = "UPDATE bookings SET status = ? WHERE booking_id = ?";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setString(1, status);
            pstmt.setInt(2, bookingId);

            int result = pstmt.executeUpdate();

            pstmt.close();
            con.close();

            return result > 0;
        } catch (Exception e) {
            System.out.println("Error updating booking status: " + e);
            return false;
        }
    }
    
    //Using the jbcrypt dependency for both hashPasswor and checkPassword
    public String hashPassword(String plainTextPassword) {
        return BCrypt.hashpw(plainTextPassword, BCrypt.gensalt());
    }

    public boolean checkPassword(String plainTextPassword, String hashedPassword) {
        return BCrypt.checkpw(plainTextPassword, hashedPassword);
    }
    

    public User authenticateUser(String email, String password) {
        User user = userDAO.getUserByEmail(email);

        if (user != null && user.getPasswordHash() != null && password != null && checkPassword(password,user.getPasswordHash()) ) {
            return user;
        }

        return null;
    }
    
}
