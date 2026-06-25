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
                // 1. CONTROLLO STOCK PRIMA DI ANDARE AL CHECKOUT
                if (carrello != null && !carrello.getElementi().isEmpty()) {
                    StringBuilder erroriStock = new StringBuilder();
                    boolean stockSufficiente = true;

                    for (Prodotto p : carrello.getElementi()) {
                        Prodotto dbProd = prodottoDao.doRetrieveById(p.getIdProdotto());
                        // Se il prodotto non esiste o la quantità in db è minore di quella nel carrello
                        if (dbProd == null || dbProd.getQuantita() < p.getQuantitaCarrello()) {
                            stockSufficiente = false;
                            // Messaggio generico senza svelare lo stock reale
                            erroriStock.append("• <strong>").append(p.getNome()).append("</strong>: articolo non disponibile nella quantità richiesta.<br>");
                        }
                    }

                    if (!stockSufficiente) {
                        // Se manca qualcosa, salviamo l'errore in sessione e rimandiamo al carrello
                        session.setAttribute("erroreStock", erroriStock.toString());
                        response.sendRedirect(request.getContextPath() + "/CarrelloServlet");
                        return;
                    }
                }

                request.getRequestDispatcher("/WEB-INF/views/checkout.jsp").forward(request, response);
                return;

            } else if (azione.equals("confermaAcquisto")) {
                if (carrello != null && !carrello.getElementi().isEmpty()) {
                    
                    // 2. ULTIMO CONTROLLO STOCK (Un secondo prima del pagamento)
                    StringBuilder erroriStock = new StringBuilder();
                    boolean stockSufficiente = true;

                    for (Prodotto p : carrello.getElementi()) {
                        Prodotto dbProd = prodottoDao.doRetrieveById(p.getIdProdotto());
                        if (dbProd == null || dbProd.getQuantita() < p.getQuantitaCarrello()) {
                            stockSufficiente = false;
                            // Messaggio generico senza svelare lo stock reale
                            erroriStock.append("• <strong>").append(p.getNome()).append("</strong>: articolo non disponibile nella quantità richiesta.<br>");
                        }
                    }

                    if (!stockSufficiente) {
                        session.setAttribute("erroreStock", "Siamo spiacenti, alcuni articoli hanno subito variazioni di disponibilità:<br>" + erroriStock.toString());
                        response.sendRedirect(request.getContextPath() + "/CarrelloServlet");
                        return;
                    }

                    // 3. SE TUTTO VA BENE, PROCEDIAMO COL SALVATAGGIO DELL'ORDINE
                    double totaleFinale = Double.parseDouble(request.getParameter("totaleFinale"));
                    String indirizzoSelezionato = request.getParameter("indirizzoSelezionato");
                    
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
                        // 4. SOTTRAIAMO DEFINITIVAMENTE LO STOCK DAL DATABASE
                        for (Prodotto p : carrello.getElementi()) {
                            prodottoDao.aggiornaStock(p.getIdProdotto(), p.getQuantitaCarrello());
                        }

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
        
        // =======================================================================
        // FIX CSRF: VERIFICA DEL TOKEN DI SESSIONE (Solo per le richieste POST)
        // =======================================================================
        HttpSession session = request.getSession(false);
        
        // Il controllo del token ha senso solo se l'utente ha una sessione attiva (è loggato)
        // Se è un GUEST, la logica del tuo doGet lo fermerà comunque più avanti se cerca di fare checkout.
        if (session != null && session.getAttribute("utente") != null) {
            String tokenRequest  = request.getParameter("sessionToken");
            String tokenSessione = (String) session.getAttribute("sessionToken");

            if (tokenRequest == null || tokenSessione == null || !tokenSessione.equals(tokenRequest)) {
                // Token non valido o assente -> Blocco di sicurezza!
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Token di sessione non valido o scaduto.");
                return; 
            }
        }
        
        // Se il token è valido (oppure l'utente non è loggato ma sta solo aggiungendo 
        // roba al carrello come guest), passa la palla alla logica normale
        doGet(request, response);
    }
}
