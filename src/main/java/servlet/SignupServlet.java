package servlet;

import java.io.IOException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.UUID;

import service.UserService;
import model.User;
import dao.UserDAO;
import service.EmailService;

@WebServlet("/SignupServlet")
public class SignupServlet extends HttpServlet{
	private static final long serialVersionUID = 1L;
	
	private UserService userService = new UserService();
	private UserDAO userDAO = new UserDAO();
	private EmailService emailService = new EmailService();
	public SignupServlet() {
		super();
	}
	
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		
		String firstName = request.getParameter("firstName");
		String lastName = request.getParameter("lastName");
		String email = request.getParameter("email");
		String phoneNumber = request.getParameter("phoneNumber");
        String govId = request.getParameter("govId");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match.");
            request.getRequestDispatcher("/views/SignUp.jsp").forward(request, response);
            return;
        }
        
        String hashedPassword = userService.hashPassword(password);
        
        String verificationToken = UUID.randomUUID().toString();
		
        User user = new User();
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setEmail(email);
        user.setPhoneNumber(phoneNumber);
        user.setGovId(govId);
        
        user.setVerificationToken(verificationToken);
        user.setVerifiedStatus(false);
        
        user.setPasswordHash(hashedPassword);
        
        boolean inserted = userDAO.insertUser(user);
        
        if(!inserted) {
        		request.setAttribute("errorMessage", "Signup failed. Please try again.");
        		request.getRequestDispatcher(request.getContextPath() + "/views/SignUp.jsp").forward(request,response);
        		return;
        	
        }
        String appUrl = request.getScheme() + "://" 
                + request.getServerName() 
                + ":" + request.getServerPort() 
                + request.getContextPath();

        String verificationLink = appUrl + "/VerifyEmailServlet?token=" + verificationToken;
        
        boolean emailSent = emailService.sendVerificationEmail(email, firstName, verificationLink);
        
        if (!emailSent) {
            request.setAttribute("errorMessage",
                    "Account created, but verification email could not be sent.");
            request.getRequestDispatcher("/views/Login.jsp").forward(request, response);
            return;
        }
        
        request.setAttribute("successMessage",
                "Account created successfully. Please check your email to verify your account.");
        request.getRequestDispatcher("/views/Login.jsp").forward(request, response);
        
        
        response.sendRedirect(request.getContextPath() + "/views/Login.jsp");        
	} 
	
	
	
	
}
