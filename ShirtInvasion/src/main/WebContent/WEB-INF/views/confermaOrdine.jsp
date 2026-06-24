<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ShirtInvasion - Grazie per l'acquisto!</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/stile.css">
</head>
<body class="page-conferma">

    <header class="main-header">
        <div class="logo">
            <h1>Shirt<span>Invasion</span> &#9917;</h1>
        </div>
    </header>

    <main class="confirmation-container">
        <div class="confirmation-box">
            <div class="success-icon">🎉</div>
            <h2>Ordine Completato con Successo!</h2>
            <p class="success-subtitle">Grazie per aver scelto ShirtInvasion.</p>
            
            <div class="success-details">
                <p>Il tuo ordine è stato ricevuto ed è attualmente in lavorazione.</p>
                <p>Ti invieremo un'email con i dettagli della spedizione non appena il pacco lascerà il nostro magazzino.</p>
            </div>
            
            <div class="confirmation-actions">
                <a href="${pageContext.request.contextPath}/home" class="btn-action btn-primary">Torna alla Home</a>
                <a href="${pageContext.request.contextPath}/OrdiniServlet" class="btn-action btn-secondary">I miei Ordini</a>
            </div>
        </div>
    </main>

    <footer class="main-footer">
        <p>&copy; 2026 ShirtInvasion. Tutti i diritti riservati. Sviluppato in Java Web MVC.</p>
    </footer>

</body>
</html>