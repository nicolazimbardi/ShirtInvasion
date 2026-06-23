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

@WebServlet("/AggiornaProfiloServlet")
public class AggiornaProfiloServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        Utente utenteSessione = (Utente) session.getAttribute("utente"); 
        
        if (utenteSessione == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        String nome = request.getParameter("nome");
        String cognome = request.getParameter("cognome");
        String email = request.getParameter("email");
        String telefono = request.getParameter("telefono");
        String password = request.getParameter("password");

        utenteSessione.setNome(nome);
        utenteSessione.setCognome(cognome);
        utenteSessione.setEmail(email);
        utenteSessione.setTelefono(telefono);
        
        if (password != null && !password.trim().isEmpty()) {
            utenteSessione.setPassword(password);
        }

        UtenteDAO utenteDAO = new UtenteDAO();
        boolean aggiornato = utenteDAO.doUpdate(utenteSessione);

        if (aggiornato) {
            session.setAttribute("utente", utenteSessione);
            // Reindirizziamo alla Servlet, non al file JSP
            response.sendRedirect("ProfiloServlet?success=1");
        } else {
            response.sendRedirect("ProfiloServlet?error=1");
        }
    }
}