<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Carrello" %>
<%@ page import="model.Prodotto" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>ShirtInvasion - Il mio Carrello</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

<header style="background: #0d2c47; padding: 20px; color: white; display: flex; justify-content: space-between; align-items: center;">
    <h1 style="margin:0;">Shirt<span class="highlight">Invasion</span> &#9917;</h1>
    <nav>
        <a href="<%= request.getContextPath() %>/home" style="color: white; text-decoration: none; margin-right: 20px;">Continua lo shopping</a>
        <a href="<%= request.getContextPath() %>/login" style="color: white; text-decoration: none;">Accedi / Registrati</a>
    </nav>
</header>

<section class="carrello" style="max-width: 1000px; margin: 40px auto; padding: 20px; background: white; font-family: sans-serif;">
    <h2>Il mio Carrello</h2>

    <%
        // Recuperiamo il carrello e la lista degli elementi usando Java puro
        Carrello carrello = (Carrello) session.getAttribute("carrello");
        List<Prodotto> elementi = (carrello != null) ? carrello.getElementi() : null;

        if (elementi == null || elementi.isEmpty()) {
    %>
        <p class="carrello-vuoto">
            Il carrello è vuoto.
            <a href="<%= request.getContextPath() %>/home">Torna alle maglie disponibili</a>.
        </p>
    <%
        } else {
    %>
        <p><%= elementi.size() %> articolo/i nel carrello</p>

        <%
            // Ciclo Java classico per iterare sui prodotti
            for (Prodotto p : elementi) {
        %>
            <div class="carrello-item" style="border-bottom: 1px solid #ddd; padding: 15px 0;">
                <% if (p.getImmagine() != null && !p.getImmagine().isEmpty()) { %>
                    <img src="<%= request.getContextPath() %>/images/<%= p.getImmagine() %>" alt="<%= p.getNome() %>" class="carrello-thumb" style="width: 80px;">
                <% } %>

                <h3><%= p.getNome() %></h3>
                <p><%= p.getMarca() %> &bull; <%= p.getSquadra() %> &bull; <%= p.getStagione() %></p>
                
                <% if (p.getDescrizione() != null && !p.getDescrizione().isEmpty()) { %>
                    <p><%= p.getDescrizione() %></p>
                <% } %>
                
                <p>Taglia: <%= p.getTaglia() %></p>
                <p>Prezzo: <%= String.format("%.2f", p.getPrezzo()) %> €</p>

                <form action="<%= request.getContextPath() %>/CarrelloServlet" method="post">
                    <input type="hidden" name="azione" value="rimuovi">
                    <input type="hidden" name="id" value="<%= p.getIdProdotto() %>">
                    <button type="submit" class="btn-rimuovi" style="color: red; background: none; border: none; cursor: pointer; font-weight: bold;">Rimuovi</button>
                </form>
            </div>
        <%
            } // Fine del ciclo for
        %>

        <div class="carrello-totale" style="text-align: right; margin-top: 20px; font-size: 1.3rem;">
            <h3>Totale: <%= String.format("%.2f", carrello.getPrezzoTotale()) %> €</h3>
        </div>

        <div style="text-align: right; margin-top: 20px;">
            <form action="<%= request.getContextPath() %>/CarrelloServlet" method="post" style="display:inline; margin-right: 20px;">
                <input type="hidden" name="azione" value="svuota">
                <button type="submit" class="btn-svuota" style="background: none; border: 1px solid #ccc; padding: 10px; cursor: pointer;">Svuota carrello</button>
            </form>

            <a href="<%= request.getContextPath() %>/checkout" class="btn-checkout" style="background-color: #00bcd4; color: white; padding: 12px 25px; text-decoration: none; border-radius: 4px; display: inline-block;">Procedi al checkout</a>
        </div>
    <%
        } // Fine del blocco else
    %>
</section>

<footer>
    <p style="text-align: center; margin-top: 40px; color: #666;">&copy; 2026 ShirtInvasion. Tutti i diritti riservati. Sviluppato in Java Web MVC.</p>
</footer>

</body>
</html>