package dao;

import java.sql.*;
import model.User;
import util.DBConnection;

public class UserDAO {
	private static final String INSERT_USER_SQL =
	        "INSERT INTO users " +
	        "(first_name, last_name, email, phone_number, password_hash, verification_token, verified, gov_id) " +
	        "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

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

}
