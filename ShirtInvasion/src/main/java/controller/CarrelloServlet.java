package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.ProdottoDAO;
import dao.OrdineDAO;
import model.Carrello;
import model.Prodotto;
import model.Utente; // Import necessario

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
        
        // Recupero ruolo per i controlli di sicurezza
        Utente utenteLoggato = (Utente) session.getAttribute("utente");
        String ruolo = (utenteLoggato != null) ? utenteLoggato.getRuolo() : "GUEST";
        
        String azione = request.getParameter("azione");
        ProdottoDAO prodottoDao = new ProdottoDAO();
        
        if (azione != null) {
            
            // --- 1. CONTROLLO ADMIN: Non può modificare il carrello ---
            if ("ADMIN".equals(ruolo) && (azione.equals("aggiungi") || azione.equals("rimuovi") || azione.equals("svuota") || azione.equals("checkout"))) {
                // Reindirizziamo l'admin al pannello di controllo se prova ad acquistare
                response.sendRedirect(request.getContextPath() + "/AdminServlet?msg=adminNonPuòComprare");
                return;
            }

            // --- 2. CONTROLLO OSPITE: Non può fare checkout ---
            if (azione.equals("checkout") && "GUEST".equals(ruolo)) {
                // Reindirizziamo l'ospite alla pagina di Login
                response.sendRedirect(request.getContextPath() + "/LoginServlet?msg=deviEffettuareIlLoginPerAcquistare");
                return;
            }

            // --- LOGICA AZIONI ---
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
            } else if (azione.equals("checkout")) {
                // Procedura di checkout solo per utenti registrati
                if (carrello != null && !carrello.getElementi().isEmpty()) {
                    OrdineDAO ordineDao = new OrdineDAO();
                    boolean inserito = ordineDao.doSave(carrello, utenteLoggato.getIdUtente());
                    
                    if (inserito) {
                        carrello.svuota();
                        request.getRequestDispatcher("/WEB-INF/views/confermaOrdine.jsp").forward(request, response);
                        return;
                    }
                }
            }
        }
        
        // Se non è stato fatto il checkout, mostra normalmente la pagina del carrello
        request.getRequestDispatcher("/WEB-INF/views/carrello.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}