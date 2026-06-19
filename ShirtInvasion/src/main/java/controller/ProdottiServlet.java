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

@WebServlet("/ProdottiServlet")
public class ProdottiServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        ProdottoDAO prodottoDao = new ProdottoDAO();
        String idParam = request.getParameter("id");
        
        if (idParam != null) {
            int id = Integer.parseInt(idParam);
            Prodotto prodotto = prodottoDao.doRetrieveById(id);
            request.setAttribute("prodotto", prodotto);
            request.getRequestDispatcher("/WEB-INF/views/dettaglio.jsp").forward(request, response);
        } else {
            
            List<Prodotto> lista = prodottoDao.doRetrieveAll();
            request.setAttribute("prodotti", lista);
            request.getRequestDispatcher("/WEB-INF/views/prodotti.jsp").forward(request, response);
        }
    }
}
