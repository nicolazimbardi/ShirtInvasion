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

    <header class="main-header">
        <div class="logo">
            <h1>Pannello di Controllo Amministratore 🛠️</h1>
        </div>
        <nav class="nav-bar">
            <ul>
                <li>
                    Admin: <% Utente utenteSessione = (Utente) session.getAttribute("utente"); if(utenteSessione != null) { %><%= utenteSessione.getCognome() + " " + utenteSessione.getNome() %><% } %>
                </li>
                <li><a href="${pageContext.request.contextPath}/home">Home</a></li>
                <li><a href="${pageContext.request.contextPath}/LogoutServlet">Logout</a></li>
            </ul>
        </nav>
    </header>

    <main class="main-container admin-page">
        
        <!-- MESSAGGI DI NOTIFICA -->
        <% 
            String msgSuccesso = (String) request.getAttribute("messaggioSuccesso");
            if (msgSuccesso != null && !msgSuccesso.isEmpty()) { 
        %>
                <div class="alert-msg alert-success">
                    <%= msgSuccesso %>
                </div>
        <% 
            } 
        %>
        
        <% 
            String msgErrore = (String) request.getAttribute("messaggioErrore");
            if (msgErrore != null && !msgErrore.isEmpty()) { 
        %>
                <div class="alert-msg alert-danger">
                    <%= msgErrore %>
                </div>
        <% 
            } 
        %>

        <!-- SEZIONE 1: GESTIONE CATALOGO -->
        <section class="admin-section">
            <h2>1. Gestione Catalogo Articoli (Aggiungi, Elimina, Modifica)</h2>
            
            <p class="admin-section-title-sub">Nuovo Articolo Completo:</p>
            
            <!-- FORM DI INSERIMENTO COMPILATO TRAMITE CLASSI ESTERNE -->
            <form action="${pageContext.request.contextPath}/AdminServlet" method="POST" data-context="${pageContext.request.contextPath}">
                <div class="admin-form-row">
                    <input type="text" name="squadra" placeholder="Squadra" required>
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

                <!-- BOX ANTEPRIMA VISIVA GESTITO DA CLASSI CSS -->
                <div id="box-anteprima" class="preview-gallery-container">
                    <p>Anteprima maglia:</p>
                    <div class="preview-image-frame">
                        <img id="img-anteprima" src="" alt="Anteprima">
                    </div>
                </div>
            </form>

            <!-- TABELLA CATALOGO ARTICOLI -->
            <div class="admin-table-wrapper">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Foto</th>
                            <th>Squadra</th>
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
                        %>
                                    <tr>
                                        <td class="td-id"><%= p.getIdProdotto() %></td>
                                        <td class="td-foto">
                                            <% if (p.getImmagine() != null && !p.getImmagine().isEmpty()) { %>
                                                <img src="${pageContext.request.contextPath}/images/<%= p.getImmagine() %>" alt="Maglia" class="img-mini">
                                            <% } else { %>
                                                
                                            <% } %>
                                        </td>
                                        <td><%= p.getSquadra() %></td>
                                        <td><%= p.getNome() %></td>
                                        <td><%= p.getStagione() %></td>
                                        <td><%= p.getMarca() %></td>
                                        <td><span class="info-prodotto"><%= p.getTaglia() %></span></td>
                                        <td><%= p.getPrezzo() %></td>
                                        <td><%= p.getQuantita() %> pz</td>
                                        <td class="td-desc"><%= p.getDescrizione() %></td>
                                        <td>
                                            <a href="AdminServlet?azione=modifica&id=<%= p.getIdProdotto() %>" class="btn-action btn-edit">Modifica</a>
                                            <a href="AdminServlet?azione=elimina&id=<%= p.getIdProdotto() %>" class="btn-action btn-delete" onclick="return confirm('Sicuro di voler eliminare questo articolo?')">Elimina</a>
                                        </td>
                                    </tr>
                        <% 
                                }
                            } else {
                        %>
                                <tr>
                                    <td colspan="11" class="text-empty">Nessun prodotto censito nel catalogo.</td>
                                </tr>
                        <% 
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </section>

        <!-- SEZIONE 2: VISUALIZZAZIONE ORDINI -->
        <section class="admin-section">
            <h2>2. Visualizzazione Ordini per Data e per Cliente</h2>
            
            <div class="admin-filter-bar">
                <label>Da:</label>
                <input type="text" placeholder="gg/mm/aaaa">
                <label>A:</label>
                <input type="text" placeholder="gg/mm/aaaa">
                <button type="button" class="btn-filter">Cerca</button>
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
                        <tr>
                            <td colspan="5" class="text-empty">Nessun ordine presente nel database.</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </section>
    </main>

    <footer class="main-footer">
        <p>&copy; 2026 ShirtInvasion. Tutti i diritti riservati.</p>
    </footer>

</body>
</html>
