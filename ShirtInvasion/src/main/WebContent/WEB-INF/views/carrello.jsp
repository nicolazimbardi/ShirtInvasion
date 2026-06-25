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
    <style>
        /* Stili aggiuntivi inline per i messaggi di errore */
        .is-invalid {
            border-color: #dc3545 !important;
            background-color: #fdf2f2 !important;
        }
        .error-message {
            color: #dc3545;
            font-size: 11px;
            font-weight: 600;
            margin-top: 4px;
            display: block;
        }

        /* Nuovi stili per sistemare l'anteprima delle maglie (sovrascrive stile.css) */
        .cart-thumb-box {
            width: 100px !important;
            height: 130px !important;
            background-color: #ffffff;
            border: 1px solid #eeeeee;
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }

        .cart-thumb-box img {
            width: 100%;
            height: 100%;
            object-fit: contain !important;
            padding: 5px;
            border-radius: 6px;
        }
    </style>
</head>
<body class="page-carrello">

<jsp:include page="header.jsp" />

<main class="main-container" style="margin-top: 40px;">
    <h2>Il mio Carrello</h2>

    <%-- INIZIO ALERT ERRORE STOCK --%>
    <%
        String erroreStock = (String) session.getAttribute("erroreStock");
        if (erroreStock != null) {
    %>
        <div style="background-color: #fef2f2; border: 1px solid #fca5a5; border-left: 5px solid #ef4444; padding: 15px; margin-bottom: 20px; border-radius: 6px;">
            <h4 style="color: #b91c1c; margin-top: 0; margin-bottom: 10px; font-size: 16px;">
                ⚠️ Attenzione: 
            </h4>
            <p style="color: #991b1b; margin: 0; font-size: 14px; line-height: 1.5;">
                <%= erroreStock %>
                <br><br>
                <em>Ti preghiamo di modificare le quantità nel carrello per poter procedere.</em>
            </p>
        </div>
    <%
            // Rimuoviamo l'errore dalla sessione dopo averlo mostrato
            session.removeAttribute("erroreStock");
        }
    %>
    <%-- FINE ALERT ERRORE STOCK --%>

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
            // Calcoliamo la quantità FISICA reale totale
            int totaleArticoliFisici = 0;
            for (Prodotto p : elementi) {
                totaleArticoliFisici += p.getQuantitaCarrello();
            }
    %>
        <p style="margin-bottom: 20px; color: #666; font-weight: 500;">
            <%= totaleArticoliFisici %> <%= (totaleArticoliFisici == 1) ? "articolo" : "articoli" %> nel carrello
        </p>

        <div class="cart-list">
            <%
                for (Prodotto p : elementi) {
            %>
                <div class="cart-item">
                    
                    <div class="cart-thumb-box">
                        <a href="${pageContext.request.contextPath}/DettaglioServlet?id=<%= p.getIdProdotto() %>" style="text-decoration: none; display: flex; justify-content: center; align-items: center; width: 100%; height: 100%;">
                            <% if (p.getImmagine() != null && !p.getImmagine().isEmpty()) { %>
                                <img src="${pageContext.request.contextPath}/images/<%= p.getImmagine() %>" alt="<%= p.getNome() %>">
                            <% } else { %>
                                👕
                            <% } %>
                        </a>
                    </div>

                    <div class="cart-item-details">
                        <h3>
                            <a href="${pageContext.request.contextPath}/DettaglioServlet?id=<%= p.getIdProdotto() %>" class="product-title-link">
                                <%= p.getNome() %>
                            </a>
                        </h3>
                        <p><%= p.getMarca() %> &bull; <%= p.getSquadra() %> &bull; <%= p.getStagione() %></p>
                        <p>Taglia: <strong><%= p.getTaglia() %></strong></p>
                        </div>

                    <div class="cart-item-right">
                        <div class="cart-item-price"><%= String.format("%.2f", p.getPrezzo() * p.getQuantitaCarrello()) %> €</div>
                        
                        <form action="${pageContext.request.contextPath}/CarrelloServlet" method="post" style="margin-bottom: 12px; display: flex; align-items: flex-start; justify-content: flex-end; gap: 5px;">
                        <input type="hidden" name="sessionToken" value="${sessionScope.sessionToken}">
                            <label for="qta_<%= p.getIdProdotto() %>" style="font-size: 13px; color: #666; margin-top: 6px;">Q.tà:</label>
                            <input type="hidden" name="azione" value="aggiornaQta">
                            <input type="hidden" name="id" value="<%= p.getIdProdotto() %>">
                            
                            <div style="display: flex; flex-direction: column; align-items: flex-end;">
                                <input type="number" id="qta_<%= p.getIdProdotto() %>" name="quantita" value="<%= p.getQuantitaCarrello() %>" min="1" max="20" 
                                       class="cart-qta-input"
                                       style="width: 55px; text-align: center; border: 1px solid #ccc; border-radius: 4px; padding: 4px; font-weight: 600;">
                            </div>
                        </form>

                        <form action="${pageContext.request.contextPath}/CarrelloServlet" method="post" style="text-align: right;">
                        <input type="hidden" name="sessionToken" value="${sessionScope.sessionToken}">
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
                <input type="hidden" name="sessionToken" value="${sessionScope.sessionToken}">
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

<script>
    document.addEventListener("DOMContentLoaded", function() {
        document.querySelectorAll('.cart-qta-input').forEach(function(input) {
            
            function validaQuantita(campo) {
                var valore = parseInt(campo.value);
                var min = parseInt(campo.getAttribute("min")) || 1;
                var max = parseInt(campo.getAttribute("max")) || 20;
                
                // Rimuove l'errore precedente
                campo.classList.remove("is-invalid");
                var errorePrecedente = campo.parentNode.querySelector(".error-message");
                if (errorePrecedente) errorePrecedente.remove();

                // Controlla validità
                if (isNaN(valore) || valore < min || valore > max) {
                    campo.classList.add("is-invalid");
                    
                    var errorSpan = document.createElement("span");
                    errorSpan.className = "error-message";
                    errorSpan.innerText = "Max: " + max;
                    
                    campo.parentNode.appendChild(errorSpan);
                    return false;
                }
                return true;
            }

            // Evento change per la validazione client side
            input.addEventListener('change', function(e) {
                if (validaQuantita(input)) {
                    input.form.submit(); // Submit sicuro solo se passa il check
                }
            });
        });
    });
</script>

</body>
</html>