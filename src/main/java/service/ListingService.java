package service;

import model.Listing;
import model.Category;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import util.DBConnection;

public class ListingService {
    private static final String META_MARKER = "[LENDR_META]";

    private static final String LISTING_SELECT =
            "SELECT l.*, c.category_name, " +
            "(SELECT image_url FROM listing_images WHERE listing_id = l.listing_id LIMIT 1) AS image_url, " +
            "(SELECT CONCAT(city, ', ', state) FROM addresses WHERE user_id = l.user_id AND is_default = 1 LIMIT 1) AS location " +
            "FROM listings l " +
            "LEFT JOIN categories c ON l.category_id = c.category_id ";

public static List<Listing> getAllListings() {
    List<Listing> listings = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DBConnection.getConnection();

        String sql = LISTING_SELECT +
                     "WHERE l.availability = 1 " +
                     "ORDER BY l.created_at DESC";

        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery(sql);

        while (rs.next()) {
            listings.add(mapListing(rs));
        }

        rs.close();
        stmt.close();
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }

    return listings;
}

    public static List<Listing> getListingsByCategory(int categoryId) {
        List<Listing> listings = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con =  DBConnection.getConnection();

            String sql = LISTING_SELECT +
                    "WHERE l.category_id = ? AND l.availability = 1 " +
                    "ORDER BY l.created_at DESC";

            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, categoryId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                listings.add(mapListing(rs));
            }

            rs.close();
            pstmt.close();
            con.close();
        } catch (Exception e) {
            System.out.println("Error fetching listings by category:");
            e.printStackTrace();
        }

        return listings;
    }

    public static List<Listing> searchListings(String searchTerm) {
        List<Listing> listings = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con =  DBConnection.getConnection();

            String sql = LISTING_SELECT +
                    "WHERE (l.title LIKE ? OR l.description LIKE ?) AND l.availability = 1 " +
                    "ORDER BY l.created_at DESC";

            PreparedStatement pstmt = con.prepareStatement(sql);
            String pattern = "%" + searchTerm + "%";
            pstmt.setString(1, pattern);
            pstmt.setString(2, pattern);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                listings.add(mapListing(rs));
            }

            rs.close();
            pstmt.close();
            con.close();
        } catch (Exception e) {
            System.out.println("Error searching listings:");
            e.printStackTrace();
        }

        return listings;
    }

    public static Listing getListingById(int listingId) {
        Listing listing = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con =  DBConnection.getConnection();

            String sql = LISTING_SELECT +
                    "WHERE l.listing_id = ?";

            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, listingId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                listing = mapListing(rs);
            }

            rs.close();
            pstmt.close();
            con.close();
        } catch (Exception e) {
            System.out.println("Error fetching listing by ID:");
            e.printStackTrace();
        }

        return listing;
    }

    public static int createListing(Listing listing, List<String> imageUrls) {
        int createdListingId = -1;

        Connection con = null;
        PreparedStatement listingStmt = null;
        PreparedStatement imageStmt = null;
        ResultSet generatedKeys = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            String listingSql = "INSERT INTO listings (user_id, category_id, title, description, price, availability) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";
            listingStmt = con.prepareStatement(listingSql, Statement.RETURN_GENERATED_KEYS);
            listingStmt.setInt(1, listing.getUserId());
            listingStmt.setInt(2, listing.getCategoryId());
            listingStmt.setString(3, listing.getTitle());
            listingStmt.setString(4, serializeDescription(listing));
            listingStmt.setDouble(5, listing.getPrice());
            listingStmt.setBoolean(6, listing.isAvailability());

            int insertedRows = listingStmt.executeUpdate();
            if (insertedRows == 0) {
                con.rollback();
                return -1;
            }

            generatedKeys = listingStmt.getGeneratedKeys();
            if (generatedKeys.next()) {
                createdListingId = generatedKeys.getInt(1);
            } else {
                con.rollback();
                return -1;
            }

            if (imageUrls != null && !imageUrls.isEmpty()) {
                String imageSql = "INSERT INTO listing_images (listing_id, image_url) VALUES (?, ?)";
                imageStmt = con.prepareStatement(imageSql);

                for (String imageUrl : imageUrls) {
                    imageStmt.setInt(1, createdListingId);
                    imageStmt.setString(2, imageUrl);
                    imageStmt.addBatch();
                }

                imageStmt.executeBatch();
            }

            con.commit();
        } catch (Exception e) {
            System.out.println("Error creating listing:");
            e.printStackTrace();
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException rollbackException) {
                    rollbackException.printStackTrace();
                }
            }
            createdListingId = -1;
        } finally {
            try {
                if (generatedKeys != null) {
                    generatedKeys.close();
                }
                if (listingStmt != null) {
                    listingStmt.close();
                }
                if (imageStmt != null) {
                    imageStmt.close();
                }
                if (con != null) {
                    con.setAutoCommit(true);
                    con.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return createdListingId;
    }

    public static boolean updateListing(Listing listing, List<String> imageUrls) {
        Connection con = null;
        PreparedStatement listingStmt = null;
        PreparedStatement deleteImagesStmt = null;
        PreparedStatement imageStmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            String listingSql = "UPDATE listings " +
                    "SET category_id = ?, title = ?, description = ?, price = ?, availability = ? " +
                    "WHERE listing_id = ? AND user_id = ?";
            listingStmt = con.prepareStatement(listingSql);
            listingStmt.setInt(1, listing.getCategoryId());
            listingStmt.setString(2, listing.getTitle());
            listingStmt.setString(3, serializeDescription(listing));
            listingStmt.setDouble(4, listing.getPrice());
            listingStmt.setBoolean(5, listing.isAvailability());
            listingStmt.setInt(6, listing.getListingId());
            listingStmt.setInt(7, listing.getUserId());

            int updatedRows = listingStmt.executeUpdate();
            if (updatedRows == 0) {
                con.rollback();
                return false;
            }

            deleteImagesStmt = con.prepareStatement("DELETE FROM listing_images WHERE listing_id = ?");
            deleteImagesStmt.setInt(1, listing.getListingId());
            deleteImagesStmt.executeUpdate();

            if (imageUrls != null && !imageUrls.isEmpty()) {
                String imageSql = "INSERT INTO listing_images (listing_id, image_url) VALUES (?, ?)";
                imageStmt = con.prepareStatement(imageSql);

                for (String imageUrl : imageUrls) {
                    imageStmt.setInt(1, listing.getListingId());
                    imageStmt.setString(2, imageUrl);
                    imageStmt.addBatch();
                }

                imageStmt.executeBatch();
            }

            con.commit();
            return true;
        } catch (Exception e) {
            System.out.println("Error updating listing:");
            e.printStackTrace();
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException rollbackException) {
                    rollbackException.printStackTrace();
                }
            }
            return false;
        } finally {
            try {
                if (listingStmt != null) {
                    listingStmt.close();
                }
                if (deleteImagesStmt != null) {
                    deleteImagesStmt.close();
                }
                if (imageStmt != null) {
                    imageStmt.close();
                }
                if (con != null) {
                    con.setAutoCommit(true);
                    con.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public static List<Listing> filterListings(Integer categoryId, String searchTerm, Double maxPrice, String location) {
        List<Listing> listings = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DBConnection.getConnection();

            StringBuilder sql = new StringBuilder(LISTING_SELECT);
            sql.append("WHERE l.availability = 1 ");

            List<Object> params = new ArrayList<>();

            if (categoryId != null) {
                sql.append("AND l.category_id = ? ");
                params.add(categoryId);
            }

            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                sql.append("AND (l.title LIKE ? OR l.description LIKE ?) ");
                String pattern = "%" + searchTerm.trim() + "%";
                params.add(pattern);
                params.add(pattern);
            }

            if (maxPrice != null) {
                sql.append("AND l.price <= ? ");
                params.add(maxPrice);
            }

            if (location != null && !location.trim().isEmpty()) {
                sql.append("AND EXISTS (");
                sql.append("SELECT 1 FROM addresses a ");
                sql.append("WHERE a.user_id = l.user_id AND a.is_default = 1 ");
                sql.append("AND (a.city LIKE ? OR a.state LIKE ? OR a.zip LIKE ?)) ");
                String locationPattern = "%" + location.trim() + "%";
                params.add(locationPattern);
                params.add(locationPattern);
                params.add(locationPattern);
            }

            sql.append("ORDER BY l.created_at DESC");

            PreparedStatement pstmt = con.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }

            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                listings.add(mapListing(rs));
            }

            rs.close();
            pstmt.close();
            con.close();
        } catch (Exception e) {
            System.out.println("Error filtering listings:");
            e.printStackTrace();
        }

        return listings;
    }

    public static List<Listing> getListingsByUserId(int userId) {
        List<Listing> listings = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con =  DBConnection.getConnection();

            String sql = "SELECT l.*, c.category_name " +
                    "FROM listings l " +
                    "LEFT JOIN categories c ON l.category_id = c.category_id " +
                    "WHERE l.user_id = ? " +
                    "ORDER BY l.created_at DESC";

            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Listing listing = new Listing(
                    rs.getInt("listing_id"),
                    rs.getInt("user_id"),
                    rs.getInt("category_id"),
                    rs.getString("title"),
                    rs.getString("description"),
                    rs.getDouble("price"),
                    rs.getTimestamp("created_at"),
                    rs.getBoolean("availability")
                );
                applySerializedDescription(listing, rs.getString("description"));
                listing.setCategoryName(rs.getString("category_name"));
                listings.add(listing);
            }

            rs.close();
            pstmt.close();
            con.close();
        } catch (Exception e) {
            System.out.println("Error fetching listings by user ID:");
            e.printStackTrace();
        }

        return listings;
    }

    public static List<String> getImageUrlsByListingId(int listingId) {
        List<String> imageUrls = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DBConnection.getConnection();

            String sql = "SELECT image_url FROM listing_images WHERE listing_id = ? ORDER BY image_id ASC";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, listingId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                imageUrls.add(rs.getString("image_url"));
            }

            rs.close();
            pstmt.close();
            con.close();
        } catch (Exception e) {
            System.out.println("Error fetching listing images:");
            e.printStackTrace();
        }

        return imageUrls;
    }

    public static List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con =  DBConnection.getConnection();

            String sql = "SELECT * FROM categories ORDER BY category_name";
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(sql);

            while (rs.next()) {
                Category category = new Category(
                        rs.getInt("category_id"),
                        rs.getString("category_name")
                );
                categories.add(category);
            }

            rs.close();
            stmt.close();
            con.close();
        } catch (Exception e) {
            System.out.println("Error fetching categories:");
            e.printStackTrace();
        }

        return categories;
    }

    private static Listing mapListing(ResultSet rs) throws SQLException {
        Listing listing = new Listing(
                rs.getInt("listing_id"),
                rs.getInt("user_id"),
                rs.getInt("category_id"),
                rs.getString("title"),
                rs.getString("description"),
                rs.getDouble("price"),
                rs.getTimestamp("created_at"),
                rs.getBoolean("availability")
        );
        applySerializedDescription(listing, rs.getString("description"));
        listing.setCategoryName(rs.getString("category_name"));
        listing.setImageUrl(rs.getString("image_url"));
        listing.setLocation(rs.getString("location"));
        return listing;
    }

    private static String serializeDescription(Listing listing) {
        StringBuilder builder = new StringBuilder();
        builder.append(sanitizeText(listing.getDescription()));
        builder.append("\n\n").append(META_MARKER).append("\n");
        builder.append("pricingUnit=").append(sanitizeMetaValue(listing.getPricingUnit())).append("\n");
        builder.append("paymentMethods=").append(sanitizeMetaValue(listing.getAcceptedPaymentMethods())).append("\n");
        builder.append("contactMethod=").append(sanitizeMetaValue(listing.getContactMethod())).append("\n");
        builder.append("contactInfo=").append(sanitizeMetaValue(listing.getContactInfo())).append("\n");
        builder.append("fulfillmentMethod=").append(sanitizeMetaValue(listing.getFulfillmentMethod()));
        return builder.toString();
    }

    private static void applySerializedDescription(Listing listing, String storedDescription) {
        if (storedDescription == null || !storedDescription.contains(META_MARKER)) {
            listing.setDescription(storedDescription);
            return;
        }

        String[] parts = storedDescription.split("\\n\\n" + java.util.regex.Pattern.quote(META_MARKER) + "\\n", 2);
        listing.setDescription(parts[0]);

        if (parts.length < 2) {
            return;
        }

        String[] metaLines = parts[1].split("\\n");
        for (String metaLine : metaLines) {
            int separatorIndex = metaLine.indexOf('=');
            if (separatorIndex < 0) {
                continue;
            }

            String key = metaLine.substring(0, separatorIndex);
            String value = metaLine.substring(separatorIndex + 1);

            if ("pricingUnit".equals(key)) {
                listing.setPricingUnit(value);
            } else if ("paymentMethods".equals(key)) {
                listing.setAcceptedPaymentMethods(value);
            } else if ("contactMethod".equals(key)) {
                listing.setContactMethod(value);
            } else if ("contactInfo".equals(key)) {
                listing.setContactInfo(value);
            } else if ("fulfillmentMethod".equals(key)) {
                listing.setFulfillmentMethod(value);
            }
        }
    }

    private static String sanitizeText(String value) {
        return value == null ? "" : value.trim();
    }

    private static String sanitizeMetaValue(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("\r", " ").replace("\n", " ").trim();
    }
}
