package servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import dao.LogDAO;
import model.Log;

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private LogDAO logDAO = new LogDAO(); // you will create this

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/views/Login.jsp");
            return;
        }

    
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");

        if (isAdmin == null || !isAdmin) {
            response.sendRedirect(request.getContextPath() + "/BrowseServlet");
            return;
        }

       
        List<Log> logs = logDAO.getTop30Logs();

      
        request.setAttribute("logs", logs);

        
        request.getRequestDispatcher("/views/Admin.jsp").forward(request, response);
    }
}