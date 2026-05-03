package servlet;

import model.Address;
import model.Listing;
import model.User;
import model.Category;
import service.AddressService;
import service.CategoryService;
import service.ListingService;
import service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@WebServlet("/CreateListingServlet")
public class CreateListingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final UserService userService = new UserService();
    private final CategoryService categoryService = new CategoryService();
    private final AddressService addressService = new AddressService();
    private final ListingService listingService = new ListingService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
            return;
        }

        loadFormData(request, session);
        
        String googleMapsApiKey = System.getenv("GOOGLE_MAPS_API_KEY");
        request.setAttribute("googleMapsApiKey", googleMapsApiKey);
        
        request.getRequestDispatcher("/views/CreateListing.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        String title = trim(request.getParameter("title"));
        String description = trim(request.getParameter("description"));
        String categoryIdStr = trim(request.getParameter("categoryId"));
        String priceStr = trim(request.getParameter("price"));
        String pricingUnit = trim(request.getParameter("pricingUnit"));
        String[] paymentMethods = request.getParameterValues("paymentMethods");
        String contactMethod = trim(request.getParameter("contactMethod"));
        String contactInfo = trim(request.getParameter("contactInfo"));
        String fulfillmentMethod = trim(request.getParameter("fulfillmentMethod"));
        String imageLinksRaw = trim(request.getParameter("imageLinks"));

        String addressChoice = trim(request.getParameter("addressChoice"));
        String addressIdStr = trim(request.getParameter("addressId"));

        String newLine1 = trim(request.getParameter("newLine1"));
        String newLine2 = trim(request.getParameter("newLine2"));
        String newCity = trim(request.getParameter("newCity"));
        String newState = trim(request.getParameter("newState"));
        String newZip = trim(request.getParameter("newZip"));
        String newAddressType = trim(request.getParameter("newAddressType"));
        String newIsDefaultStr = trim(request.getParameter("newIsDefault"));
        String newLatitudeStr = trim(request.getParameter("newLatitude"));
        String newLongitudeStr = trim(request.getParameter("newLongitude"));
        String newPlaceId = trim(request.getParameter("newPlaceId"));
    
        request.setAttribute("titleValue", title);
        request.setAttribute("descriptionValue", description);
        request.setAttribute("categoryIdValue", categoryIdStr);
        request.setAttribute("priceValue", priceStr);
        request.setAttribute("pricingUnitValue", pricingUnit);
        request.setAttribute("contactMethodValue", contactMethod);
        request.setAttribute("contactInfoValue", contactInfo);
        request.setAttribute("fulfillmentMethodValue", fulfillmentMethod);
        request.setAttribute("imageLinksValue", imageLinksRaw);
        request.setAttribute("selectedPaymentMethods", paymentMethods != null ? paymentMethods : new String[0]);

        request.setAttribute("addressChoiceValue", addressChoice);
        request.setAttribute("addressIdValue", addressIdStr);
        request.setAttribute("newLine1Value", newLine1);
        request.setAttribute("newLine2Value", newLine2);
        request.setAttribute("newCityValue", newCity);
        request.setAttribute("newStateValue", newState);
        request.setAttribute("newZipValue", newZip);
        request.setAttribute("newAddressTypeValue", newAddressType);
        request.setAttribute("newIsDefaultValue", newIsDefaultStr);
        request.setAttribute("newLatitudeValue", newLatitudeStr);
        request.setAttribute("newLongitudeValue", newLongitudeStr);
        request.setAttribute("newPlaceIdValue", newPlaceId);
        String googleMapsApiKey = System.getenv("GOOGLE_MAPS_API_KEY");
        request.setAttribute("googleMapsApiKey", googleMapsApiKey);

        loadFormData(request, session);

        List<String> errorMessages = new ArrayList<>();
        Integer categoryId = null;
        Double price = null;
        Integer addressId = null;
        Float newLatitude = null;
        Float newLongitude = null;

        List<String> imageLinks = parseImageLinks(imageLinksRaw);

        if (title.isEmpty()) {
            errorMessages.add("Title is required.");
        }

        if (description.isEmpty()) {
            errorMessages.add("Description is required.");
        }

        if (categoryIdStr.isEmpty()) {
            errorMessages.add("Category is required.");
        } else {
            try {
                categoryId = Integer.parseInt(categoryIdStr);
            } catch (NumberFormatException e) {
                errorMessages.add("Choose a valid category.");
            }
        }

        if (priceStr.isEmpty()) {
            errorMessages.add("Price is required.");
        } else {
            try {
                price = Double.parseDouble(priceStr);
                if (price <= 0) {
                    errorMessages.add("Price must be greater than 0.");
                }
            } catch (NumberFormatException e) {
                errorMessages.add("Price must be a valid number.");
            }
        }

        if (pricingUnit.isEmpty()) {
            errorMessages.add("Select whether the rate is per day or per hour.");
        }

        if (paymentMethods == null || paymentMethods.length == 0) {
            errorMessages.add("Choose at least one accepted payment method.");
        }

        if (contactMethod.isEmpty()) {
            errorMessages.add("Preferred contact method is required.");
        }

        if (contactInfo.isEmpty()) {
            errorMessages.add("Contact info is required.");
        }

        if (fulfillmentMethod.isEmpty()) {
            errorMessages.add("Select pickup, drop-off, or either.");
        }

        if (imageLinks.isEmpty()) {
            errorMessages.add("Add at least one image link.");
        }

        for (String link : imageLinks) {
            if (!isValidImageUrl(link)) {
                errorMessages.add("Every image link must start with http:// or https://.");
                break;
            }
        }

        boolean usingNewAddress = "new".equals(addressChoice);

        if (usingNewAddress) {
            if (newLine1.isEmpty()) {
                errorMessages.add("Address line 1 is required for a new address.");
            }
            if (newCity.isEmpty()) {
                errorMessages.add("City is required for a new address.");
            }
            if (newState.isEmpty()) {
                errorMessages.add("State is required for a new address.");
            }
            if (newZip.isEmpty()) {
                errorMessages.add("ZIP code is required for a new address.");
            }

            if (!newLatitudeStr.isEmpty()) {
                try {
                    newLatitude = Float.parseFloat(newLatitudeStr);
                } catch (NumberFormatException e) {
                    errorMessages.add("Latitude is invalid.");
                }
            }

            if (!newLongitudeStr.isEmpty()) {
                try {
                    newLongitude = Float.parseFloat(newLongitudeStr);
                } catch (NumberFormatException e) {
                    errorMessages.add("Longitude is invalid.");
                }
            }
        } else {
            if (addressIdStr.isEmpty()) {
                errorMessages.add("Select an existing pickup address or choose to add a new one.");
            } else {
                try {
                    addressId = Integer.parseInt(addressIdStr);

                    if (!addressService.addressBelongsToUser(addressId, userId)) {
                        errorMessages.add("Choose a valid address for your account.");
                    }
                } catch (NumberFormatException e) {
                    errorMessages.add("Choose a valid address.");
                }
            }
        }

        if (!errorMessages.isEmpty()) {
            request.setAttribute("errorMessages", errorMessages);
            request.getRequestDispatcher("/views/CreateListing.jsp").forward(request, response);
            return;
        }
        
        System.out.println("DEBUG newLatitudeStr = " + newLatitudeStr);
        System.out.println("DEBUG newLongitudeStr = " + newLongitudeStr);
        System.out.println("DEBUG newPlaceId = " + newPlaceId);

        Listing listing = new Listing();
        listing.setUserId(userId);
        listing.setCategoryId(categoryId);
        listing.setTitle(title);
        listing.setDescription(description);
        listing.setPrice(price);
        listing.setAvailability(true);
        listing.setPricingUnit(pricingUnit);
        listing.setAcceptedPaymentMethods(String.join(", ", paymentMethods));
        listing.setContactMethod(contactMethod);
        listing.setContactInfo(contactInfo);
        listing.setFulfillmentMethod(fulfillmentMethod);

        int listingId;

        if (usingNewAddress) {
            Address newAddress = new Address();
            newAddress.setUserId(userId);
            newAddress.setLine1(newLine1);
            newAddress.setLine2(newLine2);
            newAddress.setCity(newCity);
            newAddress.setState(newState);
            newAddress.setZip(newZip);
            newAddress.setType(newAddressType.isEmpty() ? "pickup" : newAddressType);
            newAddress.setDefault("true".equalsIgnoreCase(newIsDefaultStr) || "on".equalsIgnoreCase(newIsDefaultStr));

            if (newLatitude != null) {
                newAddress.setLatitude(newLatitude);
            }

            if (newLongitude != null) {
                newAddress.setLongitude(newLongitude);
            }

            newAddress.setPlaceId(newPlaceId);

            listingId = listingService.createListingWithNewAddress(listing, imageLinks, newAddress);
        } else {
            listing.setAddressId(addressId);
            listingId = listingService.createListing(listing, imageLinks);
        }

        if (listingId <= 0) {
            request.setAttribute("errorMessages",
                    Arrays.asList("The listing could not be created. Please try again."));
            request.getRequestDispatcher("/views/CreateListing.jsp").forward(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/ListingDetailServlet?listingId=" + listingId);
    }

    private void loadFormData(HttpServletRequest request, HttpSession session) {
        List<Category> categories = categoryService.getAllCategories();
        request.setAttribute("categories", categories);

        User currentUser = null;
        Object userObj = session.getAttribute("user");
        Integer userId = (Integer) session.getAttribute("userId");

        if (userObj instanceof User) {
            currentUser = (User) userObj;
        } else if (userId != null) {
            currentUser = userService.getUserById(userId);
        }

        request.setAttribute("currentUser", currentUser);

        if (userId != null) {
            request.setAttribute("userAddresses", addressService.getAddressesByUserId(userId));
        }
    }

    private List<String> parseImageLinks(String raw) {
        List<String> imageLinks = new ArrayList<>();

        if (raw == null || raw.trim().isEmpty()) {
            return imageLinks;
        }

        String[] pieces = raw.split("\\r?\\n");
        for (String piece : pieces) {
            String link = trim(piece);
            if (!link.isEmpty() && !imageLinks.contains(link)) {
                imageLinks.add(link);
            }
        }

        return imageLinks;
    }

    private boolean isValidImageUrl(String value) {
        return value.startsWith("http://") || value.startsWith("https://");
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}