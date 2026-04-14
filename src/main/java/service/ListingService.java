package service;

import model.Listing;
import model.Category;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ListingService {

    public static List<Listing> getAllListings() {
        List<Listing> listings = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/valdiviamendoza?autoReconnect=true&useSSL=false",
                "root", "Mendoza_101!");

            String sql = "SELECT l.*, c.Category_Name, " +
                        "(SELECT image_url FROM ListingImages WHERE Listing_ID = l.Listing_ID LIMIT 1) as image_url, " +
                        "(SELECT CONCAT(City, ', ', State) FROM Addresses WHERE User_ID = l.User_ID AND Is_Default = true LIMIT 1) as location " +
                        "FROM Listings l " +
                        "LEFT JOIN Categories c ON l.Category_ID = c.Category_ID " +
                        "WHERE l.Availability = true " +
                        "ORDER BY l.Created_At DESC";

            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(sql);

            while(rs.next()) {
                Listing listing = new Listing(
                    rs.getInt("Listing_ID"),
                    rs.getInt("User_ID"),
                    rs.getInt("Category_ID"),
                    rs.getString("Title"),
                    rs.getString("Description"),
                    rs.getDouble("Price"),
                    rs.getTimestamp("Created_At"),
                    rs.getBoolean("Availability")
                );
                listing.setCategoryName(rs.getString("Category_Name"));
                listing.setImageUrl(rs.getString("image_url"));
                listing.setLocation(rs.getString("location"));
                listings.add(listing);
            }

            rs.close();
            stmt.close();
            con.close();
        } catch(Exception e) {
            System.out.println("Error fetching listings: " + e);
        }

        return listings;
    }

    public static List<Listing> getListingsByCategory(int categoryId) {
        List<Listing> listings = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/valdiviamendoza?autoReconnect=true&useSSL=false",
                "root", "Mendoza_101!");

            String sql = "SELECT l.*, c.Category_Name, " +
                        "(SELECT image_url FROM ListingImages WHERE Listing_ID = l.Listing_ID LIMIT 1) as image_url, " +
                        "(SELECT CONCAT(City, ', ', State) FROM Addresses WHERE User_ID = l.User_ID AND Is_Default = true LIMIT 1) as location " +
                        "FROM Listings l " +
                        "LEFT JOIN Categories c ON l.Category_ID = c.Category_ID " +
                        "WHERE l.Category_ID = ? AND l.Availability = true " +
                        "ORDER BY l.Created_At DESC";

            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, categoryId);
            ResultSet rs = pstmt.executeQuery();

            while(rs.next()) {
                Listing listing = new Listing(
                    rs.getInt("Listing_ID"),
                    rs.getInt("User_ID"),
                    rs.getInt("Category_ID"),
                    rs.getString("Title"),
                    rs.getString("Description"),
                    rs.getDouble("Price"),
                    rs.getTimestamp("Created_At"),
                    rs.getBoolean("Availability")
                );
                listing.setCategoryName(rs.getString("Category_Name"));
                listing.setImageUrl(rs.getString("image_url"));
                listing.setLocation(rs.getString("location"));
                listings.add(listing);
            }

            rs.close();
            pstmt.close();
            con.close();
        } catch(Exception e) {
            System.out.println("Error fetching listings by category: " + e);
        }

        return listings;
    }

    public static List<Listing> searchListings(String searchTerm) {
        List<Listing> listings = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/valdiviamendoza?autoReconnect=true&useSSL=false",
                "root", "Mendoza_101!");

            String sql = "SELECT l.*, c.Category_Name, " +
                        "(SELECT image_url FROM ListingImages WHERE Listing_ID = l.Listing_ID LIMIT 1) as image_url, " +
                        "(SELECT CONCAT(City, ', ', State) FROM Addresses WHERE User_ID = l.User_ID AND Is_Default = true LIMIT 1) as location " +
                        "FROM Listings l " +
                        "LEFT JOIN Categories c ON l.Category_ID = c.Category_ID " +
                        "WHERE (l.Title LIKE ? OR l.Description LIKE ?) AND l.Availability = true " +
                        "ORDER BY l.Created_At DESC";

            PreparedStatement pstmt = con.prepareStatement(sql);
            String searchPattern = "%" + searchTerm + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            ResultSet rs = pstmt.executeQuery();

            while(rs.next()) {
                Listing listing = new Listing(
                    rs.getInt("Listing_ID"),
                    rs.getInt("User_ID"),
                    rs.getInt("Category_ID"),
                    rs.getString("Title"),
                    rs.getString("Description"),
                    rs.getDouble("Price"),
                    rs.getTimestamp("Created_At"),
                    rs.getBoolean("Availability")
                );
                listing.setCategoryName(rs.getString("Category_Name"));
                listing.setImageUrl(rs.getString("image_url"));
                listing.setLocation(rs.getString("location"));
                listings.add(listing);
            }

            rs.close();
            pstmt.close();
            con.close();
        } catch(Exception e) {
            System.out.println("Error searching listings: " + e);
        }

        return listings;
    }

    public static Listing getListingById(int listingId) {
        Listing listing = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/valdiviamendoza?autoReconnect=true&useSSL=false",
                "root", "Mendoza_101!");

            String sql = "SELECT l.*, c.Category_Name, " +
                        "(SELECT image_url FROM ListingImages WHERE Listing_ID = l.Listing_ID LIMIT 1) as image_url, " +
                        "(SELECT CONCAT(City, ', ', State) FROM Addresses WHERE User_ID = l.User_ID AND Is_Default = true LIMIT 1) as location " +
                        "FROM Listings l " +
                        "LEFT JOIN Categories c ON l.Category_ID = c.Category_ID " +
                        "WHERE l.Listing_ID = ?";

            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, listingId);
            ResultSet rs = pstmt.executeQuery();

            if(rs.next()) {
                listing = new Listing(
                    rs.getInt("Listing_ID"),
                    rs.getInt("User_ID"),
                    rs.getInt("Category_ID"),
                    rs.getString("Title"),
                    rs.getString("Description"),
                    rs.getDouble("Price"),
                    rs.getTimestamp("Created_At"),
                    rs.getBoolean("Availability")
                );
                listing.setCategoryName(rs.getString("Category_Name"));
                listing.setImageUrl(rs.getString("image_url"));
                listing.setLocation(rs.getString("location"));
            }

            rs.close();
            pstmt.close();
            con.close();
        } catch(Exception e) {
            System.out.println("Error fetching listing by ID: " + e);
        }

        return listing;
    }

    public static List<Listing> getListingsByUserId(int userId) {
        List<Listing> listings = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/team1?autoReconnect=true&useSSL=false",
                "root", "Mendoza_101!");

            String sql = "SELECT l.*, c.category_name " +
                        "FROM listings l " +
                        "LEFT JOIN categories c ON l.category_id = c.category_id " +
                        "WHERE l.user_id = ? " +
                        "ORDER BY l.created_at DESC";

            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();

            while(rs.next()) {
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
        } catch(Exception e) {
            System.out.println("Error fetching listings by user ID: " + e);
        }

        return listings;
    }

    public static List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/valdiviamendoza?autoReconnect=true&useSSL=false",
                "root", "Mendoza_101!");

            String sql = "SELECT * FROM Categories ORDER BY Category_Name";
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(sql);

            while(rs.next()) {
                Category category = new Category(
                    rs.getInt("Category_ID"),
                    rs.getString("Category_Name")
                );
                categories.add(category);
            }

            rs.close();
            stmt.close();
            con.close();
        } catch(Exception e) {
            System.out.println("Error fetching categories: " + e);
        }

        return categories;
    }
}
