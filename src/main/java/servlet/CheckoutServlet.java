package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Listing;
import service.ListingService;

@WebServlet("/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ListingService listingService = new ListingService();

    public CheckoutServlet() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Require login before entering checkout
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/views/Login.jsp");
            return;
        }

        String listingIdParam = request.getParameter("listingId");

        if (listingIdParam == null || listingIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/BrowseServlet");
            return;
        }

        try {
            int listingId = Integer.parseInt(listingIdParam);
            Listing listing = listingService.getListingById(listingId);

            if (listing == null) {
                response.sendRedirect(request.getContextPath() + "/BrowseServlet");
                return;
            }

            request.setAttribute("listing", listing);
            request.getRequestDispatcher("/views/Checkout.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/BrowseServlet");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/BrowseServlet");
        }
    }
}