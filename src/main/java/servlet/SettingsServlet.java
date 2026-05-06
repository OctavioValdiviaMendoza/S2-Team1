package servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.annotation.WebServlet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.User;
import model.Listing;
import model.Booking;

import service.UserService;
import service.ListingService;
import service.EmailService;
import service.BookingService;
import dao.LogDAO;


@WebServlet("/SettingsServlet")
public class SettingsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private UserService userService = new UserService();
    private ListingService listingService = new ListingService();
    private LogDAO logDAO = new LogDAO();
    private EmailService emailService = new EmailService();
    private BookingService bookingService = new BookingService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("views/Login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String action = request.getParameter("action");

        if (action == null || action.isEmpty()) {
            action = "profile";
        }

        try {
            switch (action) {
                case "profile":
                    loadProfileSettings(userId, request, response);
                    break;
                case "listings":
                    loadUserListings(userId, request, response);
                    break;
                case "requests":
                    loadRentalRequests(userId, request, response);
                    break;
                case "rentings":
                    loadUserRentings(userId, request, response);
                    break;
                default:
                    loadProfileSettings(userId, request, response);
                    break;
            }
        } catch (Exception e) {
            System.out.println("Error in SettingsServlet: " + e);
            request.setAttribute("error", "An error occurred while loading settings");
            loadProfileSettings(userId, request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("views/Login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String action = request.getParameter("action");

        try {
            switch (action) {
                case "changePassword":
                    handleChangePassword(userId, request, response);
                    break;
                case "deleteAccount":
                    handleDeleteAccount(userId, request, response);
                    break;
                case "acceptRequest":
                    handleAcceptRequest(userId, request, response);
                    break;
                case "denyRequest":
                    handleDenyRequest(userId, request, response);
                    break;
                case "completeRequest":
                    handleCompleteRequest(userId, request, response);
                    break;
                default:
                    response.sendRedirect("SettingsServlet?action=profile&error=Invalid action");
                    break;
            }
        } catch (Exception e) {
            System.out.println("Error in SettingsServlet POST: " + e);
            response.sendRedirect("SettingsServlet?action=profile&error=An error occurred");
        }
    }

    private void loadCommonSettingsData(int userId, HttpServletRequest request) {
        User user = userService.getUserById(userId);
        String paymentMethod = UserService.getPaymentMethod(userId);
        List<Listing> listings = listingService.getListingsByUserId(userId);
        List<Booking> pendingRequests = UserService.getPendingRentalRequests(userId);
        List<Booking> processedRequests = UserService.getProcessedRentalRequests(userId);
        List<Booking> renterBookings = UserService.getRenterBookings(userId);
        
        request.setAttribute("user", user);
        request.setAttribute("paymentMethod", paymentMethod);
        request.setAttribute("verificationStatus",
                user != null && user.isVerifiedStatus() ? "Verified" : "Not Verified");
        request.setAttribute("listings", listings);
        request.setAttribute("pendingRequests", pendingRequests);
        request.setAttribute("processedRequests", processedRequests);
        request.setAttribute("renterBookings", renterBookings);
    }

    private void loadProfileSettings(int userId, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        loadCommonSettingsData(userId, request);
        request.setAttribute("activeTab", "profile");
        request.getRequestDispatcher("views/Settings.jsp").forward(request, response);
    }

    private void loadUserListings(int userId, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        loadCommonSettingsData(userId, request);
        request.setAttribute("activeTab", "listings");
        request.getRequestDispatcher("views/Settings.jsp").forward(request, response);
    }
    
    private void loadUserRentings(int userId, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        loadCommonSettingsData(userId, request);
        request.setAttribute("activeTab", "rentings");
        request.getRequestDispatcher("views/Settings.jsp").forward(request, response);
    }
    
    private void loadRentalRequests(int userId, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        loadCommonSettingsData(userId, request);
        request.setAttribute("activeTab", "requests");
        request.getRequestDispatcher("views/Settings.jsp").forward(request, response);
    }
    
    
    private void handleChangePassword(int userId, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (currentPassword == null || currentPassword.isEmpty() ||
            newPassword == null || newPassword.isEmpty() ||
            confirmPassword == null || confirmPassword.isEmpty()) {

            request.setAttribute("error", "All password fields are required");
            loadProfileSettings(userId, request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "New passwords do not match");
            loadProfileSettings(userId, request, response);
            return;
        }

        if (newPassword.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters");
            loadProfileSettings(userId, request, response);
            return;
        }

        boolean success = userService.changePassword(userId, currentPassword, newPassword);

        if (success) {
        		logDAO.addLog(userId, "UPDATED_PASSWORD", "password has been changed");
            request.setAttribute("message", "Password changed successfully");
        } else {
            request.setAttribute("error", "Current password is incorrect");
        }

        loadProfileSettings(userId, request, response);
    }

    private void handleDeleteAccount(int userId, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String confirmDelete = request.getParameter("confirmDelete");

        if (confirmDelete == null || !confirmDelete.equals("yes")) {
            request.setAttribute("error", "Please confirm account deletion");
            loadProfileSettings(userId, request, response);
            return;
        }

        logDAO.addLog(userId, "DELETED_ACCOUNT", "Account has been removed from Database");
        boolean success = UserService.deleteAccount(userId);

        if (success) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect("views/Login.jsp?message=Account deleted successfully");
        } else {
            request.setAttribute("error", "Failed to delete account. Please try again.");
            loadProfileSettings(userId, request, response);
        }
    }

    private void handleAcceptRequest(int userId, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String bookingIdStr = request.getParameter("bookingId");

        if (bookingIdStr == null || bookingIdStr.isEmpty()) {
            response.sendRedirect("SettingsServlet?action=requests&error=Invalid booking");
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdStr);

            Booking booking = UserService.getBookingById(bookingId);

            if (booking == null) {
                response.sendRedirect("SettingsServlet?action=requests&error=Booking not found");
                return;
            }

            if (bookingService.hasOverlappingConfirmedBooking(booking)) {
                response.sendRedirect("SettingsServlet?action=requests&error=Another booking is already confirmed for those dates");
                return;
            }

            boolean success = UserService.updateBookingStatus(bookingId, userId, "confirmed");

            if (success) {
                List<Integer> deniedBookingIds = bookingService.getOverlappingPendingBookingIds(booking);
                bookingService.denyBookingsByIds(deniedBookingIds);

                User acceptedRenter = userService.getUserById(booking.getUserId());

                if (acceptedRenter != null && acceptedRenter.getEmail() != null) {
                    emailService.sendBookingDecisionEmail(acceptedRenter, booking, "confirmed");
                }

                for (Integer deniedBookingId : deniedBookingIds) {
                    Booking deniedBooking = UserService.getBookingById(deniedBookingId);

                    if (deniedBooking != null) {
                        User deniedRenter = userService.getUserById(deniedBooking.getUserId());

                        if (deniedRenter != null && deniedRenter.getEmail() != null) {
                            emailService.sendBookingDecisionEmail(deniedRenter, deniedBooking, "denied");
                        }
                    }
                }

                response.sendRedirect("SettingsServlet?action=requests&message=Rental request accepted. Overlapping pending requests were denied.");
            } else {
                response.sendRedirect("SettingsServlet?action=requests&error=Failed to accept request");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect("SettingsServlet?action=requests&error=Invalid booking ID");
        }
    }

    private void handleDenyRequest(int userId, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String bookingIdStr = request.getParameter("bookingId");

        if (bookingIdStr == null || bookingIdStr.isEmpty()) {
            response.sendRedirect("SettingsServlet?action=requests&error=Invalid booking");
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            boolean success = UserService.updateBookingStatus(bookingId, userId, "denied");

            if (success) {
                Booking booking = UserService.getBookingById(bookingId);

                if (booking != null) {
                    User renter = userService.getUserById(booking.getUserId());

                    if (renter != null && renter.getEmail() != null) {
                        emailService.sendBookingDecisionEmail(renter, booking, "denied");
                    }
                }
                
                response.sendRedirect("SettingsServlet?action=requests&message=Rental request denied");
            } else {
                response.sendRedirect("SettingsServlet?action=requests&error=Failed to deny request");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("SettingsServlet?action=requests&error=Invalid booking ID");
        }
    }

    private void handleCompleteRequest(int userId, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String bookingIdStr = request.getParameter("bookingId");

        if (bookingIdStr == null || bookingIdStr.isEmpty()) {
            response.sendRedirect("SettingsServlet?action=requests&error=Invalid booking");
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            boolean success = UserService.updateBookingStatus(bookingId, userId, "completed");

            if (success) {
                response.sendRedirect("SettingsServlet?action=requests&message=Rental marked completed");
            } else {
                response.sendRedirect("SettingsServlet?action=requests&error=Failed to complete rental");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("SettingsServlet?action=requests&error=Invalid booking ID");
        }
    }
}
