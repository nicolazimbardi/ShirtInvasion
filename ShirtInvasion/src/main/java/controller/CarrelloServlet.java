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
import model.Utente;

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
            
            // --- 1. CONTROLLO ADMIN ---
            if ("ADMIN".equals(ruolo) && (azione.equals("aggiungi") || azione.equals("rimuovi") || azione.equals("aggiornaQta") || azione.equals("svuota") || azione.equals("checkout"))) {
                response.sendRedirect(request.getContextPath() + "/AdminServlet?msg=adminNonPuoComprare");
                return;
            }

            // --- 2. CONTROLLO OSPITE ---
            if (azione.equals("checkout") && "GUEST".equals(ruolo)) {
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
                
                String referer = request.getHeader("referer");
                if (referer != null && !referer.isEmpty()) {
                    response.sendRedirect(referer);
                } else {
                    response.sendRedirect(request.getContextPath() + "/home");
                }
                return; 
                
            } else if (azione.equals("rimuovi")) {
                int id = Integer.parseInt(request.getParameter("id"));
                carrello.rimuoviProdotto(id);
                
            } else if (azione.equals("aggiornaQta")) {
                int id = Integer.parseInt(request.getParameter("id"));
                int quantita = Integer.parseInt(request.getParameter("quantita"));
                if (quantita > 0) {
                    carrello.aggiornaQuantita(id, quantita);
                }
                
            } else if (azione.equals("svuota")) {
                carrello.svuota();
                
            } else if (azione.equals("checkout")) {
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
        
        request.getRequestDispatcher("/WEB-INF/views/carrello.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}