package model;

public class ListingImage {
    private int imageId;
    private int listingId;
    private String imageUrl;

    public ListingImage() {
    }

    public ListingImage(int imageId, int listingId, String imageUrl) {
        this.imageId = imageId;
        this.listingId = listingId;
        this.imageUrl = imageUrl;
    }

    public int getImageId() {
        return imageId;
    }

    public void setImageId(int imageId) {
        this.imageId = imageId;
    }

    public int getListingId() {
        return listingId;
    }

    public void setListingId(int listingId) {
        this.listingId = listingId;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
}