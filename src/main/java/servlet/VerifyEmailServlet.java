package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.UserDAO;
import model.User;

@WebServlet("/VerifyEmailServlet")
public class VerifyEmailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private UserDAO userDAO = new UserDAO();

    public VerifyEmailServlet() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String token = request.getParameter("token");

        if (token == null || token.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Invalid verification link.");
            request.getRequestDispatcher("/views/Login.jsp").forward(request, response);
            return;
        }

        User user = userDAO.getUserByVerificationToken(token);

        if (user == null) {
            request.setAttribute("errorMessage", "Invalid or expired verification link.");
            request.getRequestDispatcher("/views/Login.jsp").forward(request, response);
            return;
        }

        if (user.isVerifiedStatus()) {
            request.setAttribute("successMessage", "Your account is already verified. Please log in.");
            request.getRequestDispatcher("/views/Login.jsp").forward(request, response);
            return;
        }

        boolean verified = userDAO.verifyUser(token);

        if (verified) {
            request.setAttribute("successMessage", "Email verified successfully. You can now log in.");
        } else {
            request.setAttribute("errorMessage", "Verification failed. Please try again.");
        }

        request.getRequestDispatcher("/views/Login.jsp").forward(request, response);
    }
}
