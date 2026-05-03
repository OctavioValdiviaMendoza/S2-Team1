package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import model.Listing;
import util.DBConnection;

public class ListingDAO {

    public List<Listing> getAllListings() {
        List<Listing> listings = new ArrayList<>();
        String sql = "SELECT * FROM listings ORDER BY created_at DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                listings.add(mapListing(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return listings;
    }

    public Listing getListingById(int listingId) {
        String sql = "SELECT * FROM listings WHERE listing_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, listingId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapListing(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<Listing> getListingsByUserId(int userId) {
        List<Listing> listings = new ArrayList<>();
        String sql = "SELECT * FROM listings WHERE user_id = ? ORDER BY created_at DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    listings.add(mapListing(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return listings;
    }

    public List<Listing> getListingsByCategory(int categoryId) {
        List<Listing> listings = new ArrayList<>();
        String sql = "SELECT * FROM listings WHERE category_id = ? ORDER BY created_at DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, categoryId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    listings.add(mapListing(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return listings;
    }

    public List<Listing> searchListings(String keyword) {
        List<Listing> listings = new ArrayList<>();
        String sql = "SELECT * FROM listings " +
                     "WHERE title LIKE ? OR description LIKE ? " +
                     "ORDER BY created_at DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            String searchTerm = "%" + keyword.trim() + "%";
            ps.setString(1, searchTerm);
            ps.setString(2, searchTerm);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    listings.add(mapListing(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return listings;
    }

    public List<Listing> filterListings(Integer categoryId, String keyword, Double maxPrice) {
        return filterListings(categoryId, keyword, maxPrice, null);
    }

    public List<Listing> filterListings(Integer categoryId, String keyword, Double maxPrice, String location) {
        List<Listing> listings = new ArrayList<>();
        List<Object> params = new ArrayList<>();
        boolean hasLocationFilter = location != null && !location.trim().isEmpty();

        try (Connection con = DBConnection.getConnection()) {
            boolean canFilterByLocation = hasLocationFilter && hasTableColumn(con, "listings", "address_id");
            StringBuilder sql = new StringBuilder("SELECT l.* FROM listings l ");

            if (canFilterByLocation) {
                sql.append("LEFT JOIN addresses a ON l.address_id = a.address_id ");
            }

            sql.append("WHERE 1=1 ");

            if (categoryId != null) {
                sql.append("AND l.category_id = ? ");
                params.add(categoryId);
            }

            if (keyword != null && !keyword.trim().isEmpty()) {
                sql.append("AND (l.title LIKE ? OR l.description LIKE ?) ");
                String searchTerm = "%" + keyword.trim() + "%";
                params.add(searchTerm);
                params.add(searchTerm);
            }

            if (maxPrice != null) {
                sql.append("AND l.price <= ? ");
                params.add(maxPrice);
            }

            if (canFilterByLocation) {
                sql.append("AND (a.city LIKE ? OR a.state LIKE ? OR a.zip LIKE ? OR a.line_1 LIKE ?) ");
                String locationTerm = "%" + location.trim() + "%";
                params.add(locationTerm);
                params.add(locationTerm);
                params.add(locationTerm);
                params.add(locationTerm);
            }

            sql.append("ORDER BY l.created_at DESC");

            try (PreparedStatement ps = con.prepareStatement(sql.toString())) {

                for (int i = 0; i < params.size(); i++) {
                    ps.setObject(i + 1, params.get(i));
                }

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        listings.add(mapListing(rs));
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return listings;
    }

    public int createListing(Listing listing, List<String> imageUrls) {
        String listingSql =
                "INSERT INTO listings (user_id, category_id, title, description, price, availability, address_id) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";
        String imageSql =
                "INSERT INTO listing_images (listing_id, image_url) VALUES (?, ?)";

        Connection con = null;

        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            int listingId;

            try (PreparedStatement listingStmt =
                         con.prepareStatement(listingSql, Statement.RETURN_GENERATED_KEYS)) {

                listingStmt.setInt(1, listing.getUserId());
                listingStmt.setInt(2, listing.getCategoryId());
                listingStmt.setString(3, listing.getTitle());
                listingStmt.setString(4, listing.getDescription());
                listingStmt.setDouble(5, listing.getPrice());
                listingStmt.setBoolean(6, listing.isAvailability());
                listingStmt.setInt(7, listing.getAddressId());

                int affectedRows = listingStmt.executeUpdate();
                if (affectedRows == 0) {
                    con.rollback();
                    return -1;
                }

                try (ResultSet generatedKeys = listingStmt.getGeneratedKeys()) {
                    if (!generatedKeys.next()) {
                        con.rollback();
                        return -1;
                    }
                    listingId = generatedKeys.getInt(1);
                }
            }

            if (imageUrls != null && !imageUrls.isEmpty()) {
                try (PreparedStatement imageStmt = con.prepareStatement(imageSql)) {
                    for (String imageUrl : imageUrls) {
                        if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                            imageStmt.setInt(1, listingId);
                            imageStmt.setString(2, imageUrl.trim());
                            imageStmt.addBatch();
                        }
                    }
                    imageStmt.executeBatch();
                }
            }

            con.commit();
            return listingId;

        } catch (SQLException e) {
            e.printStackTrace();

            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }

            return -1;
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public boolean updateListing(Listing listing, List<String> imageUrls) {
        String listingSql =
                "UPDATE listings " +
                "SET category_id = ?, title = ?, description = ?, price = ?, availability = ?, address_id = ? " +
                "WHERE listing_id = ? AND user_id = ?";
        String deleteImagesSql =
                "DELETE FROM listing_images WHERE listing_id = ?";
        String imageSql =
                "INSERT INTO listing_images (listing_id, image_url) VALUES (?, ?)";

        Connection con = null;

        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            try (PreparedStatement listingStmt = con.prepareStatement(listingSql)) {
                listingStmt.setInt(1, listing.getCategoryId());
                listingStmt.setString(2, listing.getTitle());
                listingStmt.setString(3, listing.getDescription());
                listingStmt.setDouble(4, listing.getPrice());
                listingStmt.setBoolean(5, listing.isAvailability());
                listingStmt.setInt(6, listing.getAddressId());
                listingStmt.setInt(7, listing.getListingId());
                listingStmt.setInt(8, listing.getUserId());

                int updatedRows = listingStmt.executeUpdate();
                if (updatedRows == 0) {
                    con.rollback();
                    return false;
                }
            }

            try (PreparedStatement deleteImagesStmt = con.prepareStatement(deleteImagesSql)) {
                deleteImagesStmt.setInt(1, listing.getListingId());
                deleteImagesStmt.executeUpdate();
            }

            if (imageUrls != null && !imageUrls.isEmpty()) {
                try (PreparedStatement imageStmt = con.prepareStatement(imageSql)) {
                    for (String imageUrl : imageUrls) {
                        if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                            imageStmt.setInt(1, listing.getListingId());
                            imageStmt.setString(2, imageUrl.trim());
                            imageStmt.addBatch();
                        }
                    }
                    imageStmt.executeBatch();
                }
            }

            con.commit();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();

            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }

            return false;
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public boolean deleteListing(int listingId, int userId) {
        String sql = "DELETE FROM listings WHERE listing_id = ? AND user_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, listingId);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<String> getImageUrlsByListingId(int listingId) {
        List<String> imageUrls = new ArrayList<>();
        String sql = "SELECT image_url FROM listing_images WHERE listing_id = ? ORDER BY image_id ASC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, listingId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    imageUrls.add(rs.getString("image_url"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return imageUrls;
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

    private Listing mapListing(ResultSet rs) throws SQLException {
        Listing listing = new Listing();
        listing.setListingId(rs.getInt("listing_id"));
        listing.setUserId(rs.getInt("user_id"));
        listing.setCategoryId(rs.getInt("category_id"));
        listing.setTitle(rs.getString("title"));
        listing.setDescription(rs.getString("description"));
        listing.setPrice(rs.getDouble("price"));
        listing.setCreatedAt(rs.getTimestamp("created_at"));
        listing.setAvailability(rs.getBoolean("availability"));
        if (hasColumn(rs, "address_id")) {
            listing.setAddressId(rs.getInt("address_id"));
        }
        return listing;
    }

    private boolean hasColumn(ResultSet rs, String columnName) throws SQLException {
        ResultSetMetaData metaData = rs.getMetaData();
        for (int i = 1; i <= metaData.getColumnCount(); i++) {
            if (columnName.equalsIgnoreCase(metaData.getColumnName(i))) {
                return true;
            }
        }
        return false;
    }

    private boolean hasTableColumn(Connection con, String tableName, String columnName) throws SQLException {
        DatabaseMetaData metaData = con.getMetaData();
        try (ResultSet columns = metaData.getColumns(con.getCatalog(), null, tableName, columnName)) {
            return columns.next();
        }
    }
}
