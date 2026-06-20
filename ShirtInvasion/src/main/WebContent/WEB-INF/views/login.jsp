<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>ShirtInvasion - Login</title>
</head>
<body style="font-family: Arial, sans-serif; margin: 50px; text-align: center;">

    <div style="max-width: 300px; margin: 0 auto; padding: 20px; border: 1px solid #ccc; border-radius: 5px; background: #f9f9f9;">
        <h2>Accedi a ShirtInvasion</h2>
        
        <%-- Mostra il messaggio di errore se le credenziali sono errate --%>
        <% if (request.getAttribute("messaggioErrore") != null) { %>
            <p style="color: red; font-weight: bold;"><%= request.getAttribute("messaggioErrore") %></p>
        <% } %>

        <form action="${pageContext.request.contextPath}/LoginServlet" method="post">
            <div style="margin-bottom: 15px; text-align: left;">
                <label>Email:</label><br>
                <input type="email" name="email" required style="width: 100%; padding: 5px; box-sizing: border-box;">
            </div>
            
            <div style="margin-bottom: 15px; text-align: left;">
                <label>Password:</label><br>
                <input type="password" name="password" required style="width: 100%; padding: 5px; box-sizing: border-box;">
            </div>
            
            <button type="submit" style="background: #0056b3; color: white; padding: 8px 15px; border: none; border-radius: 3px; cursor: pointer; width: 100%;">
                Accedi
            </button>
        </form>
        
        <p style="margin-top: 15px; font-size: 14px;">
            <a href="${pageContext.request.contextPath}/">Torna alla Home</a>
            
        </p>
                <p style="margin-top: 15px; font-size: 14px; color: #555;">
            Non sei ancora registrato? <br>
            <a href="${pageContext.request.contextPath}/RegistrazioneServlet" style="color: #0056b3; font-weight: bold; text-decoration: none;">Clicca qui per registrarti</a>
        </p>
        
    </div>

</body>
</html>
