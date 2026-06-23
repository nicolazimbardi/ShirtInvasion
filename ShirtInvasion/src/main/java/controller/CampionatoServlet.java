package controller;

import java.io.IOException;
import java.util.List;

import dao.ProdottoDAO;
import model.Prodotto;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/campionato")
public class CampionatoServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String campionato = request.getParameter("nome");

        ProdottoDAO dao = new ProdottoDAO();

        List<Prodotto> prodotti =
                dao.doRetrieveByCampionato(campionato);

        request.setAttribute("prodotti", prodotti);
        request.setAttribute("campionato", campionato);

        request.getRequestDispatcher("/WEB-INF/views/catalogo.jsp")
               .forward(request, response);
    }
}