<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.UtenteDAO" %>
<%@ page import="dao.ProdottoDAO" %>
<%@ page import="model.Utente" %>
<%@ page import="model.Prodotto" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Test DAO Aggiornato</title>
</head>
<body>
    <h2>Verifica funzionamento dei DAO semplificati</h2>

    <%
        try {
            // 1. TEST UTENTE
            UtenteDAO utenteDao = new UtenteDAO();
            Utente u = utenteDao.doRetrieveByEmailAndPassword("nicolazim@gmail.it", "admin123");
            
            out.println("<h3>1. Test Utente (Login):</h3>");
            if (u != null) {
                out.println("<p style='color:green;'>SÌ! Utente trovato: " + u.getNome() + " " + u.getCognome() + " (" + u.getRuolo() + ")</p>");
            } else {
                out.println("<p style='color:orange;'>Connessione OK, ma credenziali non trovate nel database.</p>");
            }

            // 2. TEST PRODOTTI
            ProdottoDAO prodottoDao = new ProdottoDAO();
            List<Prodotto> lista = prodottoDao.doRetrieveAll();
            
            out.println("<h3>2. Test Prodotti (Catalogo):</h3>");
            if (lista != null && !lista.isEmpty()) {
                out.println("<p style='color:green;'>SÌ! Prodotti caricati dal DB: " + lista.size() + "</p>");
                for(Prodotto p : lista) {
                    out.println("<li>" + p.getSquadra() + " - " + p.getNome() + " (€" + p.getPrezzo() + ")</li>");
                }
            } else {
                out.println("<p style='color:orange;'>Connessione OK, ma la tabella prodotti è vuota.</p>.</p>");
            }

        } catch (Exception e) {
            out.println("<h3 style='color:red;'>ERRORE DURANTE IL TEST! ❌</h3>");
            out.println("<pre>");
            e.printStackTrace(new java.io.PrintWriter(out));
            out.println("</pre>");
        }
    %>
</body>
</html>
