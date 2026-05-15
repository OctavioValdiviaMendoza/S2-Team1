package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.User;
import service.EmailService;
import service.UserService;
import dao.LogDAO;

@WebServlet("/ResendVerificationServlet")
public class ResendVerificationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserService userService = new UserService();
    private EmailService emailService = new EmailService();
    private LogDAO logDAO = new LogDAO();

    public ResendVerificationServlet() {
        super();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("User not logged in.");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        User user = userService.getUserById(userId);
        
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.getWriter().write("User not found.");
            return;
        }
        

        if (user.isVerifiedStatus()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Account is already verified.");
            return;
        }

        if (user.getVerificationToken() == null || user.getVerificationToken().trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("No verification token found.");
            return;
        }

        

        String appUrl = request.getScheme() + "://"
                + request.getServerName()
                + ":"
                + request.getServerPort()
                + request.getContextPath();

        String verificationLink = appUrl
                + "/VerifyEmailServlet?token="
                + user.getVerificationToken();

        boolean emailSent = emailService.sendVerificationEmail(
                user.getEmail(),
                user.getFirstName(),
                verificationLink
        );

        if (emailSent) {
        		logDAO.addLog(userId, "VERIFICATION_LINK_SENT", "User requested a verification email");
            response.getWriter().write("success");
        } else {
        		logDAO.addLog(userId, "VERIFICATION_LINK_NOT_SENT", "FAILED: user requested verifiation email");
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            
            response.getWriter().write("Failed to send verification email.");
        }
    }
}