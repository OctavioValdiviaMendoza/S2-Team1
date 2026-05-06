package dao;

import java.sql.*;
import model.User;
import util.DBConnection;

public class UserDAO {
	private static final String INSERT_USER_SQL =
	        "INSERT INTO users " +
	        "(first_name, last_name, email, phone_number, password_hash, verification_token, verified, gov_id) " +
	        "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
	
	private static final String SELECT_USER_BY_EMAIL_SQL =
			"SELECT user_id, first_name, last_name, email, phone_number, password_hash, " +
			"verification_token, verified, gov_id, created_at, is_admin " +
			"FROM users WHERE email = ?";
			

    public boolean insertUser(User user) {
        boolean tupleInserted = false;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(INSERT_USER_SQL)) {

            preparedStatement.setString(1, user.getFirstName());
            preparedStatement.setString(2, user.getLastName());
            preparedStatement.setString(3, user.getEmail());
            preparedStatement.setString(4, user.getPhoneNumber());
            preparedStatement.setString(5, user.getPasswordHash());
            preparedStatement.setString(6, user.getVerificationToken());
            preparedStatement.setBoolean(7, user.isVerifiedStatus());
            preparedStatement.setString(8, user.getGovId());

            tupleInserted = preparedStatement.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return tupleInserted;
    }
    
    public User getUserByEmail(String email) {
        User user = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_USER_BY_EMAIL_SQL)) {

            preparedStatement.setString(1, email);

            try (ResultSet rs = preparedStatement.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setFirstName(rs.getString("first_name"));
                    user.setLastName(rs.getString("last_name"));
                    user.setEmail(rs.getString("email"));
                    user.setPhoneNumber(rs.getString("phone_number"));
                    user.setPasswordHash(rs.getString("password_hash"));
                    user.setVerificationToken(rs.getString("verification_token"));
                    user.setVerifiedStatus(rs.getBoolean("verified"));
                    user.setGovId(rs.getString("gov_id"));
                    user.setCreatedAt(rs.getTimestamp("created_at"));
                    user.setIsAdmin(rs.getBoolean("is_admin"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return user;
    }
    
    public User getUserById(int userId) {
        User user = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DBConnection.getConnection();

            String sql = "SELECT * FROM users WHERE user_id = ?";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                user = new User(
                    rs.getInt("user_id"),
                    rs.getString("first_name"),
                    rs.getString("last_name"),
                    rs.getString("email"),
                    rs.getString("phone_number"),
                    rs.getString("password_hash"),
                    rs.getString("verification_token"),
                    rs.getBoolean("verified"),
                    rs.getString("gov_id"),
                    rs.getTimestamp("created_at"),
                    rs.getBoolean("is_admin")
                    );
            }

            rs.close();
            pstmt.close();
            con.close();
        } catch (Exception e) {
            System.out.println("Error fetching user: " + e);
        }

        return user;
    }
    
    public User getUserByVerificationToken(String token) {
        String sql = "SELECT * FROM users WHERE verification_token = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

        		statement.setString(1, token);
            ResultSet rs = statement.executeQuery();

            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setFirstName(rs.getString("first_name"));
                user.setLastName(rs.getString("last_name"));
                user.setEmail(rs.getString("email"));
                user.setPhoneNumber(rs.getString("phone_number"));
                user.setPasswordHash(rs.getString("password_hash"));
                user.setVerificationToken(rs.getString("verification_token"));
                user.setVerifiedStatus(rs.getBoolean("verified"));
                user.setGovId(rs.getString("gov_id"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                user.setIsAdmin(rs.getBoolean("is_admin"));
                return user;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
    
    public boolean verifyUser(String token) {
        String sql = "UPDATE users SET verified = ?, verification_token = NULL WHERE verification_token = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

        	statement.setBoolean(1, true);
        	statement.setString(2, token);

            int rows = statement.executeUpdate();
            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteAccount(int userId) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DBConnection.getConnection();

            String sql = "DELETE FROM users WHERE user_id = ?";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, userId);

            int result = pstmt.executeUpdate();

            pstmt.close();
            con.close();

            return result > 0;
        } catch (Exception e) {
            System.out.println("Error deleting account: " + e);
            return false;
        }
    }
    
    public String getPasswordHashByUserId(int userId) {
        String hash = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DBConnection.getConnection();

            String sql = "SELECT password_hash FROM users WHERE user_id = ?";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, userId);

            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                hash = rs.getString("password_hash");
            }

            rs.close();
            pstmt.close();
            con.close();
        } catch (Exception e) {
            System.out.println("Error fetching password hash: " + e);
        }

        return hash;
    }
    
    public boolean updatePassword(int userId, String hashedPassword) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DBConnection.getConnection();

            String sql = "UPDATE users SET password_hash = ? WHERE user_id = ?";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setString(1, hashedPassword);
            pstmt.setInt(2, userId);

            int result = pstmt.executeUpdate();

            pstmt.close();
            con.close();

            return result > 0;
        } catch (Exception e) {
            System.out.println("Error updating password: " + e);
            return false;
        }
    }
    
    public boolean emailExists(String email) {
        String sql = "SELECT user_id FROM users WHERE email = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
	    
 }
