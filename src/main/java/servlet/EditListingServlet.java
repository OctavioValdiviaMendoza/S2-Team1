package servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Category;
import model.Listing;
import model.User;
import service.ListingService;
import service.UserService;
import service.CategoryService;

@WebServlet("/EditListingServlet")
public class EditListingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ListingService listingService = new ListingService();
    private CategoryService categoryService = new CategoryService();

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/views/Login.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        Integer listingId = parseListingId(request.getParameter("listingId"));
        if (listingId == null) {
            response.sendRedirect(request.getContextPath() + "/SettingsServlet?action=listings&error=Invalid listing");
            return;
        }

        Listing listing = listingService.getListingById(listingId);
        if (listing == null || listing.getUserId() != userId) {
            response.sendRedirect(request.getContextPath() + "/SettingsServlet?action=listings&error=You can only edit your own listings");
            return;
        }

        loadFormData(request, session);
        populateFormValues(request, listing, listingService.getImageUrlsByListingId(listingId));
        request.setAttribute("editMode", true);
        request.setAttribute("listingIdValue", String.valueOf(listingId));
        request.getRequestDispatcher("/views/CreateListing.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/views/Login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        Integer listingId = parseListingId(request.getParameter("listingId"));
        if (listingId == null) {
            response.sendRedirect(request.getContextPath() + "/SettingsServlet?action=listings&error=Invalid listing");
            return;
        }

        Listing existingListing = listingService.getListingById(listingId);
        if (existingListing == null || existingListing.getUserId() != userId) {
            response.sendRedirect(request.getContextPath() + "/SettingsServlet?action=listings&error=You can only edit your own listings");
            return;
        }

        String title = trim(request.getParameter("title"));
        String description = trim(request.getParameter("description"));
        String categoryId = trim(request.getParameter("categoryId"));
        String priceValue = trim(request.getParameter("price"));
        String pricingUnit = trim(request.getParameter("pricingUnit"));
        String[] paymentMethods = request.getParameterValues("paymentMethods");
        String contactMethod = trim(request.getParameter("contactMethod"));
        String contactInfo = trim(request.getParameter("contactInfo"));
        String fulfillmentMethod = trim(request.getParameter("fulfillmentMethod"));
        String imageLinksInput = trim(request.getParameter("imageLinks"));

        request.setAttribute("editMode", true);
        request.setAttribute("listingIdValue", String.valueOf(listingId));
        request.setAttribute("titleValue", title);
        request.setAttribute("descriptionValue", description);
        request.setAttribute("categoryIdValue", categoryId);
        request.setAttribute("priceValue", priceValue);
        request.setAttribute("pricingUnitValue", pricingUnit);
        request.setAttribute("contactMethodValue", contactMethod);
        request.setAttribute("contactInfoValue", contactInfo);
        request.setAttribute("fulfillmentMethodValue", fulfillmentMethod);
        request.setAttribute("imageLinksValue", imageLinksInput);
        request.setAttribute("selectedPaymentMethods", paymentMethods != null ? paymentMethods : new String[0]);

        loadFormData(request, session);

        List<String> validationErrors = new ArrayList<>();
        Integer parsedCategoryId = null;
        Double parsedPrice = null;
        List<String> imageLinks = parseImageLinks(imageLinksInput);

        if (title.isEmpty()) {
            validationErrors.add("Title is required.");
        }
        if (description.isEmpty()) {
            validationErrors.add("Description is required.");
        }
        if (categoryId.isEmpty()) {
            validationErrors.add("Category is required.");
        } else {
            try {
                parsedCategoryId = Integer.parseInt(categoryId);
            } catch (NumberFormatException e) {
                validationErrors.add("Choose a valid category.");
            }
        }
        if (priceValue.isEmpty()) {
            validationErrors.add("Price is required.");
        } else {
            try {
                parsedPrice = Double.parseDouble(priceValue);
                if (parsedPrice <= 0) {
                    validationErrors.add("Price must be greater than 0.");
                }
            } catch (NumberFormatException e) {
                validationErrors.add("Price must be a valid number.");
            }
        }
        if (pricingUnit.isEmpty()) {
            validationErrors.add("Select whether the rate is per day or per hour.");
        }
        if (paymentMethods == null || paymentMethods.length == 0) {
            validationErrors.add("Choose at least one accepted payment method.");
        }
        if (contactMethod.isEmpty()) {
            validationErrors.add("Preferred contact method is required.");
        }
        if (contactInfo.isEmpty()) {
            validationErrors.add("Contact info is required.");
        }
        if (fulfillmentMethod.isEmpty()) {
            validationErrors.add("Select pickup, drop-off, or either.");
        }
        if (imageLinks.isEmpty()) {
            validationErrors.add("Add at least one image link.");
        }

        for (String imageLink : imageLinks) {
            if (!isValidImageUrl(imageLink)) {
                validationErrors.add("Every image link must start with http:// or https://.");
                break;
            }
        }

        if (!validationErrors.isEmpty()) {
            request.setAttribute("errorMessages", validationErrors);
            request.getRequestDispatcher("/views/CreateListing.jsp").forward(request, response);
            return;
        }

        Listing listing = new Listing();
        listing.setListingId(listingId);
        listing.setUserId(userId);
        listing.setCategoryId(parsedCategoryId);
        listing.setTitle(title);
        listing.setDescription(description);
        listing.setPrice(parsedPrice);
        listing.setAvailability(existingListing.isAvailability());
        listing.setPricingUnit(pricingUnit);
        listing.setAcceptedPaymentMethods(String.join(", ", paymentMethods));
        listing.setContactMethod(contactMethod);
        listing.setContactInfo(contactInfo);
        listing.setFulfillmentMethod(fulfillmentMethod);

        boolean updated = listingService.updateListing(listing, imageLinks);
        if (!updated) {
            request.setAttribute("errorMessages", java.util.Arrays.asList("The listing could not be updated. Please try again."));
            request.getRequestDispatcher("/views/CreateListing.jsp").forward(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/ListingDetailServlet?listingId=" + listingId + "&message=Listing updated");
    }

    private void loadFormData(HttpServletRequest request, HttpSession session) {
        List<Category> categories = categoryService.getAllCategories();
        request.setAttribute("categories", categories);

        Object sessionUser = session.getAttribute("user");
        User user = sessionUser instanceof User ? (User) sessionUser : null;
        Integer userId = (Integer) session.getAttribute("userId");
        if (user == null && userId != null) {
            user = userService.getUserById(userId);
        }
        request.setAttribute("currentUser", user);
    }

    private void populateFormValues(HttpServletRequest request, Listing listing, List<String> imageUrls) {
        request.setAttribute("titleValue", listing.getTitle() != null ? listing.getTitle() : "");
        request.setAttribute("descriptionValue", listing.getDescription() != null ? listing.getDescription() : "");
        request.setAttribute("categoryIdValue", String.valueOf(listing.getCategoryId()));
        request.setAttribute("priceValue", String.valueOf(listing.getPrice()));
        request.setAttribute("pricingUnitValue", listing.getPricingUnit() != null ? listing.getPricingUnit() : "");
        request.setAttribute("contactMethodValue", listing.getContactMethod() != null ? listing.getContactMethod() : "");
        request.setAttribute("contactInfoValue", listing.getContactInfo() != null ? listing.getContactInfo() : "");
        request.setAttribute("fulfillmentMethodValue", listing.getFulfillmentMethod() != null ? listing.getFulfillmentMethod() : "");
        request.setAttribute("imageLinksValue", String.join("\n", imageUrls));
        request.setAttribute("selectedPaymentMethods", parsePaymentMethods(listing.getAcceptedPaymentMethods()));
    }

    private String[] parsePaymentMethods(String paymentMethods) {
        if (paymentMethods == null || paymentMethods.trim().isEmpty()) {
            return new String[0];
        }
        String[] parts = paymentMethods.split("\\s*,\\s*");
        for (int i = 0; i < parts.length; i++) {
            parts[i] = parts[i].trim().toLowerCase();
        }
        return parts;
    }

    private List<String> parseImageLinks(String imageLinksInput) {
        List<String> imageLinks = new ArrayList<>();
        if (imageLinksInput == null || imageLinksInput.trim().isEmpty()) {
            return imageLinks;
        }

        String[] rawLinks = imageLinksInput.split("\\r?\\n");
        for (String rawLink : rawLinks) {
            String normalizedLink = trim(rawLink);
            if (!normalizedLink.isEmpty() && !imageLinks.contains(normalizedLink)) {
                imageLinks.add(normalizedLink);
            }
        }

        return imageLinks;
    }

    private boolean isValidImageUrl(String value) {
        return value.startsWith("http://") || value.startsWith("https://");
    }

    private Integer parseListingId(String value) {
        try {
            return value == null || value.trim().isEmpty() ? null : Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
