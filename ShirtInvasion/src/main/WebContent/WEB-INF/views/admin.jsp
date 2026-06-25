<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Utente" %>
<%@ page import="model.Prodotto" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pannello di Controllo Amministratore - ShirtInvasion</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/stile.css">
    
    <script src="${pageContext.request.contextPath}/scripts/script.js" defer></script>
</head>
<body>

    <jsp:include page="header.jsp" />

    <main class="main-container admin-page" style="margin-top: 40px;">
        
        <% 
            String msgSuccesso = (String) request.getAttribute("messaggioSuccesso");
            if (msgSuccesso != null && !msgSuccesso.isEmpty()) { 
        %>
                <script>
                    document.addEventListener("DOMContentLoaded", () => {
                        creaMessaggioDOM("<%= msgSuccesso %>", "success");
                    });
                </script>
        <% 
            } 
        %>
        
        <% 
            String msgErrore = (String) request.getAttribute("messaggioErrore");
            if (msgErrore != null && !msgErrore.isEmpty()) { 
        %>
                <script>
                    document.addEventListener("DOMContentLoaded", () => {
                        creaMessaggioDOM("<%= msgErrore %>", "danger");
                    });
                </script>
        <% 
            } 
        %>

        <section class="admin-section">
            <h2>1. Gestione Catalogo Articoli (Aggiungi, Elimina, Modifica)</h2>
            
            <p class="admin-section-title-sub"> Aggiungi un nuovo articolo :</p>
            
            <form action="${pageContext.request.contextPath}/AdminServlet" method="POST">
                <input type="hidden" name="azioneProdotto" value="inserisci">
                <input type="hidden" name="sessionToken" value="${sessionScope.sessionToken}">
                
                <div class="admin-form-row">
                    <input type="text" name="squadra" placeholder="Squadra" required>

                    <select name="campionato" required>
                        <option value="">-- Campionato --</option>
                        <option value="Serie A">Serie A</option>
                        <option value="Premier League">Premier League</option>
                        <option value="La Liga">La Liga</option>
                    </select>

                    <input type="text" name="modello" placeholder="Modello/Nome" required>
                    <input type="text" name="stagione" placeholder="Stagione (es 2026/27)" required>
                    <input type="text" name="marca" placeholder="Marca" required>
                    <input type="text" name="taglia" placeholder="Taglia" required>
                    <input type="number" step="0.01" name="prezzo" placeholder="Prezzo (€)" required>
                    <input type="number" name="stock" placeholder="Stock" required>
                    <input type="text" name="descrizione" placeholder="Descrizione dettagliata">

                    <select name="immagine" id="scelta-immagine" required>
                        <option value="">-- Scegli Foto --</option>
                        <% 
                            List<String> fotoDisponibili = (List<String>) request.getAttribute("listaFotoDisponibili");
                            if (fotoDisponibili != null) {
                                for (String foto : fotoDisponibili) {
                        %>
                                    <option value="<%= foto %>"><%= foto %></option>
                        <% 
                                }
                            } 
                        %>
                    </select>
                    
                    <button type="submit" class="btn-admin-save">Salva</button>
                </div>
            </form>

            <div id="box-anteprima" class="preview-gallery-container">
                <p>Anteprima maglia:</p>
                <div class="preview-image-frame">
                    <img id="img-anteprima" src="" alt="Anteprima">
                </div>
            </div>

            <div class="admin-table-wrapper">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Foto</th>
                            <th>Squadra</th>
                            <th>Campionato</th>
                            <th>Modello</th>
                            <th>Stagione</th>
                            <th>Marca</th>
                            <th>Taglia</th>
                            <th>Prezzo (€)</th>
                            <th>Stock</th>
                            <th>Descrizione</th>
                            <th>Azioni</th>
                        </tr>
                    </thead>
                    <tbody>
                <% 
                    List<Prodotto> catalogo = (List<Prodotto>) request.getAttribute("prodottiCatalogo"); 
                    if (catalogo != null && !catalogo.isEmpty()) {
                        for (Prodotto p : catalogo) {
                            String formId = "form_edit_" + p.getIdProdotto();
                %>
                            <tr>
                                <td class="td-id"><%= p.getIdProdotto() %></td>
                                <td>
                                    <img src="${pageContext.request.contextPath}/images/<%= p.getImmagine() %>" class="img-mini" alt="Maglia"><br>
                                    <select name="immagine" form="<%= formId %>">
                                        <% if(fotoDisponibili != null){
                                            for(String foto : fotoDisponibili){ %>
                                                <option value="<%= foto %>" <%= foto.equals(p.getImmagine()) ? "selected" : "" %>>
                                                    <%= foto %>
                                                </option>
                                        <% }
                                        } %>
                                    </select>
                                </td>
                                <td><input type="text" name="squadra" value="<%= p.getSquadra() %>" form="<%= formId %>"></td>            
                                <td>
                                    <select name="campionato" form="<%= formId %>">
                                        <option value="Serie A" <%= "Serie A".equals(p.getCampionato()) ? "selected" : "" %>>Serie A</option>
                                        <option value="Premier League" <%= "Premier League".equals(p.getCampionato()) ? "selected" : "" %>>Premier League</option>
                                        <option value="La Liga" <%= "La Liga".equals(p.getCampionato()) ? "selected" : "" %>>La Liga</option>
                                    </select>
                                </td>
                                <td><input type="text" name="modello" value="<%= p.getNome() %>" form="<%= formId %>"></td>
                                <td><input type="text" name="stagione" value="<%= p.getStagione() %>" form="<%= formId %>"></td>
                                <td><input type="text" name="marca" value="<%= p.getMarca() %>" form="<%= formId %>"></td>
                                <td><input type="text" name="taglia" value="<%= p.getTaglia() %>" form="<%= formId %>"></td>
                                <td><input type="number" step="0.01" name="prezzo" value="<%= p.getPrezzo() %>" form="<%= formId %>"></td>
                                <td><input type="number" name="stock" value="<%= p.getQuantita() %>" form="<%= formId %>"></td>
                                <td><input type="text" name="descrizione" value="<%= p.getDescrizione() %>" form="<%= formId %>"></td>
                                
                                <td>
                                    <form id="<%= formId %>" action="${pageContext.request.contextPath}/AdminServlet" method="POST">
                                       <input type="hidden" name="sessionToken" value="${sessionScope.sessionToken}">
                                        <input type="hidden" name="azioneProdotto" value="modifica">
                                        <input type="hidden" name="id" value="<%= p.getIdProdotto() %>">
                                        <button type="submit" class="btn-action btn-edit">Salva</button>
                                    </form>
                                    
                                    <form action="${pageContext.request.contextPath}/AdminServlet" method="POST" onsubmit="mostraConfermaDOM(event, this)">
                                        <input type="hidden" name="azioneProdotto" value="elimina">
                                        <input type="hidden" name="sessionToken" value="${sessionScope.sessionToken}">
                                        <input type="hidden" name="id" value="<%= p.getIdProdotto() %>">
                                        <button type="submit" class="btn-action btn-delete">Elimina</button>
                                    </form>
                                </td>
                            </tr>
                <% 
                        }
                    } else {
                %>
                        <tr><td colspan="12" class="text-empty">Nessun prodotto trovato.</td></tr>
                <% } %>
                    </tbody>
                </table>
            </div>
        </section>

        <section class="admin-section">
            <h2>2. Visualizzazione Ordini per Data e per Cliente</h2>
            
            <div class="admin-filter-bar">
                <form action="${pageContext.request.contextPath}/AdminServlet" method="get">
                    <input type="hidden" name="filtro" value="ordini">
                    <label>Da:</label>
                    <input type="date" name="dataInizio">
                    <label>A:</label>
                    <input type="date" name="dataFine">
                    <button type="submit" class="btn-filter">Cerca</button>
                </form>
            </div>
            
            <div class="admin-table-wrapper">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>ID Ordine</th>
                            <th>Cliente</th>
                            <th>Data</th>
                            <th>Totale Speso</th>
                            <th>Stato</th>
                        </tr>
                    </thead>
                    <tbody>
                <% 
                    List<String[]> ordiniClienti = (List<String[]>) request.getAttribute("listaOrdiniSenzaClasse");
                    if (ordiniClienti != null && !ordiniClienti.isEmpty()) {
                        for (String[] ord : ordiniClienti) {
                %>
                            <tr>
                                <td><%= ord[0] %></td> <td><%= ord[1] %></td> <td><%= ord[2] %></td> <td><strong><%= ord[3] %></strong></td> <td><%= ord[4] %></td> </tr>
                <% 
                        }
                    } else {
                %>
                        <tr>
                            <td colspan="5" class="text-empty">Nessun ordine presente nel database.</td>
                        </tr>
                <% 
                    }
                %>
                    </tbody>
                </table>
            </div>
        </section>
    </main>

    <footer class="main-footer">
        <p>&copy; 2026 ShirtInvasion. Tutti i diritti riservati.</p>
    </footer>

    <script>
        // Inserisce dinamicamente i messaggi di Errore/Successo nel DOM
        function creaMessaggioDOM(testo, tipo) {
            const div = document.createElement("div");
            div.className = `alert-msg alert-${tipo}`;
            div.textContent = testo;
            div.style.marginBottom = "20px";

            const main = document.querySelector(".main-container");
            main.insertBefore(div, main.firstChild);
        }

        // Sostituisce il confirm() nativo con un overlay modale generato via DOM
        function mostraConfermaDOM(event, form) {
            event.preventDefault(); // Blocca l'invio immediato del form

            // Sfondo scuro
            const overlay = document.createElement("div");
            overlay.style.position = "fixed";
            overlay.style.top = "0";
            overlay.style.left = "0";
            overlay.style.width = "100vw";
            overlay.style.height = "100vh";
            overlay.style.backgroundColor = "rgba(0, 0, 0, 0.5)";
            overlay.style.display = "flex";
            overlay.style.justifyContent = "center";
            overlay.style.alignItems = "center";
            overlay.style.zIndex = "9999";

            // Box del messaggio
            const box = document.createElement("div");
            box.style.backgroundColor = "#fff";
            box.style.padding = "20px";
            box.style.borderRadius = "5px";
            box.style.textAlign = "center";
            box.style.boxShadow = "0 2px 10px rgba(0,0,0,0.3)";

            const p = document.createElement("p");
            p.textContent = "Sei sicuro di voler eliminare questo articolo?";
            p.style.color = "#333";
            p.style.marginBottom = "15px";
            box.appendChild(p);

            // Pulsante Annulla
            const btnAnnulla = document.createElement("button");
            btnAnnulla.textContent = "Annulla";
            btnAnnulla.style.marginRight = "10px";
            btnAnnulla.style.padding = "6px 12px";
            btnAnnulla.style.cursor = "pointer";
            btnAnnulla.onclick = () => document.body.removeChild(overlay);
            box.appendChild(btnAnnulla);

            // Pulsante Conferma (Invia il form)
            const btnOk = document.createElement("button");
            btnOk.textContent = "Elimina";
            btnOk.style.padding = "6px 12px";
            btnOk.style.background = "#d9534f";
            btnOk.style.color = "white";
            btnOk.style.border = "none";
            btnOk.style.cursor = "pointer";
            btnOk.onclick = () => form.submit();
            box.appendChild(btnOk);

            overlay.appendChild(box);
            document.body.appendChild(overlay);
        }
    </script>

</body>
</html>