package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.ProdottoDAO;
import dao.OrdineDAO; // <--- NUOVO IMPORT FONDAMENTALE
import model.Carrello;
import model.Prodotto;

@WebServlet("/CarrelloServlet")
public class CarrelloServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Carrello carrello = (Carrello) session.getAttribute("carrello");
        if (carrello == null) {
            carrello = new Carrello();
            session.setAttribute("carrello", carrello);
        }
        
        String azione = request.getParameter("azione");
        ProdottoDAO prodottoDao = new ProdottoDAO();
        
        if (azione != null) {
            if (azione.equals("aggiungi")) {
                int id = Integer.parseInt(request.getParameter("id"));
                Prodotto p = prodottoDao.doRetrieveById(id);
                if (p != null) {
                    carrello.aggiungiProdotto(p);
                }
            } else if (azione.equals("rimuovi")) {
                int id = Integer.parseInt(request.getParameter("id"));
                carrello.rimuoviProdotto(id);
            } else if (azione.equals("svuota")) {
                carrello.svuota();
            } 
            // ================================================================
            // NUOVO BLOCCO: GESTIONE CHECKOUT (RICHIESTA PROFESSORE)
            // ================================================================
            else if (azione.equals("checkout")) {
                if (carrello != null && !carrello.getElementi().isEmpty()) {
                    
                    // Proviamo a recuperare l'utente loggato dalla sessione
                    model.Utente utenteLoggato = (model.Utente) session.getAttribute("utente");
                    
                    // Se non hai ancora implementato il login, per fare i test usiamo l'ID 1 
                    // (ovvero Nicola Zimbardi, che è presente nel dump del tuo database)
                    int idUtente = (utenteLoggato != null) ? utenteLoggato.getIdUtente() : 1;

                    // Istanziamo il nuovo DAO che lavora su 'ordini' e 'dettagli_ordine'
                    OrdineDAO ordineDao = new OrdineDAO();
                    boolean inserito = ordineDao.doSave(carrello, idUtente);
                    
                    if (inserito) {
                        System.out.println("DEBUG: Ordine e dettagli salvati nel DB!");
                        
                        // SVUOTAMENTO CARRELLO: Il contenuto viene ripulito dalla sessione utente
                        carrello.svuota();
                        
                        // Reindirizziamo l'utente alla pagina di successo esterna a WEB-INF
                        response.sendRedirect(request.getContextPath() + "/confermaOrdine.jsp");
                        return; // Blocca l'esecuzione ed evita il forward finale sulla jsp del carrello
                    } else {
                        System.out.println("DEBUG ERRORE: Qualcosa è fallito nella transazione SQL.");
                    }
                }
            }
            // ================================================================
        }
        
        // Se non è stato fatto il checkout, mostra normalmente la pagina del carrello
        request.getRequestDispatcher("/WEB-INF/views/carrello.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}