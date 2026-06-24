<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Prodotto" %>

<!DOCTYPE html>
<html lang="it">
<head>
<meta charset="UTF-8">
<title><%= request.getAttribute("campionato") %> - ShirtInvasion</title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/stile.css">
</head>

<body>

<div id="menuOverlay" class="menu-overlay" onclick="closeSidebar()"></div>

<nav id="sidebarMenu" class="sidebar">
    <a href="javascript:void(0)" class="close-btn" onclick="closeSidebar()">&times;</a>
    <div class="sidebar-header">
        <h2>Campionati</h2>
    </div>
    
    <a href="${pageContext.request.contextPath}/campionato?nome=Serie A">Serie A</a>
    <a href="${pageContext.request.contextPath}/campionato?nome=Premier League">Premier League</a>
    <a href="${pageContext.request.contextPath}/campionato?nome=La Liga">La Liga</a>
    
    <a href="${pageContext.request.contextPath}/home" style="margin-top: 20px; font-size: 14px; color: #00a8ff;">← Torna alla Home</a>
</nav>

<header class="main-header">
    <div class="logo" style="display: flex; align-items: center;">
        <button class="hamburger-btn" onclick="openSidebar()">&#9776;</button>
        <h1 style="margin-left: 15px;">Shirt<span>Invasion</span> ⚽</h1>
    </div>
</header>

<main class="main-container">

    <h2>
        Maglie: <%= request.getAttribute("campionato") %>
    </h2>

    <div class="products-grid">
        <%
        List<Prodotto> prodotti = (List<Prodotto>) request.getAttribute("prodotti");

        if(prodotti != null && !prodotti.isEmpty()) {
            for(Prodotto p : prodotti) {
        %>
        <div class="product-card">
            <a href="${pageContext.request.contextPath}/DettaglioServlet?id=<%= p.getIdProdotto() %>">
                <img
                    src="${pageContext.request.contextPath}/images/<%= p.getImmagine() %>"
                    alt="<%= p.getNome() %>"
                    style="width:220px;height:220px;object-fit:cover;">
                <h3><%= p.getSquadra() %></h3>
                <p><%= p.getNome() %></p>
                <p>
                    <strong>€ <%= String.format("%.2f", p.getPrezzo()) %></strong>
                </p>
            </a>
        </div>
        <%
            }
        } else {
        %>
            <p>Nessuna maglia trovata per questo campionato.</p>
        <%
        }
        %>
    </div>

</main>

<script>
    function openSidebar() {
        document.getElementById("sidebarMenu").classList.add("open");
        document.getElementById("menuOverlay").classList.add("show");
    }

    function closeSidebar() {
        document.getElementById("sidebarMenu").classList.remove("open");
        document.getElementById("menuOverlay").classList.remove("show");
    }
</script>

</body>
</html>