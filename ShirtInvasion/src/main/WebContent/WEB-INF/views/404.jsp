<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - Pagina non trovata | ShirtInvasion</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/stile.css">
    
    <style>
        .error-wrapper {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 70vh;
            padding: 20px;
        }
        .error-card {
            background-color: #FFFFFF;
            border-radius: 8px;
            padding: 40px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            max-width: 550px;
            width: 100%;
            text-align: center;
            border-top: 4px solid #022340; /* Richiamo al colore dell'header */
        }
        .error-code {
            font-size: 6rem;
            font-weight: 700;
            color: #022340;
            line-height: 1;
            margin: 0;
        }
        .error-code span {
            color: #00a8ff; /* L'azzurro del tuo logo */
        }
        .error-title {
            font-size: 24px;
            color: #022340;
            margin-top: 10px;
            margin-bottom: 15px;
            border-bottom: none !important; /* Rimuove la linea blu dei tag h2 generali */
            padding: 0 !important;
        }
        .error-message {
            font-size: 16px;
            color: #333333;
            margin-bottom: 30px;
        }
        .btn-error {
            display: inline-block;
            text-decoration: none;
            background-color: #022340;
            color: #FFFFFF;
            font-weight: 600;
            font-size: 15px;
            padding: 10px 24px;
            border-radius: 4px; /* Coerente con i link della nav-bar */
            transition: all 0.3s ease;
        }
        .btn-error:hover {
            background-color: #0568A6; /* Stesso hover del tuo menu */
            color: #FFFFFF;
        }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/views/header.jsp" />

    <div class="error-wrapper">
        <div class="error-card">
            <h1 class="error-code">4<span>0</span>4</h1>
            <h2 class="error-title">Ops...</h2>
            <p class="error-message">La pagina che stai cercando non esiste o è stata spostata. Controlla l'URL o torna alla pagina principale.</p>
            <a href="${pageContext.request.contextPath}/home" class="btn-error">⚽ Torna alla Home</a>
        </div>
    </div>

</body>
</html>