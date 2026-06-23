<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Prodotto" %>
<%@ page import="model.Utente" %>
<%@ page import="model.Carrello" %>
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

    <header class="main-header">
        <div class="logo">
            <h1>Shirt<span>Invasion</span> ⚽</h1>
        </div>
        
        <nav class="nav-bar">
            <ul>
                <% 
                    Carrello carrelloSession = (Carrello) session.getAttribute("carrello");
                    int numeroArticoli = 0;
                    
                    if (carrelloSession != null && carrelloSession.getElementi() != null) {
                        for (Prodotto p : carrelloSession.getElementi()) {
                            numeroArticoli += p.getQuantitaCarrello();
                        }
                    }

                    Utente utenteLoggato = (Utente) session.getAttribute("utente");
                    if (utenteLoggato != null) { 
                %>
                        <li style="color: white; font-weight: bold; padding: 10px 15px;">
                            Ciao, <%= utenteLoggato.getNome() %> 👋
                            <% if ("ADMIN".equals(utenteLoggato.getRuolo())) { %>
                                <span style="background: red; color: white; padding: 2px 5px; font-size: 11px; border-radius: 3px; font-weight: bold; margin-left: 5px;">ADMIN</span>
                            <% } %>
                        </li>
                        
                        <li>
                            <a href="${pageContext.request.contextPath}/CarrelloServlet" class="cart-nav-link">
                                Il mio Carrello 🛒
                                <% if (numeroArticoli > 0) { %>
                                    <span class="cart-badge"><%= numeroArticoli %></span>
                                <% } %>
                            </a>
                        </li>
                        
                        <% if ("ADMIN".equals(utenteLoggato.getRuolo())) { %>
                            <li><a href="${pageContext.request.contextPath}/admin.jsp" style="color: #4CAF50; font-weight: bold;">Pannello Admin 🛠️</a></li>
                        <% } %>
                        
                        <li><a href="${pageContext.request.contextPath}/LogoutServlet" style="color: #ff4d4d; font-weight: bold;">Esci 🚪</a></li>
                <% 
                    } else { 
                %>
                        <li>
                            <a href="${pageContext.request.contextPath}/CarrelloServlet" class="cart-nav-link">
                                Il mio Carrello 🛒
                                <% if (numeroArticoli > 0) { %>
                                    <span class="cart-badge"><%= numeroArticoli %></span>
                                <% } %>
                            </a>
                        </li>
                        <li><a href="${pageContext.request.contextPath}/LoginServlet" style="font-weight: bold;">Accedi</a></li>
                        <li><a href="${pageContext.request.contextPath}/RegistrazioneServlet" style="font-weight: bold;">Registrati</a></li>
                <% 
                    } 
                %>
            </ul>
        </nav>
    </header>

    <section class="hero-picture">
        <div class="hero-text">
            <h2>Campioni sul Campo, Unici nello Stile</h2>
            <p>Trova le maglie da calcio più iconiche di sempre per la tua collezione.</p>
            
            <div class="search-container" style="position: relative; margin: 20px auto 0 auto; width: 100%; max-width: 450px; text-align: left;">
                <input type="text" id="searchBar" placeholder="Cerca una maglia o una squadra..." autocomplete="off" style="width: 100%; padding: 12px 20px; border-radius: 25px; border: 2px solid #fff; font-size: 16px; outline: none; box-shadow: 0 4px 15px rgba(0,0,0,0.2);">
                
                <div id="suggerimentiBox" style="position: absolute; top: 110%; left: 0; right: 0; background: white; border-radius: 12px; box-shadow: 0 8px 20px rgba(0,0,0,0.3); display: none; z-index: 9999; max-height: 280px; overflow-y: auto; color: #333;">
                </div>
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
                                    <% if (p.getImmagine() != null && !p.getImmagine().isEmpty()) { %>
                                        <img src="${pageContext.request.contextPath}/images/<%= p.getImmagine() %>" alt="<%= p.getNome() %>">
                                    <% } else { %>
                                        👕
                                    <% } %>
                                </div>
                                
                                <h3><%= p.getNome() %></h3>
                                <p class="meta-info"><%= p.getMarca() %> • <%= p.getSquadra() %> • <%= p.getStagione() %></p>
                                <p class="description"><%= p.getDescrizione() %></p>
                                <p class="taglia">Taglia: <span><%= p.getTaglia() %></span></p>
                                
                                <div class="card-footer">
                                    <span class="price"><%= String.format("%.2f", p.getPrezzo()) %> €</span>
                                    
                                    <% if (utenteLoggato == null || !"ADMIN".equals(utenteLoggato.getRuolo())) { %>
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
                            <p>Il catalogo è attualmente vuoto. </p>
                        </div>
                <%
                    }
                %>
            </div>
        </section>

        <aside class="content-news">
            <div class="widget-box">
                <h3>📢 Promozione di Lancio</h3>
                <p>Usa il codice sconto <strong>BOMBER10</strong> alla cassa per ricevere il 10% di sconto sul primo acquisto!</p>
            </div>
            
            <div class="widget-box">
                <h3>📦 Spedizione Express</h3>
                <p>Spedizione totalmente gratuita per ordini superiori a 50€. Ricevi la maglia a casa entro 24/48 ore.</p>
            </div>
        </aside>

    </main>

    <footer class="main-footer">
        <p>&copy; 2026 ShirtInvasion. Tutti i diritti riservati. Sviluppato in Java Web MVC.</p>
    </footer>

</body>
</html>