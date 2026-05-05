package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import model.Log;
import util.DBConnection;

public class LogDAO {

    public boolean addLog(Integer userId, String action, String details) {
        String sql = "INSERT INTO logs (user_id, action, details) VALUES (?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            if (userId == null) {
                ps.setNull(1, Types.INTEGER);
            } else {
                ps.setInt(1, userId);
            }

            ps.setString(2, action);
            ps.setString(3, details);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<Log> getTop30Logs() {
        List<Log> logs = new ArrayList<>();

        String sql = "SELECT * FROM logs ORDER BY created_at DESC LIMIT 30";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Log log = new Log();

                log.setLogId(rs.getInt("log_id"));
                log.setUserId(rs.getInt("user_id"));
                log.setAction(rs.getString("action"));
                log.setDetails(rs.getString("details"));
                log.setCreatedAt(rs.getTimestamp("created_at"));

                logs.add(log);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return logs;
    }
}