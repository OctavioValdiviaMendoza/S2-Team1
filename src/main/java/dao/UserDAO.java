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
			"verification_token, verified, gov_id, created_at " +
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
	                }
	            }

	        } catch (SQLException e) {
	            e.printStackTrace();
	        }

	        return user;
	    }
 }
