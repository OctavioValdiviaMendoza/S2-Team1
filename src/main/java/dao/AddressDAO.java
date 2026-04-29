package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import model.Address;
import util.DBConnection;

public class AddressDAO {

    public List<Address> getAddressesByUserId(int userId) {
        List<Address> addresses = new ArrayList<>();
        String sql = "SELECT * FROM addresses WHERE user_id = ? ORDER BY is_default DESC, address_id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    addresses.add(mapAddress(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return addresses;
    }

    public Address getAddressById(int addressId) {
        String sql = "SELECT * FROM addresses WHERE address_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, addressId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapAddress(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public int createAddress(Address address) {
        String sql = "INSERT INTO addresses " +
                     "(user_id, line_1, line_2, city, state, zip, type, is_default) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, address.getUserId());
            ps.setString(2, address.getLine1());
            ps.setString(3, address.getLine2());
            ps.setString(4, address.getCity());
            ps.setString(5, address.getState());
            ps.setString(6, address.getZip());
            ps.setString(7, address.getType());
            ps.setBoolean(8, address.isDefault());

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

    public boolean addressBelongsToUser(int addressId, int userId) {
        String sql = "SELECT address_id FROM addresses WHERE address_id = ? AND user_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, addressId);
            ps.setInt(2, userId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    private Address mapAddress(ResultSet rs) throws SQLException {
        Address address = new Address();
        address.setAddressId(rs.getInt("address_id"));
        address.setUserId(rs.getInt("user_id"));
        address.setLine1(rs.getString("line_1"));
        address.setLine2(rs.getString("line_2"));
        address.setCity(rs.getString("city"));
        address.setState(rs.getString("state"));
        address.setZip(rs.getString("zip"));
        address.setType(rs.getString("type"));
        address.setDefault(rs.getBoolean("is_default"));
        return address;
    }
}