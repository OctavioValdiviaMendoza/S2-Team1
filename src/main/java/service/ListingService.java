package service;

import java.util.List;

import dao.ListingDAO;
import model.Address;
import model.Listing;

public class ListingService {

    private final ListingDAO listingDAO;
    private final CategoryService categoryService;
    private final AddressService addressService;
    private final ListingImageService listingImageService;

    public ListingService() {
        this.listingDAO = new ListingDAO();
        this.categoryService = new CategoryService();
        this.addressService = new AddressService();
        this.listingImageService = new ListingImageService();
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

        if (!addressService.addressBelongsToUser(listing.getAddressId(), listing.getUserId())) {
            return -1;
        }

        return listingDAO.createListing(listing, imageUrls);
    }

    public int createListingWithNewAddress(Listing listing, List<String> imageUrls, Address newAddress) {
        if (listing == null || newAddress == null) {
            return -1;
        }

        newAddress.setUserId(listing.getUserId());

        if (newAddress.getType() == null || newAddress.getType().trim().isEmpty()) {
            newAddress.setType("pickup");
        }

        int newAddressId = addressService.createAddress(newAddress);
        if (newAddressId <= 0) {
            return -1;
        }

        listing.setAddressId(newAddressId);
        return listingDAO.createListing(listing, imageUrls);
    }

    public boolean updateListing(Listing listing, List<String> imageUrls) {
        if (listing == null) {
            return false;
        }

        if (!addressService.addressBelongsToUser(listing.getAddressId(), listing.getUserId())) {
            return false;
        }

        return listingDAO.updateListing(listing, imageUrls);
    }

    public boolean deleteListing(int listingId, int userId) {
        return listingDAO.deleteListing(listingId, userId);
    }

    public List<String> getImageUrlsByListingId(int listingId) {
        return listingImageService.getImageUrlsByListingId(listingId);
    }

    public String getPrimaryImageUrlByListingId(int listingId) {
        return listingImageService.getPrimaryImageUrlByListingId(listingId);
    }

    public void enrichListing(Listing listing) {
        if (listing == null) {
            return;
        }

        listing.setCategoryName(categoryService.getCategoryNameById(listing.getCategoryId()));
        listing.setImageUrl(listingImageService.getPrimaryImageUrlByListingId(listing.getListingId()));

        Address address = addressService.getAddressById(listing.getAddressId());
        if (address != null) {
            listing.setLocation(formatAddress(address));
        }
    }

    public void enrichListings(List<Listing> listings) {
        if (listings == null || listings.isEmpty()) {
            return;
        }

        for (Listing listing : listings) {
            enrichListing(listing);
        }
    }

    private String formatAddress(Address address) {
        StringBuilder sb = new StringBuilder();

        if (address.getLine1() != null && !address.getLine1().trim().isEmpty()) {
            sb.append(address.getLine1().trim());
        }

        if (address.getLine2() != null && !address.getLine2().trim().isEmpty()) {
            if (sb.length() > 0) {
                sb.append(", ");
            }
            sb.append(address.getLine2().trim());
        }

        if (address.getCity() != null && !address.getCity().trim().isEmpty()) {
            if (sb.length() > 0) {
                sb.append(", ");
            }
            sb.append(address.getCity().trim());
        }

        if (address.getState() != null && !address.getState().trim().isEmpty()) {
            if (sb.length() > 0) {
                sb.append(", ");
            }
            sb.append(address.getState().trim());
        }

        if (address.getZip() != null && !address.getZip().trim().isEmpty()) {
            sb.append(" ").append(address.getZip().trim());
        }

        return sb.toString();
    }
}