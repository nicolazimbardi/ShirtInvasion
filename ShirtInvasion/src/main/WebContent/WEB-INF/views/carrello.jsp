<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Carrello" %>
<%@ page import="model.Prodotto" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>ShirtInvasion - Il mio Carrello</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/stile.css">
</head>
<body>

<header class="main-header">
    <div class="logo">
        <h1>Shirt<span>Invasion</span> &#9917;</h1>
    </div>
    <nav class="nav-bar">
        <ul>
            <li><a href="${pageContext.request.contextPath}/home">Continua lo shopping</a></li>
            <li><a href="${pageContext.request.contextPath}/login">Accedi / Registrati</a></li>
        </ul>
    </nav>
</header>

<main class="main-container" style="margin-top: 40px;">
    <h2>Il mio Carrello</h2>

    <%
        Carrello carrello = (Carrello) session.getAttribute("carrello");
        List<Prodotto> elementi = (carrello != null) ? carrello.getElementi() : null;

        if (elementi == null || elementi.isEmpty()) {
    %>
        <div class="info-box" style="margin-top: 20px;">
            <h3>Il carrello è vuoto</h3>
            <p>Non hai ancora inserito prodotti nel carrello. <a href="${pageContext.request.contextPath}/home" style="color: #00a8ff; font-weight: bold;">Torna allo shopping</a>.</p>
        </div>
    <%
        } else {
    %>
        <p style="margin-bottom: 20px; color: #666;"><%= elementi.size() %> articolo/i nel carrello</p>

        <div class="cart-list">
            <%
                for (Prodotto p : elementi) {
            %>
                <div class="cart-item">
                    
                    <div class="cart-thumb-box">
                        <% if (p.getImmagine() != null && !p.getImmagine().isEmpty()) { %>
                            <img src="${pageContext.request.contextPath}/images/<%= p.getImmagine() %>" alt="<%= p.getNome() %>">
                        <% } else { %>
                            👕 <% } %>
                    </div>

                    <div class="cart-item-details">
                        <h3><%= p.getNome() %></h3>
                        <p><%= p.getMarca() %> &bull; <%= p.getSquadra() %> &bull; <%= p.getStagione() %></p>
                        <p>Taglia: <strong><%= p.getTaglia() %></strong></p>
                        <% if (p.getDescrizione() != null && !p.getDescrizione().isEmpty()) { %>
                            <p style="margin-top: 5px; font-style: italic;"><%= p.getDescrizione() %></p>
                        <% } %>
                    </div>

                    <div class="cart-item-right">
                        <div class="cart-item-price"><%= String.format("%.2f", p.getPrezzo() * p.getQuantitaCarrello()) %> €</div>
                        
                        <form action="${pageContext.request.contextPath}/CarrelloServlet" method="post" style="margin-bottom: 12px; display: flex; align-items: center; justify-content: flex-end; gap: 5px;">
                            <label for="qta_<%= p.getIdProdotto() %>" style="font-size: 13px; color: #666;">Q.tà:</label>
                            <input type="hidden" name="azione" value="aggiornaQta">
                            <input type="hidden" name="id" value="<%= p.getIdProdotto() %>">
                            <input type="number" id="qta_<%= p.getIdProdotto() %>" name="quantita" value="<%= p.getQuantitaCarrello() %>" min="1" max="20" 
                                   style="width: 55px; text-align: center; border: 1px solid #ccc; border-radius: 4px; padding: 4px; font-weight: 600;" 
                                   onchange="this.form.submit()">
                        </form>

                        <form action="${pageContext.request.contextPath}/CarrelloServlet" method="post">
                            <input type="hidden" name="azione" value="rimuovi">
                            <input type="hidden" name="id" value="<%= p.getIdProdotto() %>">
                            <button type="submit" class="btn-remove-item">Rimuovi</button>
                        </form>
                    </div>
                </div>
            <%
                }
            %>
        </div>

        <div class="cart-summary-box">
            <div class="cart-total-text">
                <h3>Totale: <%= String.format("%.2f", carrello.getPrezzoTotale()) %> €</h3>
            </div>

            <div class="cart-actions">
                <form action="${pageContext.request.contextPath}/CarrelloServlet" method="post" style="margin: 0;">
                    <input type="hidden" name="azione" value="svuota">
                    <button type="submit" class="btn-empty-cart">Svuota carrello</button>
                </form>

               <a href="${pageContext.request.contextPath}/CarrelloServlet?azione=checkout" class="btn-checkout-cart">Procedi al checkout</a>
            </div>
        </div>
    <%
        }
    %>
</main>

<footer class="main-footer">
    <p>&copy; 2026 ShirtInvasion. Tutti i diritti riservati. Sviluppato in Java Web MVC.</p>
</footer>

</body>
</html>