<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Prodotto" %>

<!DOCTYPE html>
<html lang="it">
<head>
<meta charset="UTF-8">

<title><%= request.getAttribute("campionato") %> - ShirtInvasion</title>

<link rel="stylesheet"
      href="${pageContext.request.contextPath}/styles/stile.css">
</head>

<body>

<div id="menuOverlay" class="menu-overlay"></div>

<nav id="sidebarMenu" class="sidebar">

    <a href="javascript:void(0)" class="close-btn">&times;</a>

    <div class="sidebar-header">
        <h2>Campionati</h2>
    </div>

    <a href="${pageContext.request.contextPath}/campionato?nome=Serie A">
        Serie A
    </a>

    <a href="${pageContext.request.contextPath}/campionato?nome=Premier League">
        Premier League
    </a>

    <a href="${pageContext.request.contextPath}/campionato?nome=La Liga">
        La Liga
    </a>

    <a href="${pageContext.request.contextPath}/home"
       style="margin-top:20px;font-size:14px;color:#00a8ff;">
        ← Torna alla Home
    </a>

</nav>

<header class="main-header">

    <div class="logo" style="display:flex;align-items:center;">

        <button class="hamburger-btn" id="menuButton">
            &#9776;
        </button>
<h1 style="margin-left:15px;">
    <a href="${pageContext.request.contextPath}/home"
       style="text-decoration:none;color:white;">
        Shirt<span style="color:#00a8ff;">Invasion</span> ⚽
    </a>
</h1>

    </div>

</header>

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
        List<Prodotto> prodotti =
                (List<Prodotto>) request.getAttribute("prodotti");

        if(prodotti != null && !prodotti.isEmpty()) {

            for(Prodotto p : prodotti) {
        %>

        <div class="product-card">

            <div class="product-img-placeholder">

                <img
                src="${pageContext.request.contextPath}/images/<%= p.getImmagine() %>"
                alt="<%= p.getNome() %>">

            </div>

            <h3>

                <a class="product-title-link"
                   href="${pageContext.request.contextPath}/DettaglioServlet?id=<%= p.getIdProdotto() %>">

                    <%= p.getSquadra() %>

                </a>

            </h3>

            <p class="meta-info">
                <strong>Modello:</strong>
                <%= p.getNome() %>
            </p>

            <p class="meta-info">
                <strong>Stagione:</strong>
                <%= p.getStagione() %>
            </p>

            <p class="description">
                <%= p.getDescrizione() %>
            </p>

            <div class="card-footer">

                <span class="price">
                    € <%= String.format("%.2f", p.getPrezzo()) %>
                </span>

                <a class="btn-add-cart"
                   href="${pageContext.request.contextPath}/DettaglioServlet?id=<%= p.getIdProdotto() %>">

                    Dettagli

                </a>

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

<script src="${pageContext.request.contextPath}/scripts/menu.js"></script>

</body>
</html>