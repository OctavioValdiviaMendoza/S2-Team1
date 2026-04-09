package servlet;

import java.io.IOException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;



import model.User;

@WebServlet("/SignupServlet")
public class SignupServlet extends HttpServlet{
	private static final long serialVersionUID = 1L;
	
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
		
        User user = new User();
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setEmail(email);
        user.setPhoneNumber(phoneNumber);
        user.setGovId(govId);
        //NEED TO HASH
        user.setPasswordHash(password);
        
        //NEED TO CALL DAO
        
        response.sendRedirect(request.getContextPath() + "/views/Login.jsp");        
	} 
	
	
	
	
}
