package service;

import dao.ListingPreferenceDAO;
import model.ListingPreference;

public class ListingPreferenceService {

    private final ListingPreferenceDAO listingPreferenceDAO;

    public ListingPreferenceService() {
        this.listingPreferenceDAO = new ListingPreferenceDAO();
    }

    public boolean createListingPreference(ListingPreference preference) {

        if (preference == null) {
            return false;
        }

        if (preference.getListingId() <= 0) {
            return false;
        }

        return listingPreferenceDAO.createListingPreference(preference);
    }

    public ListingPreference getListingPreferenceByListingId(int listingId) {

        if (listingId <= 0) {
            return null;
        }

        return listingPreferenceDAO.getListingPreferenceByListingId(listingId);
    }

    public boolean updateListingPreference(ListingPreference preference) {

        if (preference == null) {
            return false;
        }

        if (preference.getListingId() <= 0) {
            return false;
        }

        return listingPreferenceDAO.updateListingPreference(preference);
    }

    public boolean deleteListingPreferenceByListingId(int listingId) {

        if (listingId <= 0) {
            return false;
        }

        return listingPreferenceDAO.deleteListingPreferenceByListingId(listingId);
    }
}