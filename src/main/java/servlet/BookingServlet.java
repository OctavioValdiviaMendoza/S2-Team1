package servlet;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Timestamp;
import java.time.LocalDate;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Listing;
import model.User;
import service.BookingService;
import service.EmailService;
import service.ListingService;
import service.UserService;
import dao.LogDAO;

@WebServlet("/BookingServlet")
public class BookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final BookingService bookingService = new BookingService();
    private final ListingService listingService = new ListingService();
    private final UserService userService = new UserService();
    private final EmailService emailService = new EmailService();
    private LogDAO logDAO = new LogDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/views/Login.jsp");
            return;
        }

        int renterUserId = (Integer) session.getAttribute("userId");

        String listingIdParam = request.getParameter("listingId");
        String startDateParam = request.getParameter("startDate");
        String endDateParam = request.getParameter("endDate");

        Integer listingId = parseInteger(listingIdParam);

        if (listingId == null) {
            redirectToBrowse(response, request, "Invalid listing.");
            return;
        }

        Listing listing = listingService.getListingById(listingId);

        if (listing == null) {
            redirectToBrowse(response, request, "Listing not found.");
            return;
        }

        if (listing.getUserId() == renterUserId) {
            redirectToListing(response, request, listingId, "You cannot book your own listing.");
            return;
        }

        if (startDateParam == null || startDateParam.trim().isEmpty()
                || endDateParam == null || endDateParam.trim().isEmpty()) {
            redirectToListing(response, request, listingId, "Start date and end date are required.");
            return;
        }

        Timestamp startTime;
        Timestamp endTime;

        try {
            LocalDate startDate = LocalDate.parse(startDateParam);
            LocalDate endDate = LocalDate.parse(endDateParam);

            if (!endDate.isAfter(startDate)) {
                redirectToListing(response, request, listingId, "End date must be after start date.");
                return;
            }

            startTime = Timestamp.valueOf(startDate.atStartOfDay());
            endTime = Timestamp.valueOf(endDate.atStartOfDay());

        } catch (Exception e) {
            redirectToListing(response, request, listingId, "Invalid booking dates.");
            return;
        }

        int bookingId = bookingService.createBookingRequest(listingId, renterUserId, startTime, endTime);

        if (bookingId <= 0) {
            logDAO.addLog(renterUserId, "FAILED_BOOKING", "Requested Booking for Item: " + listingId + "failed");
            redirectToListing(response, request, listingId, "Booking request could not be created.");
            return;
        }
        logDAO.addLog(renterUserId, "CREATE_BOOKING", "Requested Booking for Item: " + listingId);
        
        User owner = userService.getUserById(listing.getUserId());
        User renter = userService.getUserById(renterUserId);

        if (owner != null && owner.getEmail() != null && !owner.getEmail().trim().isEmpty()) {
            emailService.sendBookingRequestEmail(owner, renter, listing, startDateParam, endDateParam);
        }

        redirectToListing(response, request, listingId,
                "Booking request sent. Your request is awaiting owner approval.");
    }

    private Integer parseInteger(String value) {
        try {
            return value == null || value.trim().isEmpty() ? null : Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private void redirectToListing(HttpServletResponse response, HttpServletRequest request,
                                   int listingId, String message) throws IOException {
        String encodedMessage = URLEncoder.encode(message, StandardCharsets.UTF_8.name());
        response.sendRedirect(request.getContextPath()
                + "/ListingDetailServlet?listingId=" + listingId
                + "&message=" + encodedMessage);
    }

    private void redirectToBrowse(HttpServletResponse response, HttpServletRequest request,
                                  String message) throws IOException {
        String encodedMessage = URLEncoder.encode(message, StandardCharsets.UTF_8.name());
        response.sendRedirect(request.getContextPath()
                + "/BrowseServlet?error=" + encodedMessage);
    }
}