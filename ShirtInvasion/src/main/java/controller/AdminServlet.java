package controller;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

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
    private static DataSource ds;

    static {
        try {
            InitialContext ctx = new InitialContext();
            ds = (DataSource) ctx.lookup("java:comp/env/jdbc/shirtinvasion");
        } catch (NamingException e) {
            e.printStackTrace();
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
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

        List<String[]> listaOrdiniArray = new ArrayList<>();
        String queryOrdini = "SELECT o.id_ordine, u.email, o.data_ordine, o.totale, o.stato " +
                             "FROM ordini o JOIN utenti u ON o.id_utente = u.id_utente"; 
        
        if (ds != null) {
            try (Connection conn = ds.getConnection();
                 PreparedStatement ps = conn.prepareStatement(queryOrdini);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    String[] rigaOrdine = new String[5];
                    rigaOrdine[0] = rs.getString("id_ordine");
                    rigaOrdine[1] = rs.getString("email"); 
                    rigaOrdine[2] = rs.getString("data_ordine");
                    rigaOrdine[3] = String.format("%.2f €", rs.getDouble("totale"));
                    rigaOrdine[4] = rs.getString("stato");
                    
                    listaOrdiniArray.add(rigaOrdine);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        request.setAttribute("listaFotoDisponibili", elencoFoto);
        request.setAttribute("prodottiCatalogo", catalogo);
        request.setAttribute("listaOrdiniSenzaClasse", listaOrdiniArray); // Inviato alla Sezione 2 della JSP
        
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
            nuovo.setNome(request.getParameter("modello")); 
            nuovo.setStagione(request.getParameter("stagione"));
            nuovo.setMarca(request.getParameter("marca"));
            nuovo.setTaglia(request.getParameter("taglia"));
            nuovo.setPrezzo(Double.parseDouble(request.getParameter("prezzo")));
            nuovo.setQuantita(Integer.parseInt(request.getParameter("stock"))); 
            nuovo.setDescrizione(request.getParameter("descrizione"));
            nuovo.setImmagine(request.getParameter("immagine")); 
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
            boolean eliminato = prodottoDao.doDelete(idDel);
            if (eliminato) {
                request.setAttribute("messaggioSuccesso", "Articolo rimosso dal catalogo con successo.");
            } else {
                request.setAttribute("messaggioErrore", "Errore durante l'eliminazione.");
            }
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
                
                boolean aggiornato = prodottoDao.doUpdate(pMod);
                if (aggiornato) {
                    request.setAttribute("messaggioSuccesso", "Articolo aggiornato con successo.");
                } else {
                    request.setAttribute("messaggioErrore", "Errore durante l'aggiornamento dell'articolo.");
                }
            }
        }
        else if ("elimina".equals(azioneProdotto)) {
            int idDel = Integer.parseInt(request.getParameter("id")); 
            boolean eliminato = prodottoDao.doDelete(idDel);
            
            if (eliminato) {
                request.setAttribute("messaggioSuccesso", "Articolo rimosso dal catalogo con successo.");
            } else {
                request.setAttribute("messaggioErrore", "Errore durante l'eliminazione dal database.");
            }
            
            List<Prodotto> catalogoAggiornato = prodottoDao.doRetrieveAll(); 
            request.setAttribute("prodottiCatalogo", catalogoAggiornato);
        }

        doGet(request, response);
    }
}

