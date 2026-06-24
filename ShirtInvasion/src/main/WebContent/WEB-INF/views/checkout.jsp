<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Carrello" %>
<%@ page import="model.Prodotto" %>
<%@ page import="model.Utente" %>
<%@ page import="model.Indirizzo" %>
<%@ page import="dao.IndirizzoDAO" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ShirtInvasion - Checkout</title>
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/stile.css?v=2">
</head>
<body class="page-checkout">

    <div id="loading-overlay">
        <div class="spinner"></div>
        <h3 style="margin-top: 20px; color: #022340;">Elaborazione dell'ordine in corso...</h3>
        <p style="color: #666;">Ti stiamo reindirizzando al pagamento, non chiudere la pagina.</p>
    </div>

   <header class="main-header">
        <div class="logo">
            <h1>Shirt<span>Invasion</span> &#9917;</h1>
        </div>
        <nav class="nav-bar">
            <ul>
                <li><a href="${pageContext.request.contextPath}/CarrelloServlet">Torna al Carrello</a></li>
            </ul>
        </nav>
    </header>

    <main class="checkout-container">
        <%
            Carrello carrello = (Carrello) session.getAttribute("carrello");
            Utente utente = (Utente) session.getAttribute("utente");
            if (carrello == null || carrello.getElementi().isEmpty() || utente == null) {
                response.sendRedirect(request.getContextPath() + "/CarrelloServlet");
                return;
            }

            IndirizzoDAO indDao = new IndirizzoDAO();
            List<Indirizzo> listaIndirizzi = indDao.doRetrieveByUtente(utente.getIdUtente());

            double totaleProdotti = carrello.getPrezzoTotale();
            double costoSpedizione = (totaleProdotti >= 90.0) ? 0.0 : 5.00;
            double totaleFinale = totaleProdotti + costoSpedizione;
        %>

        <div class="checkout-box checkout-form-section">
            <h2>Dettagli Spedizione e Pagamento</h2>
            
            <form id="checkout-form" action="${pageContext.request.contextPath}/CarrelloServlet" method="post" novalidate>
                <input type="hidden" name="azione" value="confermaAcquisto">
                <input type="hidden" name="totaleFinale" value="<%= totaleFinale %>">
                
                <h3>1. Indirizzo di Spedizione</h3>
                <div class="form-group">
                    <label for="indirizzoSelezionato">Seleziona dove spedire il pacco:</label>
                    <select id="indirizzoSelezionato" name="indirizzoSelezionato" onchange="gestisciNuovoIndirizzo()">
                        <option value="" disabled selected>-- Scegli un indirizzo --</option>
                        <% for(Indirizzo ind : listaIndirizzi) { %>
                            <option value="<%= ind.getIdIndirizzo() %>">
                                <%= ind.getVia() %>, <%= ind.getCitta() %> (<%= ind.getProvincia() %>) - <%= ind.getCap() %>
                                <%= ind.isAttivo() ? " [Principale]" : "" %>
                            </option>
                        <% } %>
                        <option value="nuovo" style="font-weight: bold; color: #00a8ff;">+ Aggiungi un nuovo indirizzo di spedizione...</option>
                    </select>
                    <span id="errSelezionato" class="error-msg">Seleziona un indirizzo per continuare.</span>
                </div>

                <div id="divNuovoIndirizzo" class="indirizzo-nuovo-container" style="display: none;">
                    <p style="font-weight: bold; margin-bottom: 15px; color: #022340;">Compila i dati del nuovo indirizzo:</p>
                    
                    <div class="form-group">
                        <input type="text" id="via_nuovo" name="via_nuovo" placeholder="Indirizzo (es. Via Roma, 10)">
                        <span id="errVia" class="error-msg">Inserisci la via.</span>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group form-col-2">
                            <input type="text" id="citta_nuovo" name="citta_nuovo" placeholder="Città">
                            <span id="errCitta" class="error-msg">Inserisci la città.</span>
                        </div>
                        <div class="form-group form-col">
                            <input type="text" id="cap_nuovo" name="cap_nuovo" placeholder="CAP" maxlength="5">
                            <span id="errCap" class="error-msg">CAP non valido (5 numeri).</span>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group form-col">
                            <input type="text" id="provincia_nuovo" name="provincia_nuovo" placeholder="Provincia (Sigla)" maxlength="2" style="text-transform: uppercase;">
                            <span id="errProv" class="error-msg">Sigla non valida (2 lettere).</span>
                        </div>
                        <div class="form-group form-col">
                            <input type="text" id="nazione_nuovo" name="nazione_nuovo" value="Italia" placeholder="Nazione" readonly style="background-color: #eee;">
                        </div>
                    </div>
                </div>

                <h3>2. Metodo di Pagamento</h3>
                <div class="form-group">
                    <select id="metodoPagamento" name="metodoPagamento">
                        <option value="paypal">PayPal</option>
                        <option value="contrassegno">Pagamento alla Consegna</option>
                    </select>
                </div>

                <button type="submit" class="btn-confirm-pay">Conferma e Paga</button>
            </form>
        </div>

        <div class="checkout-box checkout-summary-section">
            <h2>Riepilogo Ordine</h2>
            <div style="margin-bottom: 20px;">
                <% for (Prodotto p : carrello.getElementi()) { %>
                    <div class="summary-item">
                        <span><%= p.getQuantitaCarrello() %>x <%= p.getNome() %></span>
                        <span><%= String.format("%.2f", p.getPrezzo() * p.getQuantitaCarrello()) %> €</span>
                    </div>
                <% } %>
            </div>

            <div class="summary-row">
                <span>Subtotale:</span>
                <span><%= String.format("%.2f", totaleProdotti) %> €</span>
            </div>
            <div class="summary-row">
                <span>Spedizione:</span>
                <span style="color: <%= (costoSpedizione == 0) ? "#00a8ff; font-weight: bold;" : "#555" %>">
                    <%= (costoSpedizione == 0) ? "GRATIS" : String.format("%.2f", costoSpedizione) + " €" %>
                </span>
            </div>
            
            <div class="summary-total">
                <span>Totale:</span>
                <span><%= String.format("%.2f", totaleFinale) %> €</span>
            </div>
        </div>

    </main>

    <script src="${pageContext.request.contextPath}/scripts/checkout.js"></script>

</body>
</html>