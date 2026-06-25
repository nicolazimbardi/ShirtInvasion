package controller;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import dao.ProdottoDAO;
import model.Prodotto;

@WebServlet("/RicercaServlet")
public class RicercaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String query = request.getParameter("testo");
        List<Prodotto> risultati = null;
        
        try {
            if (query != null && !query.trim().isEmpty()) {
                ProdottoDAO prodottoDao = new ProdottoDAO();
                risultati = prodottoDao.doRetrieveByNome(query);
            } else {
                ProdottoDAO prodottoDao = new ProdottoDAO();
                risultati = prodottoDao.doRetrieveAll(); 
            }
        } catch (Exception e) {
            e.printStackTrace(); // Ti aiuta a vedere i log nella console se il DB dà problemi
        }
        
        // Passa i risultati alla pagina index.jsp
        request.setAttribute("prodotti", risultati);
        
        // CORREZIONE: Punta alla cartella protetta WEB-INF
        request.getRequestDispatcher("/WEB-INF/views/index.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}