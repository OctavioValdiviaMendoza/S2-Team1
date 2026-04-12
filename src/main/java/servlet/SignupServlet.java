package servlet;

import java.io.IOException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import service.UserService;
import model.User;
import dao.UserDAO;

@WebServlet("/SignupServlet")
public class SignupServlet extends HttpServlet{
	private static final long serialVersionUID = 1L;
	
	private UserService userService = new UserService();
	private UserDAO userDAO = new UserDAO();
	
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
		
        User user = new User();
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setEmail(email);
        user.setPhoneNumber(phoneNumber);
        user.setGovId(govId);
        //need to set up verification
        user.setVerificationToken("");
        user.setVerifiedStatus(false);
        
        user.setPasswordHash(hashedPassword);
        System.out.println(hashedPassword);
        
        userDAO.insertUser(user);
        
        response.sendRedirect(request.getContextPath() + "/views/Login.jsp");        
	} 
	
	
	
	
}
