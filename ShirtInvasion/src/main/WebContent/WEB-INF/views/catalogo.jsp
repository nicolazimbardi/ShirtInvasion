<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Prodotto" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><%= request.getAttribute("campionato") %></title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/stile.css">
</head>

<body>

<header class="main-header">
    <div class="logo">
        <h1>Shirt<span>Invasion</span> ⚽</h1>
    </div>
</header>

<main class="main-container">

    <h2>
        Maglie:
        <%= request.getAttribute("campionato") %>
    </h2>

    <div class="products-grid">

        <%
        List<Prodotto> prodotti =
            (List<Prodotto>) request.getAttribute("prodotti");

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
                    <strong>
                        € <%= p.getPrezzo() %>
                    </strong>
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

</body>
</html>