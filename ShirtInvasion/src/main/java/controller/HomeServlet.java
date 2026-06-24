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

@WebServlet(urlPatterns = {"/home", ""})
public class HomeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Recuperiamo i parametri scelti dall'utente nella index
        String marca = request.getParameter("marca");
        String taglia = request.getParameter("taglia");
        String ordine = request.getParameter("ordine");
        
        ProdottoDAO prodottoDao = new ProdottoDAO();
        
        // Eseguiamo la query filtrata
        List<Prodotto> listaProdotti = prodottoDao.doRetrieveAll(marca, taglia, ordine);
        
        // Rispediamo i dati alla pagina JSP
        request.setAttribute("prodotti", listaProdotti);
        request.setAttribute("selMarca", marca);
        request.setAttribute("selTaglia", taglia);
        request.setAttribute("selOrdine", ordine);
        
        request.getRequestDispatcher("/WEB-INF/views/index.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}