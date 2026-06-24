<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Utente" %>
<%@ page import="model.Indirizzo" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ShirtInvasion - Gestione Profilo</title>
    <!-- Collegamento al tuo file CSS globale -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/stile.css">
</head>
<body>

    <!-- RECUPERO DATI DALLA SESSIONE E REQUEST -->
    <%
        Utente utente = (Utente) session.getAttribute("utente");
        List<Indirizzo> listaIndirizzi = (List<Indirizzo>) request.getAttribute("listaIndirizzi");
        
        // Se l'utente è loggato ma la lista non è stata passata, la recuperiamo
        if (listaIndirizzi == null && utente != null) {
            dao.IndirizzoDAO temporaryDao = new dao.IndirizzoDAO();
            listaIndirizzi = temporaryDao.doRetrieveByUtente(utente.getIdUtente());
        }
    %>

    <!-- HEADER STANDARD -->
    <header class="main-header">
        <div class="logo">
            <h1>Shirt<span>Invasion</span> ⚽</h1>
        </div>
        <nav class="nav-bar">
            <ul>
                <li><a href="${pageContext.request.contextPath}/home">Home</a></li>
                <!-- Solo il Carrello è stato rimosso -->
                <!-- Tasto Esci mantenuto ben visibile in rosso -->
                <li><a href="${pageContext.request.contextPath}/LoginServlet?azione=logout" style="color: #ff4d4d; font-weight: bold;">Esci 🚪</a></li>
            </ul>
        </nav>
    </header>

    <!-- CONTENITORE PRINCIPALE CENTRATO -->
    <main class="main-container" style="margin-top: 40px; min-height: 70vh;">
        
        <h2 class="profile-page-title">Gestione Profilo</h2>

        <!-- SEZIONE 1: DATI UTENTE -->
        <div class="profile-card">
            <h3 class="profile-section-title">👤 Informazioni Personali</h3>
            <form action="${pageContext.request.contextPath}/ProfiloServlet?azione=modificaDati" method="post">
                <div class="profile-form-grid">
                    <div class="profile-form-group">
                        <label for="nome">Nome</label>
                        <input type="text" id="nome" name="nome" value="<%= utente != null ? utente.getNome() : "" %>" required>
                    </div>
                    <div class="profile-form-group">
                        <label for="cognome">Cognome</label>
                        <input type="text" id="cognome" name="cognome" value="<%= utente != null ? utente.getCognome() : "" %>" required>
                    </div>
                    <div class="profile-form-group">
                        <label for="email">Email</label>
                        <input type="email" id="email" name="email" value="<%= utente != null ? utente.getEmail() : "" %>" required>
                    </div>
                    <div class="profile-form-group">
                        <label for="telefono">Telefono</label>
                        <input type="text" id="telefono" name="telefono" value="<%= (utente != null && utente.getTelefono() != null) ? utente.getTelefono() : "" %>">
                    </div>
                    <div class="profile-form-group">
                        <label for="password">Nuova Password</label>
                        <input type="password" id="password" name="password" placeholder="Lascia vuoto per non cambiare">
                    </div>
                    <div class="profile-form-group">
                        <button type="submit" class="profile-btn-submit">Salva Modifiche Profilo 💾</button>
                    </div>
                </div>
            </form>
        </div>

        <!-- SEZIONE 2: LISTA INDIRIZZI SALVATI -->
        <h2 class="profile-page-title">I Miei Indirizzi Di Spedizione</h2>
        
        <div class="profile-address-list">
            <% 
                if (listaIndirizzi != null && !listaIndirizzi.isEmpty()) {
                    for (Indirizzo ind : listaIndirizzi) {
            %>
                <div class="profile-address-box <%= ind.isAttivo() ? "active" : "" %>">
                    <% if (ind.isAttivo()) { %>
                        <span class="profile-address-badge">Principale</span>
                    <% } %>
                    <p><strong>Via:</strong> <%= ind.getVia() %></p>
                    <p><strong>Città:</strong> <%= ind.getCitta() %> (<%= ind.getProvincia() %>) - <%= ind.getCap() %></p>
                    <p><strong>Nazione:</strong> <%= ind.getNazione() %></p>
                    
                    <div class="profile-address-actions">
                        <% if (!ind.isAttivo()) { %>
                            <a href="${pageContext.request.contextPath}/GestioneIndirizziServlet?azione=attiva&idIndirizzo=<%= ind.getIdIndirizzo() %>" class="profile-action-activate">Rendi Attivo</a>
                        <% } %>
                        <a href="${pageContext.request.contextPath}/GestioneIndirizziServlet?azione=elimina&idIndirizzo=<%= ind.getIdIndirizzo() %>" class="profile-action-delete" onclick="return confirm('Vuoi davvero eliminare questo indirizzo?')">Elimina 🗑️</a>
                    </div>
                </div>
            <% 
                    }
                } else {
            %>
                <p style="grid-column: 1/-1; color: #777; font-style: italic;">Nessun indirizzo di spedizione salvato. Aggiungine uno qui sotto.</p>
            <% } %>
        </div>

        <!-- SEZIONE 3: FORM AGGIUNTA NUOVO INDIRIZZO -->
        <div class="profile-card">
            <h3 class="profile-section-title">🏠 Aggiungi un nuovo indirizzo</h3>
            <form action="${pageContext.request.contextPath}/GestioneIndirizziServlet?azione=aggiungi" method="post">
                <div class="profile-form-grid">
                    <div class="profile-form-group" style="grid-column: span 2;">
                        <label for="via">Via/Piazza e Civico</label>
                        <input type="text" id="via" name="via" placeholder="es. Via Roma, 12" required>
                    </div>
                    <div class="profile-form-group">
                        <label for="citta">Città</label>
                        <input type="text" id="citta" name="citta" placeholder="es. Scafati" required>
                    </div>
                    <div class="profile-form-group">
                        <label for="cap">CAP</label>
                        <input type="text" id="cap" name="cap" placeholder="es. 84018" required>
                    </div>
                    <div class="profile-form-group">
                        <label for="provincia">Provincia (Sigla)</label>
                        <input type="text" id="provincia" name="provincia" placeholder="es. SA" maxlength="2" required>
                    </div>
                    <div class="profile-form-group">
                        <label for="nazione">Nazione/Area Geografica</label>
                        <input type="text" id="nazione" name="nazione" value="Italia" required>
                    </div>
                    <div class="profile-form-group">
                        <button type="submit" class="profile-btn-submit ">Salva Indirizzo 💾</button>
                    </div>
                </div>
            </form>
        </div>

    </main>

    <!-- FOOTER STANDARD -->
    <footer class="main-footer">
        <p>© 2026 ShirtInvasion. Tutti i diritti riservati. Sviluppato in Java Web MVC.</p>
    </footer>

</body>
</html>