<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Grazie per l'acquisto!</title>
</head>
<body style="font-family: sans-serif; text-align: center; padding: 50px;">
    <h1 style="color: #0d2c47;">ShirtInvasion &#9917;</h1>
    <div style="background: #e0f7fa; padding: 30px; display: inline-block; border-radius: 8px; margin-top: 20px; max-width: 500px;">
        <h2>Ordine Completato con Successo! 🎉</h2>
        <p>Il tuo ordine sarà presto in lavorazione.</p>
        <p>Il carrello è stato svuotato.</p>
        <br>
        
        <div style="display: flex; gap: 15px; justify-content: center; flex-wrap: wrap;">
            <a href="<%= request.getContextPath() %>/home" style="background: #00bcd4; color: white; padding: 10px 20px; text-decoration: none; border-radius: 4px; font-weight: bold;">Torna alla Home</a>
            
            <a href="<%= request.getContextPath() %>/OrdiniServlet" style="background: #0d2c47; color: white; padding: 10px 20px; text-decoration: none; border-radius: 4px; font-weight: bold;">I miei Ordini</a>
        </div>
    </div>
</body>
</html>