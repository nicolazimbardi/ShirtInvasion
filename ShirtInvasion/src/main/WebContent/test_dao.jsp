<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.UtenteDAO" %>
<%@ page import="model.Utente" %>
<!DOCTYPE html>
<html>
<head>
    <title>Test UtenteDAO</title>
</head>
<body>
    <h2>Verifica Funzionamento del DAO e del Modello:</h2>
   <%
    try {
        dao.ProdottoDAO prodottoDao = new dao.ProdottoDAO();
        java.util.List<model.Prodotto> lista = prodottoDao.doRetrieveAll();
        
        if (lista != null && !lista.isEmpty()) {
            out.println("<h3 style='color:green;'>TEST PRODOTTI RIUSCITO! ⚽</h3>");
            out.println("<p>Prodotti trovati nel database: " + lista.size() + "</p>");
            for(model.Prodotto p : lista) {
                out.println("<pre style='background:#eef; padding:5px;'>" + p.toString() + "</pre>");
            }
        } else {
            out.println("<h3 style='color:orange;'>Connessione OK, ma la tabella prodotti è vuota!</h3>");
        }
    } catch (Exception e) {
        out.println("<h3 style='color:red;'>ERRORE TEST PRODOTTI! ❌</h3>");
        e.printStackTrace(new java.io.PrintWriter(out));
    }
%>

</body>
</html>
