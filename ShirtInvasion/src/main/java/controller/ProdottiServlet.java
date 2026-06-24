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
        
        List<Prodotto> lista = prodottoDao.doRetrieveAll();
        
        request.setAttribute("prodotti", lista);
        request.getRequestDispatcher("/WEB-INF/views/prodotti.jsp").forward(request, response);
    }
}