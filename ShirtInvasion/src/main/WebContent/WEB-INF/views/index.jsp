<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Prodotto" %>
<%@ page import="model.Utente" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ShirtInvasion - Catalogo Maglie</title>
    <link rel="stylesheet" href="styles/stile.css">
    <script src="scripts/ajax.js" defer></script>
</head>
<body>

    <jsp:include page="header.jsp" />

    <% 
        // Recuperiamo l'utente in sessione per gestire correttamente i permessi di acquisto nei prodotti
        Utente utenteLoggato = (Utente) session.getAttribute("utente");
    %>

    <section class="hero-picture">
        <div class="hero-text">
            <h2>Campioni sul Campo, Unici nello Stile</h2>
            <p>Trova le maglie da calcio più iconiche di sempre per la tua collezione.</p>
            
            <div class="search-container" style="position: relative; margin: 20px auto 0 auto; width: 100%; max-width: 450px; text-align: left;">
                <input type="text" id="searchBar" placeholder="Cerca una maglia o una squadra..." autocomplete="off" style="width: 100%; padding: 12px 20px; border-radius: 25px; border: 2px solid #fff; font-size: 16px; outline: none; box-shadow: 0 4px 15px rgba(0,0,0,0.2);">
                <div id="suggerimentiBox" style="position: absolute; top: 110%; left: 0; right: 0; background: white; border-radius: 12px; box-shadow: 0 8px 20px rgba(0,0,0,0.3); display: none; z-index: 9999; max-height: 280px; overflow-y: auto; color: #333;"></div>
            </div>
        </div>
    </section>

    <main class="main-container">
        
        <section class="portfolio-items">
            <h2>Maglie Disponibili</h2>
            <div class="products-grid">
                <%
                    List<Prodotto> prodotti = (List<Prodotto>) request.getAttribute("prodotti");
                    if (prodotti != null && !prodotti.isEmpty()) {
                        for (Prodotto p : prodotti) {
                %>
                            <div class="product-card">
                                <div class="product-img-placeholder">
                                    <a href="${pageContext.request.contextPath}/DettaglioServlet?id=<%= p.getIdProdotto() %>" style="display: flex; align-items: center; justify-content: center; width: 100%; height: 100%; text-decoration: none; color: inherit;">
                                        <% if (p.getImmagine() != null && !p.getImmagine().isEmpty()) { %>
                                            <img src="${pageContext.request.contextPath}/images/<%= p.getImmagine() %>" alt="<%= p.getNome() %>">
                                        <% } else { %>
                                            👕
                                        <% } %>
                                    </a>
                                </div>

                                <h3>
                                    <a href="${pageContext.request.contextPath}/DettaglioServlet?id=<%= p.getIdProdotto() %>" class="product-title-link">
                                        <%= p.getNome() %>
                                    </a>
                                </h3>
                                <p class="meta-info"><%= p.getMarca() %> • <%= p.getSquadra() %> • <%= p.getStagione() %></p>
                                <p class="description"><%= p.getDescrizione() %></p>
                                <p class="taglia">Taglia: <span><%= p.getTaglia() %></span></p>
                                
                                <div class="card-footer">
                                    <div>
                                        <span class="price"><%= String.format("%.2f", p.getPrezzo()) %> €</span>
                                        <% if (p.getQuantita() <= 0) { %>
                                            <p style="color:#dc3545;font-weight:bold;margin-top:5px;">Non disponibile</p>
                                        <% } %>
                                    </div>

                                    <% if (p.getQuantita() <= 0) { %>
                                        <span class="sold-out-badge">VENDUTO</span>
                                    <% } else if (utenteLoggato == null || !"ADMIN".equalsIgnoreCase(utenteLoggato.getRuolo())) { %>
                                        <a class="btn-add-cart" href="CarrelloServlet?azione=aggiungi&id=<%= p.getIdProdotto() %>">Aggiungi</a>
                                    <% } else { %>
                                        <span style="color: gray; font-size: 0.8em; font-weight: bold;">(Admin non può acquistare)</span>
                                    <% } %>
                                </div>
                            </div>
                <%
                        }
                    } else {
                %>
                        <div class="no-products">
                            <p>Il catalogo è attualmente vuoto.</p>
                        </div>
                <%
                    }
                %>
            </div>
        </section>

        <aside class="content-news">
            <div class="widget-box express-shipping-large">
                <h3>📦 Spedizione Express</h3>
                <p>La passione per il calcio non può attendere! Garantiamo una spedizione totalmente gratuita per tutti gli ordini superiori a 50€.</p>
                <p>Il nostro servizio di logistica elabora gli acquisti in tempo reale: riceverai la tua maglia da collezione comodamente a casa tua entro 24/48 ore lavorative tramite corriere espresso tracciato.</p>
            </div>
        </aside>

    </main>

    <footer class="main-footer">
        <p>&copy; 2026 ShirtInvasion. Tutti i diritti riservati. Sviluppato in Java Web MVC.</p>
    </footer>

</body>
</html>