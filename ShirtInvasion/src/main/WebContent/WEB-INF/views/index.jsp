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
    <link rel="stylesheet" href="styles/stile.css?v=<%= System.currentTimeMillis() %>">
    
    <script>
        const contextPath = "${pageContext.request.contextPath}";
    </script>
    
    <script src="scripts/ajax.js" defer></script>
</head>
<body>

    <jsp:include page="header.jsp" />

    <%
        String selMarca = (String) request.getAttribute("selMarca");
        String selTaglia = (String) request.getAttribute("selTaglia");
        String selOrdine = (String) request.getAttribute("selOrdine");
        Utente utenteLoggato = (Utente) session.getAttribute("utente");
    %>

  <div class="hero-picture">
        <div class="hero-text">
            <h2>Campioni sul Campo, Unici nello Stile</h2>
            <p>Trova le maglie da calcio più iconiche di sempre per la tua collezione.</p>
            
            <div class="search-box-container" style="max-width: 600px; margin: 0 auto; position: relative;">
                <form action="${pageContext.request.contextPath}/RicercaServlet" method="GET">
                    <input type="text" id="searchBar" name="testo" autocomplete="off" placeholder="Cerca una maglia o una squadra..." style="width: 100%; padding: 15px 25px; font-size: 1em; border: none; border-radius: 50px; box-shadow: 0 4px 15px rgba(0,0,0,0.2); outline: none;">
                </form>
                <div id="suggerimentiBox" style="display: none; position: absolute; top: 100%; left: 0; right: 0; background: white; border-radius: 8px; box-shadow: 0 4px 20px rgba(0,0,0,0.2); z-index: 9999; max-height: 350px; overflow-y: auto; text-align: left; margin-top: 8px; color: #333333;"></div>
            </div>
        </div>
    </div>

    <div class="catalog-header-bar">
        <h2>Maglie Disponibili</h2>
        
        <form action="${pageContext.request.contextPath}/home" method="GET" class="filter-form">
            <div class="select-group">
                <select name="marca" class="filter-select">
                    <option value="">Tutte le marche</option>
                    <option value="Adidas" <%= "Adidas".equals(selMarca) ? "selected" : "" %>>Adidas</option>
                    <option value="EA7" <%= "EA7".equals(selMarca) ? "selected" : "" %>>EA7</option>
                    <option value="Joma" <%= "Joma".equals(selMarca) ? "selected" : "" %>>Joma</option>
                    <option value="Lotto" <%= "Lotto".equals(selMarca) ? "selected" : "" %>>Lotto</option>
                    <option value="Macron" <%= "Macron".equals(selMarca) ? "selected" : "" %>>Macron</option>
                    <option value="Nike" <%= "Nike".equals(selMarca) ? "selected" : "" %>>Nike</option>
                    <option value="Puma" <%= "Puma".equals(selMarca) ? "selected" : "" %>>Puma</option>
                    <option value="Umbro" <%= "Umbro".equals(selMarca) ? "selected" : "" %>>Umbro</option>
                </select>

                <select name="taglia" class="filter-select">
                    <option value="">Tutte le taglie</option>
                    <option value="2XS" <%= "2XS".equals(selTaglia) ? "selected" : "" %>>2XS</option>
                    <option value="S" <%= "S".equals(selTaglia) ? "selected" : "" %>>S</option>
                    <option value="M" <%= "M".equals(selTaglia) ? "selected" : "" %>>M</option>
                    <option value="L" <%= "L".equals(selTaglia) ? "selected" : "" %>>L</option>
                    <option value="XL" <%= "XL".equals(selTaglia) ? "selected" : "" %>>XL</option>
                    <option value="2XL" <%= "2XL".equals(selTaglia) ? "selected" : "" %>>2XL</option>
                    <option value="3XL" <%= "3XL".equals(selTaglia) ? "selected" : "" %>>3XL</option>
                </select>

                <select name="ordine" class="filter-select">
                    <option value="">Ordina per</option>
                    <option value="ASC" <%= "ASC".equals(selOrdine) ? "selected" : "" %>>Prezzo: Crescente</option>
                    <option value="DESC" <%= "DESC".equals(selOrdine) ? "selected" : "" %>>Prezzo: Decrescente</option>
                </select>
            </div>

            <div class="button-group">
                <button type="submit" class="btn-filter-apply">Applica</button>
                <a href="${pageContext.request.contextPath}/home" class="btn-filter-reset">Resetta</a>
            </div>
        </form>
    </div>
    
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
                            <a href="${pageContext.request.contextPath}/DettaglioServlet?id=<%= p.getIdProdotto() %>">
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
                                    <p style="color:#dc3545;font-weight:bold;margin-top:5px;font-size:14px;">Non disponibile</p>
                                <% } %>
                            </div>

                            <% if (p.getQuantita() <= 0) { %>
                                <span style="background-color: #777777; color: white; padding: 6px 12px; font-size: 12px; font-weight: bold; border-radius: 4px;">VENDUTO</span>
                            <% } else if (utenteLoggato == null || !"ADMIN".equalsIgnoreCase(utenteLoggato.getRuolo())) { %>
                                <a class="btn-add-cart" href="CarrelloServlet?azione=aggiungi&id=<%= p.getIdProdotto() %>">Aggiungi</a>
                            <% } else { %>
                                <span style="color: gray; font-size: 0.8em; font-weight: bold;">(Admin)</span>
                            <% } %>
                        </div>
                    </div>
        <%
                }
            } else {
        %>
                <div style="grid-column: 1 / -1; text-align: center; padding: 50px; font-size: 18px; color: #666;">
                    <p>Nessun prodotto soddisfa i criteri.</p>
                </div>
        <%
            }
        %>
    </div>

    <aside class="content-news" style="max-width: 1200px; margin: 20px auto; padding: 20px;">
        <div class="widget-box express-shipping-large">
            <h3>📦 Spedizione Express</h3>
            <p>La passione per il calcio non può attendere! Garantiamo una spedizione totalmente gratuita per tutti gli ordini superiori a 90€.</p>
            <p>Il nostro servizio di logistica elabora gli acquisti in tempo reale: riceverai la tua maglia da collezione comodamente a casa tua entro 24/48 ore lavorative tramite corriere espresso tracciato.</p>
        </div>
    </aside>

    <footer class="main-footer">
        <p>&copy; 2026 ShirtInvasion. Tutti i diritti riservati. Sviluppato in Java Web MVC.</p>
    </footer>

</body>
</html>