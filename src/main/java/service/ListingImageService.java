package service;

import java.util.ArrayList;
import java.util.List;

import dao.ListingImageDAO;
import model.ListingImage;

public class ListingImageService {

    private final ListingImageDAO listingImageDAO;

    public ListingImageService() {
        this.listingImageDAO = new ListingImageDAO();
    }

    public List<ListingImage> getImagesByListingId(int listingId) {
        return listingImageDAO.getImagesByListingId(listingId);
    }

    public List<String> getImageUrlsByListingId(int listingId) {
        List<ListingImage> images = listingImageDAO.getImagesByListingId(listingId);
        List<String> urls = new ArrayList<>();

        for (ListingImage image : images) {
            if (image.getImageUrl() != null && !image.getImageUrl().trim().isEmpty()) {
                urls.add(image.getImageUrl());
            }
        }

        return urls;
    }

    public String getPrimaryImageUrlByListingId(int listingId) {
        return listingImageDAO.getPrimaryImageUrlByListingId(listingId);
    }
}