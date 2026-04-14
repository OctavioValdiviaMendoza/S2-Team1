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

@WebServlet("/SettingsServlet")
public class SettingsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public SettingsServlet() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("views/Login.jsp");
            return;
        }
        
        int userId = (int) session.getAttribute("userId");
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "profile";
        }
        
        try {
            switch(action) {
                case "profile":
                    loadProfileSettings(userId, request, response);
                    break;
                case "listings":
                    loadUserListings(userId, request, response);
                    break;
                case "requests":
                    loadRentalRequests(userId, request, response);
                    break;
                default:
                    loadProfileSettings(userId, request, response);
            }
        } catch(Exception e) {
            System.out.println("Error in SettingsServlet: " + e);
            request.setAttribute("error", "An error occurred while loading settings");
            request.getRequestDispatcher("views/Settings.jsp").forward(request, response);
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
            switch(action) {
                case "changePassword":
                    handleChangePassword(userId, request, response);
                    break;
                case "deleteAccount":
                    handleDeleteAccount(userId, request, response);
                    break;
                case "acceptRequest":
                    handleAcceptRequest(request, response);
                    break;
                case "denyRequest":
                    handleDenyRequest(request, response);
                    break;
                default:
                    response.sendRedirect("SettingsServlet?action=profile&error=Invalid action");
            }
        } catch(Exception e) {
            System.out.println("Error in SettingsServlet POST: " + e);
            response.sendRedirect("SettingsServlet?action=profile&error=An error occurred");
        }
    }
    
    private void loadProfileSettings(int userId, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User user = UserService.getUserById(userId);
        String paymentMethod = UserService.getPaymentMethod(userId);
        
        request.setAttribute("user", user);
        request.setAttribute("paymentMethod", paymentMethod);
        request.setAttribute("verificationStatus", user != null && user.isVerifiedStatus() ? "Verified" : "Not Verified");
        request.getRequestDispatcher("views/Settings.jsp").forward(request, response);
    }
    
    private void loadUserListings(int userId, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Listing> listings = ListingService.getListingsByUserId(userId);
        User user = UserService.getUserById(userId);
        
        request.setAttribute("user", user);
        request.setAttribute("listings", listings);
        request.setAttribute("activeTab", "listings");
        request.getRequestDispatcher("views/Settings.jsp").forward(request, response);
    }
    
    private void loadRentalRequests(int userId, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Booking> pendingRequests = UserService.getPendingRentalRequests(userId);
        List<Booking> processedRequests = UserService.getProcessedRentalRequests(userId);
        User user = UserService.getUserById(userId);
        
        request.setAttribute("user", user);
        request.setAttribute("pendingRequests", pendingRequests);
        request.setAttribute("processedRequests", processedRequests);
        request.setAttribute("activeTab", "requests");
        request.getRequestDispatcher("views/Settings.jsp").forward(request, response);
    }
    
    private void handleChangePassword(int userId, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate inputs
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
        
        // Verify current password and update
        boolean success = UserService.changePassword(userId, currentPassword, newPassword);
        
        if (success) {
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
        
        boolean success = UserService.deleteAccount(userId);
        
        if (success) {
            HttpSession session = request.getSession();
            session.invalidate();
            response.sendRedirect("views/Login.jsp?message=Account deleted successfully");
        } else {
            request.setAttribute("error", "Failed to delete account. Please try again.");
            loadProfileSettings(userId, request, response);
        }
    }
    
    private void handleAcceptRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String bookingIdStr = request.getParameter("bookingId");
        
        if (bookingIdStr == null || bookingIdStr.isEmpty()) {
            response.sendRedirect("SettingsServlet?action=requests&error=Invalid booking");
            return;
        }
        
        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            boolean success = UserService.updateBookingStatus(bookingId, "confirmed");
            
            if (success) {
                response.sendRedirect("SettingsServlet?action=requests&message=Rental request accepted");
            } else {
                response.sendRedirect("SettingsServlet?action=requests&error=Failed to accept request");
            }
        } catch(NumberFormatException e) {
            response.sendRedirect("SettingsServlet?action=requests&error=Invalid booking ID");
        }
    }
    
    private void handleDenyRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String bookingIdStr = request.getParameter("bookingId");
        
        if (bookingIdStr == null || bookingIdStr.isEmpty()) {
            response.sendRedirect("SettingsServlet?action=requests&error=Invalid booking");
            return;
        }
        
        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            boolean success = UserService.updateBookingStatus(bookingId, "denied");
            
            if (success) {
                response.sendRedirect("SettingsServlet?action=requests&message=Rental request denied");
            } else {
                response.sendRedirect("SettingsServlet?action=requests&error=Failed to deny request");
            }
        } catch(NumberFormatException e) {
            response.sendRedirect("SettingsServlet?action=requests&error=Invalid booking ID");
        }
    }
}
