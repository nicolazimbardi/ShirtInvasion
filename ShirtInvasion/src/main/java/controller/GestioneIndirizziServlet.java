package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import dao.IndirizzoDAO;
import model.Indirizzo;
import model.Utente;

@WebServlet("/GestioneIndirizziServlet")
public class GestioneIndirizziServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utente utente = (Utente) session.getAttribute("utente");

        if (utente == null) {
            response.sendRedirect("LoginServlet");
            return;
        }

        String azione = request.getParameter("azione");
        IndirizzoDAO indDAO = new IndirizzoDAO();

        try {
            if ("aggiungi".equals(azione)) {
                // 1. Recupero i dati dal form
                String via = request.getParameter("via");
                String citta = request.getParameter("citta");
                String cap = request.getParameter("cap");
                String provincia = request.getParameter("provincia");
                String nazione = request.getParameter("nazione");

                // 2. Creo l'oggetto Indirizzo
                Indirizzo nuovoInd = new Indirizzo();
                nuovoInd.setIdUtente(utente.getIdUtente());
                nuovoInd.setVia(via);
                nuovoInd.setCitta(citta);
                nuovoInd.setCap(cap);
                nuovoInd.setProvincia(provincia);
                nuovoInd.setNazione(nazione);
                nuovoInd.setAttivo(false); // Di base non è il principale

                // 3. Salvo nel DB
                indDAO.doSave(nuovoInd);

            } else if ("attiva".equals(azione)) {
                int idIndirizzo = Integer.parseInt(request.getParameter("idIndirizzo"));
                
                // ECCO LA CORREZIONE: Ora richiama correttamente il metodo "impostaAttivo" del tuo DAO
                indDAO.impostaAttivo(idIndirizzo, utente.getIdUtente());

            } else if ("elimina".equals(azione)) {
                int idIndirizzo = Integer.parseInt(request.getParameter("idIndirizzo"));
                indDAO.doDelete(idIndirizzo);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("profilo.jsp?error=1");
            return;
        }

        // Ricarica la pagina del profilo mostrando le modifiche
        response.sendRedirect("ProfiloServlet");
    }
}