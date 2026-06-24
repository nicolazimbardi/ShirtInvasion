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

        // Recupero parametri
        String nome = request.getParameter("nome");
        String cognome = request.getParameter("cognome");
        String telefono = request.getParameter("telefono");
        

        // Aggiornamento dati anagrafici
        utenteSessione.setNome(nome);
        utenteSessione.setCognome(cognome);
        utenteSessione.setTelefono(telefono);
       

        // Salvataggio nel Database
        UtenteDAO utenteDAO = new UtenteDAO();
        if (utenteDAO.doUpdate(utenteSessione)) {
            session.setAttribute("utente", utenteSessione);
            response.sendRedirect("ProfiloServlet?success=1");
        } else {
            response.sendRedirect("ProfiloServlet?error=1");
        }
    }
}