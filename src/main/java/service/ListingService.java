package service;

import java.util.List;

import dao.ListingDAO;
import model.Listing;

public class ListingService {

    private final ListingDAO listingDAO;
    private final CategoryService categoryService;

    public ListingService() {
        this.listingDAO = new ListingDAO();
        this.categoryService = new CategoryService();
    }

    public List<Listing> getAllListings() {
        List<Listing> listings = listingDAO.getAllListings();
        enrichListings(listings);
        return listings;
    }

    public Listing getListingById(int listingId) {
        Listing listing = listingDAO.getListingById(listingId);

        if (listing != null) {
            enrichListing(listing);
        }

        return listing;
    }

    public List<Listing> getListingsByUserId(int userId) {
        List<Listing> listings = listingDAO.getListingsByUserId(userId);
        enrichListings(listings);
        return listings;
    }

    public List<Listing> getListingsByCategory(int categoryId) {
        List<Listing> listings = listingDAO.getListingsByCategory(categoryId);
        enrichListings(listings);
        return listings;
    }

    public List<Listing> searchListings(String keyword) {
        List<Listing> listings = listingDAO.searchListings(keyword);
        enrichListings(listings);
        return listings;
    }

    public List<Listing> filterListings(Integer categoryId, String keyword, Double maxPrice) {
        List<Listing> listings = listingDAO.filterListings(categoryId, keyword, maxPrice);
        enrichListings(listings);
        return listings;
    }

    public int createListing(Listing listing, List<String> imageUrls) {
        if (listing == null) {
            return -1;
        }

        if (!listingDAO.addressBelongsToUser(listing.getAddressId(), listing.getUserId())) {
            return -1;
        }

        return listingDAO.createListing(listing, imageUrls);
    }

    public boolean updateListing(Listing listing, List<String> imageUrls) {
        if (listing == null) {
            return false;
        }

        if (!listingDAO.addressBelongsToUser(listing.getAddressId(), listing.getUserId())) {
            return false;
        }

        return listingDAO.updateListing(listing, imageUrls);
    }

    public boolean deleteListing(int listingId, int userId) {
        return listingDAO.deleteListing(listingId, userId);
    }

    public List<String> getImageUrlsByListingId(int listingId) {
        return listingDAO.getImageUrlsByListingId(listingId);
    }

    public String getPrimaryImageUrlByListingId(int listingId) {
        return listingDAO.getPrimaryImageUrlByListingId(listingId);
    }

    public void enrichListing(Listing listing) {
        if (listing == null) {
            return;
        }

        listing.setCategoryName(categoryService.getCategoryNameById(listing.getCategoryId()));
        listing.setImageUrl(listingDAO.getPrimaryImageUrlByListingId(listing.getListingId()));
    }

    public void enrichListings(List<Listing> listings) {
        if (listings == null || listings.isEmpty()) {
            return;
        }

        for (Listing listing : listings) {
            enrichListing(listing);
        }
    }
}