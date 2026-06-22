<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
    <title>ShirtInvasion - Registrazione</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/stile.css">
</head>
<body style="font-family: Arial, sans-serif; margin: 40px; text-align: center;">

    <div style="max-width: 350px; margin: 0 auto; padding: 20px; border: 1px solid #ccc; border-radius: 5px; background: #f9f9f9;">
        <h2>Crea il tuo Account</h2>
        
        <% if (request.getAttribute("messaggioErrore") != null) { %>
            <p style="color: red; font-weight: bold;"><%= request.getAttribute("messaggioErrore") %></p>
        <% } %>

        <form action="${pageContext.request.contextPath}/RegistrazioneServlet" method="post">
            <div style="margin-bottom: 12px; text-align: left;">
                <label>Nome:</label><br><input type="text" name="nome" required style="width: 100%; padding: 4px;">
            </div>
            <div style="margin-bottom: 12px; text-align: left;">
                <label>Cognome:</label><br><input type="text" name="cognome" required style="width: 100%; padding: 4px;">
            </div>
            <div style="margin-bottom: 12px; text-align: left;">
                <label>Email:</label><br><input type="email" name="email" required style="width: 100%; padding: 4px;">
            </div>
            <div style="margin-bottom: 12px; text-align: left;">
                <label>Password:</label><br><input type="password" name="password" required style="width: 100%; padding: 4px;">
            </div>
            <div style="margin-bottom: 12px; text-align: left;">
                <label>Indirizzo:</label><br><input type="text" name="indirizzo" style="width: 100%; padding: 4px;">
            </div>
            <div style="margin-bottom: 15px; text-align: left;">
                <label>Telefono:</label><br><input type="text" name="telefono" style="width: 100%; padding: 4px;">
            </div>
            
            <button type="submit" style="background: green; color: white; padding: 8px 15px; border: none; border-radius: 3px; cursor: pointer; width: 100%; font-weight: bold;">
                Registrati
            </button>
        </form>
        
        <p style="margin-top: 15px; font-size: 14px;">
            Hai già un account? <a href="${pageContext.request.contextPath}/LoginServlet">Accedi qui</a>
        </p>
    </div>

</body>
</html>
