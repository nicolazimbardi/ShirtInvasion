<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ShirtInvasion - Login</title>
<<<<<<< HEAD
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/stile.css" type="text/css">
=======
    
<link rel="stylesheet" href="<%= request.getContextPath() %>/style/stile.css" type="text/css">
>>>>>>> branch 'main' of https://github.com/nicolazimbardi/ShirtInvasion
</head>
<<<<<<< HEAD
<body class="login-body"> <div class="login-card">
=======
<body class="login-body">

    <div class="login-card">
>>>>>>> branch 'main' of https://github.com/nicolazimbardi/ShirtInvasion
        <h2>Accedi a ShirtInvasion</h2>
        
        <% if (request.getAttribute("messaggioErrore") != null) { %>
            <p class="login-error"><%= request.getAttribute("messaggioErrore") %></p>
        <% } %>

        <form action="${pageContext.request.contextPath}/LoginServlet" method="post">
            <div class="form-group">
<<<<<<< HEAD
                <label>Email:</label>
                <input type="email" name="email" required>
=======
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" required>
>>>>>>> branch 'main' of https://github.com/nicolazimbardi/ShirtInvasion
            </div>
            
            <div class="form-group">
<<<<<<< HEAD
                <label>Password:</label>
                <input type="password" name="password" required>
=======
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required>
>>>>>>> branch 'main' of https://github.com/nicolazimbardi/ShirtInvasion
            </div>
            
            <button type="submit" class="btn-login">Accedi</button>
        </form>
        
<<<<<<< HEAD
        <div class="login-links">
            <p><a href="${pageContext.request.contextPath}/home">Torna alla Home</a></p>
            <p class="login-register-text">
                Non sei ancora registrato? <br>
                <a href="${pageContext.request.contextPath}/registrazione.jsp">Clicca qui per registrarti</a>
            </p>
        </div>
=======
        <p class="login-links">
            <a href="${pageContext.request.contextPath}/home">Torna alla Home</a>
        </p>
        
        <p class="login-register-text">
            Non sei ancora registrato? <br>
            <a href="${pageContext.request.contextPath}/RegistrazioneServlet">Clicca qui per registrarti</a>
        </p>
        
>>>>>>> branch 'main' of https://github.com/nicolazimbardi/ShirtInvasion
    </div>

</body>
</html>