<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ShirtInvasion - Registrazione</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/stile.css" type="text/css">
    
    <script src="${pageContext.request.contextPath}/scripts/registrazione.js" defer></script>
</head>
<body class="login-body"> <div class="login-card">
        <h2>Crea un account su ShirtInvasion</h2>
        
        <% if (request.getAttribute("messaggioErrore") != null) { %>
            <p class="login-error"><%= request.getAttribute("messaggioErrore") %></p>
        <% } %>

        <form id="registrazioneForm" action="${pageContext.request.contextPath}/RegistrazioneServlet" method="post">
            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" required>
            </div>
            
            <div class="form-group">
                <label for="telefono">Numero di Telefono:</label>
                <input type="text" id="telefono" name="telefono" required>
            </div>
            
            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required>
            </div>
            
            <div class="form-group">
                <label for="confermaPassword">Conferma Password:</label>
                <input type="password" id="confermaPassword" name="confermaPassword" required>
            </div>
            
            <button type="submit" class="btn-login">Registrati</button>
        </form>
        
        <p class="login-links">
            <a href="${pageContext.request.contextPath}/home">Torna alla Home</a>
        </p>
        
        <p class="login-register-text">
            Hai già un account? <br>
            <a href="${pageContext.request.contextPath}/LoginServlet">Clicca qui per accedere</a>
        </p>
        
    </div>

</body>
</html>