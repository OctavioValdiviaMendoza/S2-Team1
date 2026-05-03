package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import model.ListingImage;
import util.DBConnection;

public class ListingImageDAO {

    public List<ListingImage> getImagesByListingId(int listingId) {
        List<ListingImage> images = new ArrayList<>();
        String sql = "SELECT * FROM listing_images WHERE listing_id = ? ORDER BY image_id ASC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, listingId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    images.add(mapListingImage(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return images;
    }

    public String getPrimaryImageUrlByListingId(int listingId) {
        String sql = "SELECT image_url FROM listing_images WHERE listing_id = ? ORDER BY image_id ASC LIMIT 1";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, listingId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("image_url");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean deleteImagesByListingId(int listingId) {
        String sql = "DELETE FROM listing_images WHERE listing_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, listingId);
            return ps.executeUpdate() >= 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    private ListingImage mapListingImage(ResultSet rs) throws SQLException {
        ListingImage image = new ListingImage();
        image.setImageId(rs.getInt("image_id"));
        image.setListingId(rs.getInt("listing_id"));
        image.setImageUrl(rs.getString("image_url"));
        return image;
    }
}