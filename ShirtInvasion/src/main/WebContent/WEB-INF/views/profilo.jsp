<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Utente" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Indirizzo" %>
<%@ page import="dao.IndirizzoDAO" %>
<%
    // Controllo Sessione
    Utente utente = (Utente) session.getAttribute("utente");
    if (utente == null) {
        response.sendRedirect(request.getContextPath() + "/LoginServlet");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Il Mio Profilo - ShirtInvasion</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/stile.css">
</head>
<body>

    <div class="profilo-container">
        
        <h2>Gestione Profilo</h2>
        <form id="profiloForm" action="${pageContext.request.contextPath}/AggiornaProfiloServlet" method="POST" onsubmit="return validaProfilo()">
            <input type="hidden" name="idUtente" value="<%= utente.getIdUtente() %>">
            
            <label>Nome:</label>
            <input type="text" id="nome" name="nome" value="<%= utente.getNome() %>">
            <span id="errNome" style="color:red; display:none;">Inserisci un nome valido.</span>

            <label>Cognome:</label>
            <input type="text" id="cognome" name="cognome" value="<%= utente.getCognome() %>">
            <span id="errCognome" style="color:red; display:none;">Inserisci un cognome valido.</span>

            <label>Email:</label>
            <input type="email" id="email" name="email" value="<%= utente.getEmail() %>">
            <span id="errEmail" style="color:red; display:none;">Inserisci un'email valida.</span>

            <label>Telefono:</label>
            <input type="text" id="telefono" name="telefono" value="<%= utente.getTelefono() != null ? utente.getTelefono() : "" %>">
            <span id="errTelefono" style="color:red; display:none;">Inserisci un numero di telefono valido.</span>

            <label>Nuova Password (lascia vuoto per non cambiare):</label>
            <input type="password" id="password" name="password">
            <span id="errPassword" style="color:red; display:none;">La password deve essere di almeno 6 caratteri.</span>

            <button type="submit" class="btn-salva">Salva Modifiche Profilo</button>
        </form>

        <hr style="margin: 40px 0; border: 1px solid #eee;">

        <h2>I Miei Indirizzi di Spedizione</h2>

        <div class="indirizzi-salvati">
            <%
                IndirizzoDAO indDAO = new IndirizzoDAO();
                List<Indirizzo> mieiIndirizzi = indDAO.doRetrieveByUtente(utente.getIdUtente());
                
                if (mieiIndirizzi != null && !mieiIndirizzi.isEmpty()) {
                    for (Indirizzo ind : mieiIndirizzi) {
            %>
                <div class="address-card <%= ind.isAttivo() ? "active-address" : "" %>">
                    <p><strong>Via:</strong> <%= ind.getVia() %></p>
                    <p><strong>Città:</strong> <%= ind.getCitta() %> (<%= ind.getProvincia() %>) - <%= ind.getCap() %></p>
                    <p><strong>Nazione:</strong> <%= ind.getNazione() %></p>
                    
                    <div class="address-actions">
                        <% if (ind.isAttivo()) { %>
                            <span class="badge-attivo">📍 Indirizzo Attivo</span>
                        <% } else { %>
                            <a href="${pageContext.request.contextPath}/GestioneIndirizziServlet?azione=attiva&idIndirizzo=<%= ind.getIdIndirizzo() %>" class="btn-attiva">Rendi Attivo</a>
                        <% } %>
                        
                        <a href="${pageContext.request.contextPath}/GestioneIndirizziServlet?azione=elimina&idIndirizzo=<%= ind.getIdIndirizzo() %>" class="btn-elimina" onclick="return confirm('Sei sicuro di voler eliminare questo indirizzo?');">Elimina 🗑️</a>
                    </div>
                </div>
            <%      }
                } else {
            %>
                <p style="color: #666; font-style: italic;">Non hai ancora salvato nessun indirizzo di spedizione.</p>
            <%  } %>
        </div>

        <h3 style="margin-top: 30px;">Aggiungi un nuovo indirizzo</h3>
        <form action="${pageContext.request.contextPath}/GestioneIndirizziServlet" method="POST" onsubmit="return validaIndirizzo()">
            <input type="hidden" name="azione" value="aggiungi">
            
            <label>Via/Piazza e Civico:</label>
            <input type="text" id="via" name="via">
            <span id="errVia" style="color:red; display:none;">Inserisci la via.</span>

            <label>Città:</label>
            <input type="text" id="citta" name="citta">
            <span id="errCitta" style="color:red; display:none;">Inserisci la città.</span>

            <label>CAP:</label>
            <input type="text" id="cap" name="cap" maxlength="5">
            <span id="errCap" style="color:red; display:none;">Inserisci un CAP valido (5 numeri).</span>

            <label>Provincia (Sigla es. NA, RM):</label>
            <input type="text" id="provincia" name="provincia" maxlength="2" style="text-transform: uppercase;">
            <span id="errProv" style="color:red; display:none;">Inserisci la provincia (2 lettere).</span>

            <label>Nazione/Area Geografica:</label>
            <input type="text" id="nazione" name="nazione" value="Italia">

            <button type="submit" class="btn-salva">Salva Indirizzo 💾</button>
        </form>

    </div> 
    
    <script>
        // 1. Validazione Form Profilo
        function validaProfilo() {
            let isValid = true;
            let nome = document.getElementById("nome").value.trim();
            let cognome = document.getElementById("cognome").value.trim();
            let email = document.getElementById("email").value.trim();
            let telefono = document.getElementById("telefono").value.trim();
            let password = document.getElementById("password").value;

            document.querySelectorAll("span[id^='err']").forEach(e => e.style.display = 'none');

            if (nome === "") { document.getElementById("errNome").style.display = "block"; isValid = false; }
            if (cognome === "") { document.getElementById("errCognome").style.display = "block"; isValid = false; }
            let emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailPattern.test(email)) { document.getElementById("errEmail").style.display = "block"; isValid = false; }
            let telPattern = /^[0-9]{9,15}$/;
            if (telefono !== "" && !telPattern.test(telefono)) { document.getElementById("errTelefono").style.display = "block"; isValid = false; }
            if (password !== "" && password.length < 6) { document.getElementById("errPassword").style.display = "block"; isValid = false; }

            return isValid;
        }

        // 2. Validazione Form Indirizzi
        function validaIndirizzo() {
            let isValid = true;
            let via = document.getElementById("via").value.trim();
            let citta = document.getElementById("citta").value.trim();
            let cap = document.getElementById("cap").value.trim();
            let provincia = document.getElementById("provincia").value.trim();

            document.getElementById("errVia").style.display = "none";
            document.getElementById("errCitta").style.display = "none";
            document.getElementById("errCap").style.display = "none";
            document.getElementById("errProv").style.display = "none";

            if (via === "") { document.getElementById("errVia").style.display = "block"; isValid = false; }
            if (citta === "") { document.getElementById("errCitta").style.display = "block"; isValid = false; }
            let capPattern = /^[0-9]{5}$/;
            if (!capPattern.test(cap)) { document.getElementById("errCap").style.display = "block"; isValid = false; }
            let provPattern = /^[a-zA-Z]{2}$/;
            if (!provPattern.test(provincia)) { document.getElementById("errProv").style.display = "block"; isValid = false; }

            return isValid;
        }
    </script>
</body>
</html>