<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Ordine" %>
<%@ page import="model.DettaglioOrdine" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ShirtInvasion - I Miei Ordini</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/stile.css">
</head>
<body class="bg-light">

    <jsp:include page="header.jsp" />

    <main class="orders-page-container" style="margin-top: 40px;">
        <div class="orders-main-card">
            
            <h2 class="orders-title">Storico dei tuoi Ordini</h2>
            <hr class="orders-divider">
            
            <a href="${pageContext.request.contextPath}/home" class="back-to-shopping">← Torna allo Shopping</a>

            <div class="orders-list">
                
                <%
                    List<Ordine> listaOrdini = (List<Ordine>) request.getAttribute("listaOrdini");
                    if (listaOrdini == null || listaOrdini.isEmpty()) {
                %>
                    <p class="no-orders">Non hai ancora effettuato nessun ordine su ShirtInvasion.</p>
                <%
                    } else {
                        for (Ordine o : listaOrdini) {
                %>
                
                <div class="order-item-box">
                    <div class="order-item-header">
                        <div class="order-header-left">
                            <p><strong>DATA ORDINE:</strong> <%= o.getDataOrdine() %></p>
                            <p><strong>ID ORDINE:</strong> #<%= o.getIdOrdine() %></p>
                        </div>
                        <div class="order-header-right" style="text-align: right;">
                            <p><strong>STATO:</strong> <span class="status-orange"><%= o.getStato() %></span></p>
                            <p><strong>TOTALE PAGATO:</strong> <span class="total-red"><%= String.format("%.2f", o.getTotale()) %> €</span></p>
                        </div>
                    </div>
                    
                    <div class="order-item-body">
                        <h4>Articoli acquistati:</h4>
                        
                        <% for (DettaglioOrdine d : o.getDettagli()) { %>
                            <div class="order-product-row">
                                <span class="product-name"><strong><%= d.getQuantita() %>x</strong> <%= d.getNomeProdotto() %></span>
                                <span class="product-price"><%= String.format("%.2f", d.getPrezzoUnitario()) %> €/cad.</span>
                            </div>
                        <% } %>
                        
                    </div>
                </div>
                
                <%
                        }
                    }
                %>

            </div>
        </div>
    </main>

    <footer class="main-footer">
        <p>© 2026 ShirtInvasion. Tutti i diritti riservati. Sviluppato in Java Web MVC.</p>
    </footer>

</body>
</html>