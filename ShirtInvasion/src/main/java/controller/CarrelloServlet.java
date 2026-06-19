package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.ProdottoDAO;
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
        }
        
        request.getRequestDispatcher("/WEB-INF/views/carrello.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
