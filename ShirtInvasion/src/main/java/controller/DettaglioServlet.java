package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.ProdottoDAO;
import model.Prodotto;

@WebServlet("/DettaglioServlet")
public class DettaglioServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Prendo l'ID dalla barra degli indirizzi (es. ?id=5)
        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.isEmpty()) {
            try {
                int idProdotto = Integer.parseInt(idParam);
                
                // 2. Chiedo al DAO di darmi il prodotto con quell'ID
                ProdottoDAO prodottoDao = new ProdottoDAO();
                Prodotto prodotto = prodottoDao.doRetrieveById(idProdotto);

                if (prodotto != null) {
                    // 3. Se esiste, lo salvo nella request e vado alla pagina dettaglio.jsp
                    request.setAttribute("prodotto", prodotto);
                    request.getRequestDispatcher("/WEB-INF/views/dettaglio.jsp").forward(request, response);
                } else {
                    // Se non esiste (es. ID sbagliato), torno alla home
                    response.sendRedirect(request.getContextPath() + "/ProdottiServlet");
                }
            } catch (NumberFormatException e) {
                // Se l'ID non è un numero, torno alla home
                response.sendRedirect(request.getContextPath() + "/ProdottiServlet");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/ProdottiServlet");
        }
    }
}