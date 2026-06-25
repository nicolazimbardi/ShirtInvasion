<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Prodotto" %>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title><%= request.getAttribute("campionato") %> - ShirtInvasion</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/stile.css?v=<%= System.currentTimeMillis() %>">
</head>

<body>

<!-- Inclusione dell'header e della sidebar centralizzati -->
<jsp:include page="header.jsp" />

<div class="hero-picture">
    <div class="hero-text">
        <h2><%= request.getAttribute("campionato") %></h2>
        <p>Esplora tutte le maglie disponibili</p>
    </div>
</div>

<main class="main-container">

    <h2>Catalogo</h2>

    <div class="products-grid">

        <%
        List<Prodotto> prodotti = (List<Prodotto>) request.getAttribute("prodotti");

        if(prodotti != null && !prodotti.isEmpty()) {
            for(Prodotto p : prodotti) {
        %>

        <div class="product-card <%= p.getQuantita() == 0 ? "sold" : "" %>">
            <div class="product-img-placeholder">
                <img src="${pageContext.request.contextPath}/images/<%= p.getImmagine() %>" alt="<%= p.getNome() %>">
            </div>

            <h3>
                <a class="product-title-link" href="${pageContext.request.contextPath}/DettaglioServlet?id=<%= p.getIdProdotto() %>">
                    <%= p.getSquadra() %>
                </a>
            </h3>

            <p class="meta-info">
                <strong>Modello:</strong> <%= p.getNome() %>
            </p>

            <p class="meta-info">
                <strong>Stagione:</strong> <%= p.getStagione() %>
            </p>

            <p class="description">
                <%= p.getDescrizione() %>
            </p>

            <div class="card-footer">
                <span class="price">
                    € <%= String.format("%.2f", p.getPrezzo()) %>
                </span>

                <% if(p.getQuantita() > 0) { %>
                    <a class="btn-add-cart" href="${pageContext.request.contextPath}/DettaglioServlet?id=<%= p.getIdProdotto() %>">
                        Dettagli
                    </a>
                <% } else { %>
                    <span class="sold-out">
                        VENDUTO
                    </span>
                <% } %>
            </div>
        </div>

        <%
            }
        } else {
        %>

        <p class="no-products">
            Nessuna maglia trovata per questo campionato.
        </p>

        <%
        }
        %>

    </div>

</main>

<footer class="main-footer">
    <p>&copy; 2026 ShirtInvasion - Tutti i diritti riservati.</p>
</footer>

</body>
</html>