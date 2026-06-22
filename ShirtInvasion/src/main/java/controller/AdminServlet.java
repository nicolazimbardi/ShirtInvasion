package controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import dao.ProdottoDAO;
import model.Prodotto;
import model.Utente;

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Controllo di Sicurezza Sessione ed Admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("utente") == null) {
            request.setAttribute("messaggioErrore", "Accesso negato. Effettua il login!");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            return;
        }
        
        Utente utente = (Utente) session.getAttribute("utente");
        if (!"ADMIN".equals(utente.getRuolo())) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        // 2. Lettura dei file immagine esistenti nella cartella /images per il menu a tendina
        List<String> elencoFoto = new ArrayList<>();
        String pathImages = getServletContext().getRealPath("") + File.separator + "images";
        File cartellaImages = new File(pathImages);
        
        if (cartellaImages.exists() && cartellaImages.isDirectory()) {
            File[] fileTrovati = cartellaImages.listFiles();
            if (fileTrovati != null) {
                for (File f : fileTrovati) {
                    String nomeFile = f.getName().toLowerCase();
                    if (f.isFile() && (nomeFile.endsWith(".jpg") || nomeFile.endsWith(".jpeg") || nomeFile.endsWith(".png") || nomeFile.endsWith(".webp"))) {
                        elencoFoto.add(f.getName());
                    }
                }
            }
        }
        
        ProdottoDAO prodottoDao = new ProdottoDAO();
        List<Prodotto> catalogo = prodottoDao.doRetrieveAll(); 

        request.setAttribute("listaFotoDisponibili", elencoFoto);
        request.setAttribute("prodottiCatalogo", catalogo);
        
        request.getRequestDispatcher("/WEB-INF/views/admin.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("utente") == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Non autorizzato");
            return;
        }
        Utente utente = (Utente) session.getAttribute("utente");
        if (!"ADMIN".equals(utente.getRuolo())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Non autorizzato");
            return;
        }

        ProdottoDAO prodottoDao = new ProdottoDAO();
        String azioneProdotto = request.getParameter("azioneProdotto");

        if (azioneProdotto == null || azioneProdotto.isEmpty() || "inserisci".equals(azioneProdotto)) {
            Prodotto nuovo = new Prodotto();
            nuovo.setSquadra(request.getParameter("squadra"));
            nuovo.setNome(request.getParameter("modello")); // 'modello' nel form -> 'nome' nel DB
            nuovo.setStagione(request.getParameter("stagione"));
            nuovo.setMarca(request.getParameter("marca"));
            nuovo.setTaglia(request.getParameter("taglia"));
            nuovo.setPrezzo(Double.parseDouble(request.getParameter("prezzo")));
            nuovo.setQuantita(Integer.parseInt(request.getParameter("stock"))); // 'stock' nel form -> 'quantita' nel DB
            nuovo.setDescrizione(request.getParameter("descrizione"));
            nuovo.setImmagine(request.getParameter("immagine")); // Il nome del file (es: milan.jpg)
            nuovo.setAttivo(true);
            
            boolean salvato = prodottoDao.doSave(nuovo);
            if (salvato) {
                request.setAttribute("messaggioSuccesso", "Articolo inserito correttamente!");
            } else {
                request.setAttribute("messaggioErrore", "Errore nel salvataggio del prodotto.");
            }
        }
        else if ("elimina".equals(azioneProdotto)) {
            int idDel = Integer.parseInt(request.getParameter("id"));
            prodottoDao.doDelete(idDel);
            request.setAttribute("messaggioSuccesso", "Articolo eliminato dal catalogo.");
        }
        else if ("modifica".equals(azioneProdotto)) {
            int idMod = Integer.parseInt(request.getParameter("id"));
            Prodotto pMod = prodottoDao.doRetrieveById(idMod);
            if (pMod != null) {
                pMod.setStagione(request.getParameter("stagione"));
                pMod.setMarca(request.getParameter("marca"));
                pMod.setTaglia(request.getParameter("taglia"));
                pMod.setPrezzo(Double.parseDouble(request.getParameter("prezzo")));
                pMod.setQuantita(Integer.parseInt(request.getParameter("stock")));
                pMod.setDescrizione(request.getParameter("descrizione"));
                prodottoDao.doUpdate(pMod);
                request.setAttribute("messaggioSuccesso", "Articolo aggiornato con successo.");
            }
        }

        doGet(request, response);
    }
}
