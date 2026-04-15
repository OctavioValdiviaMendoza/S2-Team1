package service;

import model.Listing;
import model.Category;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import util.DBConnection;

public class ListingService {

   

public static List<Listing> getAllListings() {
    List<Listing> listings = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DBConnection.getConnection();

        String sql = "SELECT listing_id, user_id, category_id, title, description, price, created_at, availability " +
                     "FROM listings";

        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery(sql);

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

            listing.setCategoryName("Test");
            listing.setImageUrl(null);
            listing.setLocation("Test Location");

            listings.add(listing);
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

            String sql = "SELECT l.*, c.category_name, " +
                    "(SELECT image_url FROM listing_images WHERE listing_id = l.listing_id LIMIT 1) AS image_url, " +
                    "(SELECT CONCAT(city, ', ', state) FROM addresses WHERE user_id = l.user_id AND is_default = 1 LIMIT 1) AS location " +
                    "FROM listings l " +
                    "LEFT JOIN categories c ON l.category_id = c.category_id " +
                    "WHERE l.category_id = ? AND l.availability = 1 " +
                    "ORDER BY l.created_at DESC";

            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, categoryId);
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
                listing.setCategoryName(rs.getString("category_name"));
                listing.setImageUrl(rs.getString("image_url"));
                listing.setLocation(rs.getString("location"));
                listings.add(listing);
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

            String sql = "SELECT l.*, c.category_name, " +
                    "(SELECT image_url FROM listing_images WHERE listing_id = l.listing_id LIMIT 1) AS image_url, " +
                    "(SELECT CONCAT(city, ', ', state) FROM addresses WHERE user_id = l.user_id AND is_default = 1 LIMIT 1) AS location " +
                    "FROM listings l " +
                    "LEFT JOIN categories c ON l.category_id = c.category_id " +
                    "WHERE (l.title LIKE ? OR l.description LIKE ?) AND l.availability = 1 " +
                    "ORDER BY l.created_at DESC";

            PreparedStatement pstmt = con.prepareStatement(sql);
            String pattern = "%" + searchTerm + "%";
            pstmt.setString(1, pattern);
            pstmt.setString(2, pattern);
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
                listing.setCategoryName(rs.getString("category_name"));
                listing.setImageUrl(rs.getString("image_url"));
                listing.setLocation(rs.getString("location"));
                listings.add(listing);
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

            String sql = "SELECT l.*, c.category_name, " +
                    "(SELECT image_url FROM listing_images WHERE listing_id = l.listing_id LIMIT 1) AS image_url, " +
                    "(SELECT CONCAT(city, ', ', state) FROM addresses WHERE user_id = l.user_id AND is_default = 1 LIMIT 1) AS location " +
                    "FROM listings l " +
                    "LEFT JOIN categories c ON l.category_id = c.category_id " +
                    "WHERE l.listing_id = ?";

            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, listingId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                listing = new Listing(
                        rs.getInt("listing_id"),
                        rs.getInt("user_id"),
                        rs.getInt("category_id"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getDouble("price"),
                        rs.getTimestamp("created_at"),
                        rs.getBoolean("availability")
                );
                listing.setCategoryName(rs.getString("category_name"));
                listing.setImageUrl(rs.getString("image_url"));
                listing.setLocation(rs.getString("location"));
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
}