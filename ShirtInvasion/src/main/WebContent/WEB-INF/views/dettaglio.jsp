<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Prodotto" %>
<%@ page import="model.Utente" %>
<%@ page import="model.Carrello" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dettaglio Prodotto - ShirtInvasion</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/stile.css" type="text/css">
</head>
<body>

    <%
        // Recupero i dati della sessione e della richiesta
        Prodotto p = (Prodotto) request.getAttribute("prodotto");
        Utente utenteLoggato = (Utente) session.getAttribute("utente");
    %>

    <header class="main-header">
        <div class="logo">
            <h1><a href="<%= request.getContextPath() %>/" style="text-decoration: none; color: white;">ShirtInvasion<span>⚽</span></a></h1>
        </div>
        <nav class="nav-bar">
    <ul>
        <li><a href="<%= request.getContextPath() %>/">Home</a></li>
        
        <li>
            <a href="<%= request.getContextPath() %>/CarrelloServlet" class="cart-nav-link">
                Il mio Carrello 🛒
                <% 
                    Carrello cart = (Carrello) session.getAttribute("carrello");
                    if (cart != null && cart.getNumeroTotaleArticoli() > 0) { 
                %>
                    <span class="cart-badge"><%= cart.getNumeroTotaleArticoli() %></span>
                <% } %>
            </a>
        </li>
        
        <% if (utenteLoggato == null) { %>
            <li><a href="<%= request.getContextPath() %>/LoginServlet">Accedi</a></li>
            <li><a href="<%= request.getContextPath() %>/RegistrazioneServlet">Registrati</a></li>
        <% } else { %>
            <% if ("ADMIN".equals(utenteLoggato.getRuolo())) { %>
                <li><a href="<%= request.getContextPath() %>/AdminServlet" style="color: #ffcc00;">Admin Panel</a></li>
            <% } %>
          <li><a href="<%= request.getContextPath() %>/LogoutServlet" style="color: #ff4d4d; font-weight: bold;">Esci 🚪</a></li>
        <% } %>
    </ul>
</nav>
    </header>

    <main class="main-container" style="margin-top: 40px;">
        <% if (p != null) { %>
        
        <div class="product-detail-wrapper">
            <div class="detail-gallery">
                <% if (p.getImmagine() != null && !p.getImmagine().isEmpty()) { %>
                    <img src="<%= request.getContextPath() %>/images/<%= p.getImmagine() %>" alt="<%= p.getNome() %>">
                <% } else { %>
                    <div style="font-size: 100px; text-align:center;">👕</div>
                <% } %>
            </div>

            <div class="detail-info-box">
                <div class="detail-badges">
                    <span class="badge-black"><%= p.getMarca() %></span>
                    <span class="badge-red"><%= p.getSquadra() %></span>
                </div>

                <h1 class="detail-title"><%= p.getStagione() %> <%= p.getNome() %> (<%= p.getTaglia() %>)</h1>
                <p class="detail-price"><%= String.format("%.2f", p.getPrezzo()) %> €</p>

                <div class="detail-description">
                    <p><%= p.getDescrizione() %></p>
                </div>

                <div class="detail-specs">
                    <p><strong>Disponibilità:</strong> 
                        <% if(p.getQuantita() > 0) { %>
                            <span style="color: #1a7f37; font-weight:bold;">In stock (<%= p.getQuantita() %>)</span>
                        <% } else { %>
                            <span style="color: #d1242f; font-weight:bold;">Esaurito</span>
                        <% } %>
                    </p>
                </div>

                <% if (utenteLoggato == null || !"ADMIN".equals(utenteLoggato.getRuolo())) { %>
                    <% if(p.getQuantita() > 0) { %>
                        <a href="<%= request.getContextPath() %>/CarrelloServlet?azione=aggiungi&id=<%= p.getIdProdotto() %>" class="btn-detail-cart">
                            AGGIUNGI AL CARRELLO
                        </a>
                    <% } else { %>
                        <button class="btn-detail-cart" style="background: #ccc; cursor:not-allowed;" disabled>NON DISPONIBILE</button>
                    <% } %>
                <% } else { %>
                    <p style="color: gray; font-weight: bold; margin-top: 15px;">(Vista Amministratore: Acquisto disabilitato)</p>
                <% } %>
                
                <hr style="margin: 30px 0; border: 0; border-top: 1px solid #eee;">
                
                <p style="font-size: 13px; color: #666;"><strong>ORDER NOW</strong> per ricevere la tua maglia in tempi record.</p>
            </div>
        </div>

        <% } else { %>
            <div style="text-align: center; padding: 50px;">
                <h2>Prodotto non trovato.</h2>
                <a href="<%= request.getContextPath() %>/">Torna alla Home</a>
            </div>
        <% } %>
    </main>

</body>
</html>