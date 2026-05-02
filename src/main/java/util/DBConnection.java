package util;
import java.sql.*;

public class DBConnection {
	
	private static final String URL = "jdbc:mysql://localhost:3306/team1?autoReconnect=true&useSSL=false&serverTimezone=UTC";
	private static final String USER = "root";
	private static final String PASSWORD = "Paris-Hole-06";
	
	static {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			throw new ExceptionInInitializerError("MySQL JDBC driver is missing from WEB-INF/lib: " + e.getMessage());
		}
	}

	public static Connection getConnection() throws SQLException {
		try {
			return DriverManager.getConnection(URL, USER, PASSWORD);
		} catch (SQLException e) {
			System.err.println("Database connection failed: " + e.getMessage());
			throw e;
		}
    }
	

}
