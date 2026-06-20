package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.UtenteDAO;
import model.Utente;

@WebServlet("/RegistrazioneServlet")
public class RegistrazioneServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/registrazione.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        
        String nome = request.getParameter("nome");
        String cognome = request.getParameter("cognome");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String indirizzo = request.getParameter("indirizzo");
        String telefono = request.getParameter("telefono");

        Utente nuovoUtente = new Utente();
        nuovoUtente.setNome(nome);
        nuovoUtente.setCognome(cognome);
        nuovoUtente.setEmail(email);
        nuovoUtente.setPassword(password);
        nuovoUtente.setIndirizzo(indirizzo);
        nuovoUtente.setTelefono(telefono);
        nuovoUtente.setRuolo("CLIENTE");  

        UtenteDAO utenteDao = new UtenteDAO();
        
        boolean salvato = utenteDao.doSave(nuovoUtente);

        if (salvato) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
        } else {
            request.setAttribute("messaggioErrore", "Errore durante la registrazione. Riprova con un'altra email.");
            request.getRequestDispatcher("/WEB-INF/views/registrazione.jsp").forward(request, response);
        }
    }
}
