package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Utente;

@WebServlet("/ProfiloServlet")
public class ProfiloServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utente utente = (Utente) session.getAttribute("utente");
        
        if (utente == null) {
            response.sendRedirect("LoginServlet");
        } else {
            // Qui punta al file protetto in WEB-INF
            request.getRequestDispatcher("/WEB-INF/views/profilo.jsp").forward(request, response);
        }
    }
}