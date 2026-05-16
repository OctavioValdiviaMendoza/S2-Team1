package dao;

import model.ListingPreference;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ListingPreferenceDAO {

    public boolean createListingPreference(ListingPreference preference) {

        String preferenceSql =
                "INSERT INTO listing_preferences " +
                "(listing_id, contact_method, contact_info) " +
                "VALUES (?, ?, ?)";

        String paymentSql =
                "INSERT INTO listing_payment_methods " +
                "(listing_id, payment_method) " +
                "VALUES (?, ?)";

        Connection con = null;

        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            try (PreparedStatement ps = con.prepareStatement(preferenceSql)) {

                ps.setInt(1, preference.getListingId());
                ps.setString(2, preference.getContactMethod());
                ps.setString(3, preference.getContactInfo());

                ps.executeUpdate();
            }

            // Insert payment methods
            if (preference.getPaymentMethods() != null &&
                !preference.getPaymentMethods().isEmpty()) {

                try (PreparedStatement ps = con.prepareStatement(paymentSql)) {

                    for (String paymentMethod : preference.getPaymentMethods()) {

                        ps.setInt(1, preference.getListingId());
                        ps.setString(2, paymentMethod);

                        ps.addBatch();
                    }

                    ps.executeBatch();
                }
            }

            con.commit();
            return true;

        } catch (Exception e) {

            e.printStackTrace();

            if (con != null) {
                try {
                    con.rollback();
                } catch (Exception rollbackError) {
                    rollbackError.printStackTrace();
                }
            }

            return false;

        } finally {

            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (Exception closeError) {
                    closeError.printStackTrace();
                }
            }
        }
    }

    public ListingPreference getListingPreferenceByListingId(int listingId) {

        String preferenceSql =
                "SELECT * FROM listing_preferences WHERE listing_id = ?";

        String paymentSql =
                "SELECT payment_method " +
                "FROM listing_payment_methods " +
                "WHERE listing_id = ?";

        ListingPreference preference = null;

        try (Connection con = DBConnection.getConnection()) {

            try (PreparedStatement ps = con.prepareStatement(preferenceSql)) {

                ps.setInt(1, listingId);

                try (ResultSet rs = ps.executeQuery()) {

                    if (rs.next()) {

                        preference = new ListingPreference();

                        preference.setListingId(
                                rs.getInt("listing_id"));

                        preference.setContactMethod(
                                rs.getString("contact_method"));

                        preference.setContactInfo(
                                rs.getString("contact_info"));
                    }
                }
            }

            // No preference row found
            if (preference == null) {
                return null;
            }

            // Get payment methods
            List<String> paymentMethods = new ArrayList<>();

            try (PreparedStatement ps = con.prepareStatement(paymentSql)) {

                ps.setInt(1, listingId);

                try (ResultSet rs = ps.executeQuery()) {

                    while (rs.next()) {
                        paymentMethods.add(
                                rs.getString("payment_method"));
                    }
                }
            }

            preference.setPaymentMethods(paymentMethods);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return preference;
    }

    public boolean updateListingPreference(ListingPreference preference) {

        String updatePreferenceSql =
                "UPDATE listing_preferences " +
                "SET contact_method = ?, contact_info = ? " +
                "WHERE listing_id = ?";

        String deletePaymentsSql =
                "DELETE FROM listing_payment_methods " +
                "WHERE listing_id = ?";

        String insertPaymentSql =
                "INSERT INTO listing_payment_methods " +
                "(listing_id, payment_method) " +
                "VALUES (?, ?)";

        Connection con = null;

        try {

            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            try (PreparedStatement ps =
                         con.prepareStatement(updatePreferenceSql)) {

                ps.setString(1, preference.getContactMethod());
                ps.setString(2, preference.getContactInfo());
                ps.setInt(3, preference.getListingId());

                ps.executeUpdate();
            }

            try (PreparedStatement ps =
                         con.prepareStatement(deletePaymentsSql)) {

                ps.setInt(1, preference.getListingId());
                ps.executeUpdate();
            }


            if (preference.getPaymentMethods() != null &&
                !preference.getPaymentMethods().isEmpty()) {

                try (PreparedStatement ps =
                             con.prepareStatement(insertPaymentSql)) {

                    for (String paymentMethod :
                            preference.getPaymentMethods()) {

                        ps.setInt(1, preference.getListingId());
                        ps.setString(2, paymentMethod);

                        ps.addBatch();
                    }

                    ps.executeBatch();
                }
            }

            con.commit();
            return true;

        } catch (Exception e) {

            e.printStackTrace();

            if (con != null) {
                try {
                    con.rollback();
                } catch (Exception rollbackError) {
                    rollbackError.printStackTrace();
                }
            }

            return false;

        } finally {

            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (Exception closeError) {
                    closeError.printStackTrace();
                }
            }
        }
    }

    public boolean deleteListingPreferenceByListingId(int listingId) {

        String sql =
                "DELETE FROM listing_preferences WHERE listing_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, listingId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}