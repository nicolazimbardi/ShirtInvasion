package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Utente;

@WebServlet("/VerificaPasswordAjaxServlet")
public class VerificaPasswordAjaxServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        Utente utenteSessione = (Utente) session.getAttribute("utente"); 
        
        String passwordDigitata = request.getParameter("password");

        // Risposta JSON: verifica se utente esiste e se la password coincide
        if (utenteSessione != null && passwordDigitata != null && passwordDigitata.equals(utenteSessione.getPassword())) {
            out.print("{\"corretta\": true}");
        } else {
            out.print("{\"corretta\": false}");
        }
        
        out.flush();
    }
}