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
import dao.IndirizzoDAO;
import model.Carrello;
import model.Prodotto;
import model.Utente;
import model.Indirizzo;

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
            if ((azione.equals("checkout") || azione.equals("confermaAcquisto")) && "GUEST".equals(ruolo)) {
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
                // Reindirizza alla pagina di riepilogo checkout
                request.getRequestDispatcher("/WEB-INF/views/checkout.jsp").forward(request, response);
                return;

            } else if (azione.equals("confermaAcquisto")) {
                // LOGICA PAGAMENTO E SALVATAGGIO ORDINE
                if (carrello != null && !carrello.getElementi().isEmpty()) {
                    
                    double totaleFinale = Double.parseDouble(request.getParameter("totaleFinale"));
                    String indirizzoSelezionato = request.getParameter("indirizzoSelezionato");
                    
                    // Se l'utente crea un nuovo indirizzo al momento
                    if ("nuovo".equals(indirizzoSelezionato)) {
                        Indirizzo nuovoInd = new Indirizzo();
                        nuovoInd.setIdUtente(utenteLoggato.getIdUtente());
                        nuovoInd.setVia(request.getParameter("via_nuovo"));
                        nuovoInd.setCitta(request.getParameter("citta_nuovo"));
                        nuovoInd.setCap(request.getParameter("cap_nuovo"));
                        nuovoInd.setProvincia(request.getParameter("provincia_nuovo"));
                        nuovoInd.setNazione(request.getParameter("nazione_nuovo"));
                        nuovoInd.setAttivo(false);
                        
                        IndirizzoDAO indDao = new IndirizzoDAO();
                        indDao.doSave(nuovoInd);
                    }

                    OrdineDAO ordineDao = new OrdineDAO();
                    boolean inserito = ordineDao.doSaveConTotale(carrello, utenteLoggato.getIdUtente(), totaleFinale);
                    
                    if (inserito) {
                        carrello.svuota();
                        request.setAttribute("messaggioSuccesso", "Pagamento completato con successo!");
                        request.getRequestDispatcher("/WEB-INF/views/confermaOrdine.jsp").forward(request, response);
                        return;
                    } else {
                        response.sendRedirect(request.getContextPath() + "/CarrelloServlet?msg=erroreCheckout");
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
