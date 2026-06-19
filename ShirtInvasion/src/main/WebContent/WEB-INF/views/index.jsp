<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Prodotto" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ShirtInvasion - Catalogo Maglie</title>
    <link rel="stylesheet" href="styles/stile.css">
</head>
<body>

  <header class="main-header">
        <div class="logo">
            <h1>Shirt<span>Invasion</span> ⚽</h1>
        </div>
        
        <nav class="nav-bar">
            <ul>
                <li><a href="${pageContext.request.contextPath}/carrello">Il mio Carrello</a></li>
                <li><a href="${pageContext.request.contextPath}/login">Accedi / Registrati</a></li>
            </ul>
        </nav>
    </header>

    <section class="hero-picture">
        <div class="hero-text">
            <h2>Campioni sul Campo, Unici nello Stile</h2>
            <p>Trova le maglie da calcio più iconiche di sempre per la tua collezione.</p>
        </div>
    </section>


    <main class="main-container">
        
        <section class="portfolio-items">
            <h2>Maglie Disponibili</h2>
            <div class="products-grid">
                <%
                    // Recupero della lista di prodotti inoltrata dal Controller
                    List<Prodotto> prodotti = (List<Prodotto>) request.getAttribute("prodotti");
                    
                    if (prodotti != null && !prodotti.isEmpty()) {
                        for (Prodotto p : prodotti) {
                %>
                            <div class="product-card">
                                <div class="product-img-placeholder">
                                    <% if (p.getImmagine() != null && !p.getImmagine().isEmpty()) { %>
                                        <img src="<%= p.getImmagine() %>" alt="<%= p.getNome() %>" style="max-height:100%; max-width:100%;">
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
                                    <a class="btn-add-cart" href="carrello?action=add&id=<%= p.getIdProdotto() %>">Aggiungi</a>
                                </div>
                            </div>
                <%
                        }
                    } else {
                %>
                        <div class="no-products">
                            <p>Il catalogo è attualmente vuoto. Controlla che nella tabella 'prodotti' ci siano righe con attivo = 1!</p>
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
            
            <div class="widget-box bg-alt">
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