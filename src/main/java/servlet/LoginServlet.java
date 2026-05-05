package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.User;
import service.UserService;
import dao.LogDAO;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserService userService = new UserService();
    private LogDAO logDAO = new LogDAO();

    public LoginServlet() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/Login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {

            request.setAttribute("errorMessage", "Email and password are required.");
            request.getRequestDispatcher("/views/Login.jsp").forward(request, response);
            return;
        }

        User user = userService.authenticateUser(email.trim(), password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("isAdmin", user.getIsAdmin());
            
            if (user.getIsAdmin()) {
                response.sendRedirect(request.getContextPath() +"/AdminServlet");
            } else {
            	response.sendRedirect(request.getContextPath() + "/BrowseServlet");
            }
        } else {
        		request.setAttribute("errorMessage", "User Credentials Do Not Exist. Try again or Sign up.");
        		request.getRequestDispatcher("/views/Login.jsp").forward(request, response);
        }
    }
}