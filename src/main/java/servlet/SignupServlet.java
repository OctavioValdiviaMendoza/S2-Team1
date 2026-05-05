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
import dao.LogDAO;

@WebServlet("/SignupServlet")
public class SignupServlet extends HttpServlet{
	private static final long serialVersionUID = 1L;
	
	private UserService userService = new UserService();
	private UserDAO userDAO = new UserDAO();
	private EmailService emailService = new EmailService();
	private LogDAO logDAO = new LogDAO();
	
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
        
        
        //For Demo purposes fake id will be used and it is in the form of letter and 7 digits
        	//For example Y1234567
        if (govId == null || !govId.matches("^[A-Z]\\d{7}$")) {
            request.setAttribute("errorMessage", "Invalid California DL format (A1234567)");
            request.getRequestDispatcher("/views/SignUp.jsp").forward(request, response);
            return;
        }
        
        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match.");
            request.getRequestDispatcher("/views/SignUp.jsp").forward(request, response);
            return;
        }
        
        
        phoneNumber = phoneNumber.replaceAll("\\D", "");
        if (phoneNumber.length() != 10) {
            request.setAttribute("errorMessage", "Phone number must be 10 digits");
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
        		request.getRequestDispatcher("/views/SignUp.jsp").forward(request,response);
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
        
        int userId = userDAO.getUserByEmail(email).getUserId();
        logDAO.addLog(userId, "ACCOUNT_CREATED", "New account " + userId + " added to database");
        
        request.setAttribute("successMessage",
                "Account created successfully. Please check your email to verify your account.");
        response.sendRedirect(
        	    request.getContextPath() + "/views/Login.jsp?success=Account created successfully. Please check your email to verify your account."
        	);
        } 
	
	
	
	
}
