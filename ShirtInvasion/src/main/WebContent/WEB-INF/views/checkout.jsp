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
    <style>
        /* Stili aggiuntivi inline per i messaggi di errore (per comodità) */
        .is-invalid {
            border-color: #dc3545 !important;
            background-color: #fdf2f2 !important;
        }
        .error-message {
            color: #dc3545;
            font-size: 12px;
            font-weight: 600;
            margin-top: 5px;
            display: block;
            text-align: left;
        }
    </style>
</head>
<body class="page-checkout">

    <div id="loading-overlay">
        <div class="spinner"></div>
        <h3 style="margin-top: 20px; color: #022340;">Elaborazione dell'ordine in corso...</h3>
        <p style="color: #666;">Ti stiamo reindirizzando al pagamento, non chiudere la pagina.</p>
    </div>

    <jsp:include page="header.jsp" />

    <main class="checkout-container" style="margin-top: 40px;">
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
                    <select id="indirizzoSelezionato" name="indirizzoSelezionato" onchange="gestisciNuovoIndirizzo()" required>
                        <option value="" disabled selected>-- Scegli un indirizzo --</option>
                        <% for(Indirizzo ind : listaIndirizzi) { %>
                            <option value="<%= ind.getIdIndirizzo() %>">
                                <%= ind.getVia() %>, <%= ind.getCitta() %> (<%= ind.getProvincia() %>) - <%= ind.getCap() %>
                                <%= ind.isAttivo() ? " [Principale]" : "" %>
                            </option>
                        <% } %>
                        <option value="nuovo" style="font-weight: bold; color: #00a8ff;">+ Aggiungi un nuovo indirizzo di spedizione...</option>
                    </select>
                </div>

                <div id="divNuovoIndirizzo" class="indirizzo-nuovo-container" style="display: none;">
                    <p style="font-weight: bold; margin-bottom: 15px; color: #022340;">Compila i dati del nuovo indirizzo:</p>
                    
                    <div class="form-group">
                        <input type="text" id="via_nuovo" name="via_nuovo" placeholder="Indirizzo (es. Via Roma, 10)">
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group form-col-2">
                            <input type="text" id="citta_nuovo" name="citta_nuovo" placeholder="Città">
                        </div>
                        <div class="form-group form-col">
                            <input type="text" id="cap_nuovo" name="cap_nuovo" placeholder="CAP" maxlength="5">
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group form-col">
                            <input type="text" id="provincia_nuovo" name="provincia_nuovo" placeholder="Provincia (Sigla)" maxlength="2" style="text-transform: uppercase;">
                        </div>
                        <div class="form-group form-col">
                            <input type="text" id="nazione_nuovo" name="nazione_nuovo" value="Italia" placeholder="Nazione" readonly style="background-color: #eee;">
                        </div>
                    </div>
                </div>

                <h3>2. Metodo di Pagamento</h3>
                <div class="form-group">
                    <select id="metodoPagamento" name="metodoPagamento" required>
                        <option value="" disabled selected>-- Seleziona un metodo di pagamento --</option>
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
<script>
    // Gestione della comparsa/scomparsa dei campi del nuovo indirizzo
    function gestisciNuovoIndirizzo() {
        var select = document.getElementById("indirizzoSelezionato");
        var divNuovo = document.getElementById("divNuovoIndirizzo");
        var campiNuovi = ["via_nuovo", "citta_nuovo", "cap_nuovo", "provincia_nuovo", "nazione_nuovo"];
        
        if (select.value === "nuovo") {
            divNuovo.style.display = "block";
            campiNuovi.forEach(id => document.getElementById(id).setAttribute("required", "true"));
        } else {
            divNuovo.style.display = "none";
            campiNuovi.forEach(id => {
                var campo = document.getElementById(id);
                campo.removeAttribute("required");
                rimuoviErrore(campo); // Pulisce eventuali errori residui se l'utente cambia idea
            });
        }
        
        // Valida subito la select dell'indirizzo appena cambia
        validaCampo(select);
    }

    // --- FUNZIONI DI VALIDAZIONE DOM (Richieste dal Professore) ---

    // Funzione per mostrare l'errore nel DOM
    function mostraErrore(input, messaggio) {
        rimuoviErrore(input); // Evita duplicati
        
        input.classList.add("is-invalid"); 
        
        var errorSpan = document.createElement("span");
        errorSpan.className = "error-message";
        errorSpan.innerText = messaggio;
        
        input.parentNode.appendChild(errorSpan);
    }

    // Funzione per rimuovere l'errore dal DOM
    function rimuoviErrore(input) {
        input.classList.remove("is-invalid");
        var contenitore = input.parentNode;
        var erroreEsistente = contenitore.querySelector(".error-message");
        if (erroreEsistente) {
            contenitore.removeChild(erroreEsistente);
        }
    }

    // Funzione core che valida un singolo campo
    function validaCampo(input) {
        // Controllo generico campi obbligatori vuoti o opzioni di default nelle select
        if (input.hasAttribute("required") && (input.value.trim() === "" || input.value === null)) {
            
            // Messaggi personalizzati in base al tipo di campo
            if(input.id === "indirizzoSelezionato") {
                mostraErrore(input, "Devi selezionare un indirizzo di spedizione.");
            } else if (input.id === "metodoPagamento") {
                mostraErrore(input, "Devi selezionare un metodo di pagamento.");
            } else {
                mostraErrore(input, "Questo campo è obbligatorio.");
            }
            return false;
        }

        // Controllo specifico sul CAP (deve essere di 5 cifre numeriche)
        if (input.id === "cap_nuovo" && input.hasAttribute("required") && input.value.trim() !== "") {
            var capPattern = /^[0-9]{5}$/;
            if (!capPattern.test(input.value.trim())) {
                mostraErrore(input, "Il CAP deve essere composto da 5 cifre numeriche.");
                return false;
            }
        }

        // Controllo specifico sulla Provincia (es: RM, NA, MI - 2 lettere)
        if (input.id === "provincia_nuovo" && input.hasAttribute("required") && input.value.trim() !== "") {
            var provPattern = /^[A-Za-z]{2}$/;
            if (!provPattern.test(input.value.trim())) {
                mostraErrore(input, "Usa la sigla di 2 lettere (es. RM, NA).");
                return false;
            }
        }

        // Se passa tutti i controlli
        rimuoviErrore(input);
        return true;
    }

    // --- ASSOCIAZIONE EVENTI ---

    var form = document.getElementById('checkout-form');
    // Selezioniamo tutti gli input e select (indirizzo, pagamento, nuovi campi)
    var campiDaValidare = form.querySelectorAll('input[type="text"], select');

    // 1. EVENTO CHANGE: Valida quando l'utente termina l'inserimento
    campiDaValidare.forEach(function(campo) {
        campo.addEventListener('change', function() {
            validaCampo(campo);
        });
    });

    // 2. EVENTO SUBMIT: Controllo globale prima dell'invio definitivo
    form.addEventListener('submit', function(e) {
        e.preventDefault(); // Blocca l'invio
        
        var formValido = true;
        
        // Controlla tutti i campi uno per uno
        campiDaValidare.forEach(function(campo) {
            if (!validaCampo(campo)) {
                formValido = false;
            }
        });

        // Se tutti i campi sono validi, mostra il caricamento e invia
        if (formValido) {
            document.getElementById('loading-overlay').style.display = 'flex';
            setTimeout(() => { 
                form.submit(); 
            }, 2000);
        } else {
            // Scorri la pagina fino al primo errore
            var primoErrore = document.querySelector('.is-invalid');
            if (primoErrore) {
                primoErrore.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
        }
    });
</script>

</body>
</html>