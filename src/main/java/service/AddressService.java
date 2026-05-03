package service;

import java.util.List;

import dao.AddressDAO;
import model.Address;

public class AddressService {

    private final AddressDAO addressDAO;

    public AddressService() {
        this.addressDAO = new AddressDAO();
    }

    public List<Address> getAddressesByUserId(int userId) {
        return addressDAO.getAddressesByUserId(userId);
    }

    public Address getAddressById(int addressId) {
        return addressDAO.getAddressById(addressId);
    }

    public int createAddress(Address address) {
        if (address == null) {
            return -1;
        }

        if (address.getUserId() <= 0) {
            return -1;
        }

        if (isBlank(address.getLine1()) || isBlank(address.getCity())
                || isBlank(address.getState()) || isBlank(address.getZip())) {
            return -1;
        }

        if (address.getType() == null || address.getType().trim().isEmpty()) {
            address.setType("pickup");
        }

        return addressDAO.createAddress(address);
    }

    public boolean addressBelongsToUser(int addressId, int userId) {
        return addressDAO.addressBelongsToUser(addressId, userId);
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}