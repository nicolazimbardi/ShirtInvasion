package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

import dao.ProdottoDAO;
import model.Prodotto;

@WebServlet("/RicercaAjaxServlet")
public class RicercaAjaxServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        //  Recupera la stringa digitata dall'utente
        String query = request.getParameter("q");
        List<Prodotto> risultati = new ArrayList<>();
        
        if (query != null && !query.trim().isEmpty()) {
            try {
                // 2. Istanzia il DAO e interroga il Database 
                ProdottoDAO prodottoDao = new ProdottoDAO();
                risultati = prodottoDao.doRetrieveByNome(query);
                
             } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        // 3. Prepara la risposta HTTP in formato JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        // 4. Trasforma la lista dei prodotti del DB in una stringa JSON
        Gson gson = new Gson();
        String jsonResponse = gson.toJson(risultati);
        
        //  Iviao il JSON finale al JavaScript
        PrintWriter out = response.getWriter();
        out.print(jsonResponse);
        out.flush();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}