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
<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/stile.css">
<style>
#loading-overlay {
position: fixed; top: 0; left: 0; width: 100%; height: 100%;
background: rgba(255, 255, 255, 0.9);
display: flex; flex-direction: column; justify-content: center; align-items: center;
z-index: 9999; display: none;
}
.spinner {
width: 50px; height: 50px;
border: 5px solid #ccc; border-top: 5px solid #00bcd4;
border-radius: 50%; animation: spin 1s linear infinite;
}
@keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
.form-group { margin-bottom: 15px; }
.form-group label { display: block; font-weight: bold; margin-bottom: 5px; color: #333; font-size: 14px;}
.form-group select, .form-group input { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; font-family: inherit;}
.indirizzo-nuovo-container { background: #f9f9f9; padding: 15px; border: 1px dashed #bbb; border-radius: 6px; margin-top: 15px; }
</style>
</head>
<body class="page-checkout">

<div id="loading-overlay">
<div class="spinner"></div>
<h3 style="margin-top: 20px; color: #0d2c47;">Elaborazione del pagamento in corso...</h3>
<p style="color: #666;">Non chiudere la pagina.</p>
</div>

<header class="main-header" style="background-color: #0d2c47; padding: 15px; color: white; text-align: center;">
<div class="logo"><h1 style="margin: 0;">Shirt<span>Invasion</span> &#9917;</h1></div>
<nav class="nav-bar" style="margin-top: 10px;">
<a href="${pageContext.request.contextPath}/CarrelloServlet" style="color: white; text-decoration: none; font-weight: bold;">Torna al Carrello</a>
</nav>
</header>

<main class="main-container" style="margin-top: 40px; display: flex; gap: 30px; flex-wrap: wrap; padding: 0 20px; max-width: 1200px; margin-left: auto; margin-right: auto;">
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

<div class="checkout-form-section" style="flex: 2; min-width: 300px; background: #fff; padding: 25px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);">
<h2 style="color: #0d2c47;">Dettagli Spedizione e Pagamento</h2>
<form id="checkout-form" action="${pageContext.request.contextPath}/CarrelloServlet" method="post">
<input type="hidden" name="azione" value="confermaAcquisto">
<input type="hidden" name="totaleFinale" value="<%= totaleFinale %>">
<h3 style="margin-top: 20px; color: #333; border-bottom: 2px solid #eee; padding-bottom: 5px;">1. Indirizzo di Spedizione</h3>
<div class="form-group">
<label for="indirizzoSelezionato">Seleziona dove spedire il pacco:</label>
<select id="indirizzoSelezionato" name="indirizzoSelezionato" onchange="gestisciNuovoIndirizzo()" required>
<option value="" disabled selected>-- Scegli un indirizzo --</option>
<% for(Indirizzo ind : listaIndirizzi) { %>
<option value="<%= ind.getIdIndirizzo() %>">
<%= ind.getVia() %>, <%= ind.getCitta() %> (<%= ind.getProvincia() %>) - <%= ind.getCap() %>
<%= ind.isAttivo() ? " [Principale]" : "" %>
</option>
<% } %>
<option value="nuovo" style="font-weight: bold; color: #00bcd4;">+ Aggiungi un nuovo indirizzo di spedizione...</option>
</select>
</div>
<div id="divNuovoIndirizzo" class="indirizzo-nuovo-container" style="display: none;">
<p style="font-weight: bold; margin-bottom: 15px; color: #555;">Compila i dati del nuovo indirizzo:</p>
<div class="form-group">
<input type="text" id="via_nuovo" name="via_nuovo" placeholder="Indirizzo (es. Via Roma, 10)">
</div>
<div style="display: flex; gap: 15px;">
<div class="form-group" style="flex: 2;">
<input type="text" id="citta_nuovo" name="citta_nuovo" placeholder="Città">
</div>
<div class="form-group" style="flex: 1;">
<input type="text" id="cap_nuovo" name="cap_nuovo" placeholder="CAP">
</div>
</div>
<div style="display: flex; gap: 15px;">
<div class="form-group" style="flex: 1;">
<input type="text" id="provincia_nuovo" name="provincia_nuovo" placeholder="Provincia (es. MI)">
</div>
<div class="form-group" style="flex: 1;">
<input type="text" id="nazione_nuovo" name="nazione_nuovo" value="Italia" placeholder="Nazione">
</div>
</div>
</div>

<h3 style="margin-top: 30px; color: #333; border-bottom: 2px solid #eee; padding-bottom: 5px;">2. Metodo di Pagamento</h3>
<div class="form-group">
<select name="metodoPagamento" required>
<option value="carta">Carta di Credito / Debito</option>
<option value="paypal">PayPal</option>
<option value="contrassegno">Pagamento alla Consegna</option>
</select>
</div>

<button type="submit" style="width: 100%; margin-top: 25px; font-size: 18px; font-weight: bold; cursor:pointer; padding: 15px; background:#00a8ff; color: white; border: none; border-radius: 4px; transition: 0.3s;">
Conferma e Paga
</button>
</form>
</div>

<div class="checkout-summary-section" style="flex: 1; min-width: 300px; background: #fafafa; padding: 25px; border-radius: 8px; border: 1px solid #ddd; height: fit-content;">
<h2 style="color: #0d2c47;">Riepilogo Ordine</h2>
<hr style="margin: 15px 0; border:0; border-top: 1px solid #ddd;">
<ul style="list-style: none; padding: 0; margin: 0; margin-bottom: 15px;">
<% for (Prodotto p : carrello.getElementi()) { %>
<li style="display: flex; justify-content: space-between; margin-bottom: 10px; font-size: 14px; border-bottom: 1px dashed #ccc; padding-bottom: 5px;">
<span><%= p.getQuantitaCarrello() %>x <%= p.getNome() %></span>
<span><%= String.format("%.2f", p.getPrezzo() * p.getQuantitaCarrello()) %> €</span>
</li>
<% } %>
</ul>

<div style="display: flex; justify-content: space-between; margin-bottom: 10px; color:#555;">
<span>Subtotale:</span>
<span><%= String.format("%.2f", totaleProdotti) %> €</span>
</div>
<div style="display: flex; justify-content: space-between; margin-bottom: 15px; color:#555;">
<span>Spedizione:</span>
<span><%= (costoSpedizione == 0) ? "GRATIS" : String.format("%.2f", costoSpedizione) + " €" %></span>
</div>
<hr style="margin: 15px 0; border:0; border-top: 1px solid #ddd;">
<div style="display: flex; justify-content: space-between; font-size: 22px; color: #0d2c47; font-weight: bold;">
<span>Totale:</span>
<span><%= String.format("%.2f", totaleFinale) %> €</span>
</div>
</div>

</main>

<script>
function gestisciNuovoIndirizzo() {
var select = document.getElementById("indirizzoSelezionato");
var divNuovo = document.getElementById("divNuovoIndirizzo");
var campiNuovi = ["via_nuovo", "citta_nuovo", "cap_nuovo", "provincia_nuovo", "nazione_nuovo"];

if (select.value === "nuovo") {
divNuovo.style.display = "block";
campiNuovi.forEach(id => document.getElementById(id).setAttribute("required", "true"));
} else {
divNuovo.style.display = "none";
campiNuovi.forEach(id => document.getElementById(id).removeAttribute("required"));
}
}

document.getElementById('checkout-form').addEventListener('submit', function(e) {
e.preventDefault();
document.getElementById('loading-overlay').style.display = 'flex';
setTimeout(() => { this.submit(); }, 2500);
});
</script>

</body>
</html>