<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<<<<<<< HEAD
   <meta charset="UTF-8">
=======
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
>>>>>>> branch 'main' of https://github.com/nicolazimbardi/ShirtInvasion
    <title>ShirtInvasion - Registrazione</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/stile.css">
</head>
<body class="register-body">

    <div class="register-card">
        <h2>Crea un nuovo account</h2>
        
        <% if (request.getAttribute("messaggioErrore") != null) { %>
            <p class="register-error"><%= request.getAttribute("messaggioErrore") %></p>
        <% } %>

        <form action="${pageContext.request.contextPath}/RegistrazioneServlet" method="post">
            
            <div class="register-form-row">
                <div class="form-group">
                    <label for="nome">Nome:</label>
                    <input type="text" id="nome" name="nome" required>
                </div>
                
                <div class="form-group">
                    <label for="cognome">Cognome:</label>
                    <input type="text" id="cognome" name="cognome" required>
                </div>
            </div>
            
            <div class="form-group">
                <label for="email">Indirizzo Email:</label>
                <input type="email" id="email" name="email" required>
            </div>
            
            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required>
            </div>
            
            <button type="submit" class="btn-register">Registrati</button>
        </form>
        
        <p class="register-links">
            <a href="${pageContext.request.contextPath}/home">Torna alla Home</a>
        </p>
        
        <p class="register-login-text">
            Hai già un account? <br>
            <a href="${pageContext.request.contextPath}/LoginServlet">Clicca qui per accedere</a>
        </p>
        
    </div>

</body>
</html>
