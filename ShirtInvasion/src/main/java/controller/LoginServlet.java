package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.UtenteDAO;
import model.Utente;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Mostra la pagina di login nascosta dentro WEB-INF
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    } 

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        UtenteDAO utenteDao = new UtenteDAO();
        Utente utenteLoggato = utenteDao.doRetrieveByEmailAndPassword(email, password);
        
        if (utenteLoggato != null) {
            HttpSession session = request.getSession();
            session.setAttribute("utente", utenteLoggato);
            
            if ("ADMIN".equals(utenteLoggato.getRuolo())) {
                response.sendRedirect(request.getContextPath() + "/AdminServlet");
            } else {
                response.sendRedirect(request.getContextPath() + "/");
            }
        }
        else {
            request.setAttribute("messaggioErrore", "Email o password errate!");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        }
    }
}