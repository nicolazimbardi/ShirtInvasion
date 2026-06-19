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
            UtenteDAO utenteDao = new UtenteDAO();
            
           
            Utente u = utenteDao.doRetrieveByEmailAndPassword("nicolazim@gmail.it", "admin123");
            
            if (u != null) {
                out.println("<h3 style='color:green;'>TEST COMPLETATO CON SUCCESSO! 🎉</h3>");
                out.println("<p>Il DAO ha estratto i dati con il PreparedStatement e ha popolato il Modello Utente.</p>");
                out.println("<strong>Dati Utente Estratti (grazie al metodo toString):</strong>");
                out.println("<pre style='background:#f4f4f4; padding:10px; border:1px solid #ccc;'>" + u.toString() + "</pre>");
            } else {
                out.println("<h3 style='color:orange;'>Connessione riuscita, ma utente non trovato!</h3>");
                out.println("<p>Verifica che nel database ci sia l'utente con email 'nicolazim@gmail.it' e password 'admin123'.</p>");
            }
        } catch (Exception e) {
            out.println("<h3 style='color:red;'>ERRORE DURANTE IL TEST DEL DAO! ❌</h3>");
            out.println("<pre style='color:red;'>");
            e.printStackTrace(new java.io.PrintWriter(out));
            out.println("</pre>");
        }
    %>
</body>
</html>
