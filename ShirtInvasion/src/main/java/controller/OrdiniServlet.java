package controller;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.OrdineDAO;
import model.Ordine;
import model.Utente;

@WebServlet("/OrdiniServlet")
public class OrdiniServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        Utente utente = (Utente) request.getSession().getAttribute("utente");
        if (utente == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }
        
        OrdineDAO ordineDao = new OrdineDAO();
        List<Ordine> listaOrdini = ordineDao.doRetrieveByUtente(utente.getIdUtente());
        
        request.setAttribute("listaOrdini", listaOrdini);
        
        // Attenzione: controlla se la tua cartella si chiama "views" o altro
        request.getRequestDispatcher("/WEB-INF/views/ordini.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}