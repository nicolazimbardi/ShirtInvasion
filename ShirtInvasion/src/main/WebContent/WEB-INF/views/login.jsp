<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>ShirtInvasion - Login</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/stile.css" type="text/css">
</head>
<body class="login-body"> <div class="login-card">
        <h2>Accedi a ShirtInvasion</h2>
        
        <% if (request.getAttribute("messaggioErrore") != null) { %>
            <p class="login-error"><%= request.getAttribute("messaggioErrore") %></p>
        <% } %>

        <form action="${pageContext.request.contextPath}/LoginServlet" method="post">
            <div class="form-group">
                <label>Email:</label>
                <input type="email" name="email" required>
            </div>
            
            <div class="form-group">
                <label>Password:</label>
                <input type="password" name="password" required>
            </div>
            
            <button type="submit" class="btn-login">Accedi</button>
        </form>
        
        <div class="login-links">
            <p><a href="${pageContext.request.contextPath}/home">Torna alla Home</a></p>
            <p class="login-register-text">
                Non sei ancora registrato? <br>
                <a href="${pageContext.request.contextPath}/registrazione.jsp">Clicca qui per registrarti</a>
            </p>
        </div>
    </div>

</body>
</html>