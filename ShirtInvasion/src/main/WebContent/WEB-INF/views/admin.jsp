<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Utente" %>
<%@ page import="dao.ProdottoDAO" %>
<%@ page import="model.Prodotto" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.sql.DataSource" %>

<%
    Utente utenteInSessione = (Utente) session.getAttribute("utente");
    if (utenteInSessione == null || !"ADMIN".equals(utenteInSessione.getRuolo())) {
        response.sendRedirect(request.getContextPath() + "/");
        return;
    }

    ProdottoDAO prodottoDao = new ProdottoDAO();
    String azioneProdotto = request.getParameter("azioneProdotto");

    if (azioneProdotto != null) {
        if (azioneProdotto.equals("inserisci")) {
            Prodotto nuovo = new Prodotto();
            nuovo.setSquadra(request.getParameter("squadra"));
            nuovo.setNome(request.getParameter("nome"));
            nuovo.setStagione(request.getParameter("stagione"));
            nuovo.setMarca(request.getParameter("marca"));
            nuovo.setTaglia(request.getParameter("taglia"));
            nuovo.setPrezzo(Double.parseDouble(request.getParameter("prezzo")));
            nuovo.setQuantita(Integer.parseInt(request.getParameter("quantita")));
            nuovo.setDescrizione(request.getParameter("descrizione"));
            nuovo.setAttivo(true);
            prodottoDao.doSave(nuovo);
            
            
            response.sendRedirect("AdminServlet"); 
            return;
        } else if (azioneProdotto.equals("elimina")) {
            int idDel = Integer.parseInt(request.getParameter("id"));
            prodottoDao.doDelete(idDel); 
            
            
            response.sendRedirect("AdminServlet");
            return;
        } else if (azioneProdotto.equals("modifica")) {
            int idMod = Integer.parseInt(request.getParameter("id"));
            Prodotto pMod = prodottoDao.doRetrieveById(idMod);
            if (pMod != null) {
                pMod.setStagione(request.getParameter("stagione"));
                pMod.setMarca(request.getParameter("marca"));
                pMod.setTaglia(request.getParameter("taglia"));
                pMod.setPrezzo(Double.parseDouble(request.getParameter("prezzo")));
                pMod.setQuantita(Integer.parseInt(request.getParameter("quantita")));
                pMod.setDescrizione(request.getParameter("descrizione"));
                prodottoDao.doUpdate(pMod);
            }
            response.sendRedirect("AdminServlet");
            return;
        }

    }


    String filtroCliente = request.getParameter("filtroCliente");
    String dataInizio = request.getParameter("dataInizio");
    String dataFine = request.getParameter("dataFine");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Pannello Admin</title>
</head>
<body style="font-family: Arial, sans-serif; margin: 20px;">

    <h2>Pannello di Controllo Amministratore 🛠️</h2>
    
    <p>
        Admin: <strong><%= utenteInSessione.getNome() %> <%= utenteInSessione.getCognome() %></strong> | 
        <a href="${pageContext.request.contextPath}/">Home</a> | 
        <a href="LogoutServlet" style="color: red; font-weight: bold; text-decoration: none;">Logout 🚪</a>
    </p>



   
    <h3>1. Gestione Catalogo Articoli (Aggiungi, Elimina, Modifica)</h3>
    
    <form action="AdminServlet?azioneProdotto=inserisci" method="post" style="background: #f4f4f4; padding: 12px; margin-bottom: 20px; border-radius: 5px;">
        <strong style="display: block; margin-bottom: 8px;">Nuovo Articolo Completo:</strong>
        <div style="display: flex; flex-wrap: wrap; gap: 8px; align-items: center;">
            <input type="text" name="squadra" placeholder="Squadra" required style="width: 130px;">
            <input type="text" name="nome" placeholder="Modello/Nome" required style="width: 130px;">
            <input type="text" name="stagione" placeholder="Stagione (es. 2026/27)" style="width: 130px;">
            <input type="text" name="marca" placeholder="Marca" style="width: 90px;">
            <input type="text" name="taglia" placeholder="Taglia" style="width: 60px;">
            <input type="number" step="0.01" name="prezzo" placeholder="Prezzo (€)" required style="width: 80px;">
            <input type="number" name="quantita" placeholder="Stock" required style="width: 60px;">
            <textarea name="descrizione" placeholder="Descrizione dettagliata maglia..." style="width: 200px; height: 24px; font-family: Arial, sans-serif; font-size: 13px; padding: 4px; resize: vertical; box-sizing: border-box;"></textarea>
            <button type="submit" style="background: green; color: white; border: none; padding: 6px 12px; border-radius: 3px; cursor: pointer; font-weight: bold;">Salva</button>
        </div>
    </form>


            <table border="1" style="width: 100%; text-align: left; border-collapse: collapse; margin-bottom: 40px;">
        <thead style="background: #eee;">
            <tr>
                <th>ID</th>
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
                List<Prodotto> listaTutti = prodottoDao.doRetrieveAll();
                if (listaTutti != null && !listaTutti.isEmpty()) {
                    for (Prodotto p : listaTutti) {
            %>
                        <tr>
                            <td>
                                <%= p.getIdProdotto() %>
                                <%-- Il form invisibile raccoglierà tutti gli input di questa riga --%>
                                <form id="formModifica<%= p.getIdProdotto() %>" action="AdminServlet?azioneProdotto=modifica&id=<%= p.getIdProdotto() %>" method="post" style="display:none;"></form>
                            </td>
                            <td><strong><%= p.getSquadra() %></strong></td>
                            <td><%= p.getNome() %></td>
                            <td>
                                <input type="text" name="stagione" value="<%= (p.getStagione() != null) ? p.getStagione() : "" %>" form="formModifica<%= p.getIdProdotto() %>" style="width: 80px;">
                            </td>
                            <td>
                                <input type="text" name="marca" value="<%= (p.getMarca() != null) ? p.getMarca() : "" %>" form="formModifica<%= p.getIdProdotto() %>" style="width: 80px;">
                            </td>
                            <td>
                                <input type="text" name="taglia" value="<%= (p.getTaglia() != null) ? p.getTaglia() : "" %>" form="formModifica<%= p.getIdProdotto() %>" style="width: 40px; text-align: center;">
                            </td>
                            <td>
                                <input type="number" step="0.01" name="prezzo" value="<%= p.getPrezzo() %>" form="formModifica<%= p.getIdProdotto() %>" style="width: 65px;">
                            </td>
                            <td>
                                <input type="number" name="quantita" value="<%= p.getQuantita() %>" form="formModifica<%= p.getIdProdotto() %>" style="width: 45px;"> pz
                            </td>
                            <td>
<textarea name="descrizione" form="formModifica<%= p.getIdProdotto() %>" style="width: 180px; height: 40px; font-family: Arial, sans-serif; font-size: 12px; resize: vertical;"><%= (p.getDescrizione() != null) ? p.getDescrizione() : "" %></textarea>                            </td>
                            <td>
                                <button type="submit" form="formModifica<%= p.getIdProdotto() %>" style="background: blue; color: white; cursor: pointer; border: none; padding: 4px 8px; border-radius: 3px; font-weight: bold;">Modifica</button>
                                
                                <a href="AdminServlet?azioneProdotto=elimina&id=<%= p.getIdProdotto() %>" onclick="return confirm('Eliminare questa maglia?');" style="text-decoration: none;">
                                    <button type="button" style="background: red; color: white; cursor: pointer; border: none; padding: 4px 8px; border-radius: 3px; margin-left: 5px; font-weight: bold;">Elimina</button>
                                </a>
                            </td>
                        </tr>
            <%
                    }
                } else {
            %>
                    <tr><td colspan="10">Nessun prodotto attivo nel database.</td></tr>
            <% } %>
        </tbody>
    </table>


    
    <h3>2. Visualizzazione Ordini per Data e per Cliente</h3>
    
<form action="AdminServlet" method="get" style="background: #eef; padding: 10px; margin-bottom: 20px;">
        <input type="text" name="filtroCliente" value="<%= (filtroCliente != null) ? filtroCliente : "" %>">
        <label>Da:</label> <input type="date" name="dataInizio" value="<%= (dataInizio != null) ? dataInizio : "" %>">
        <label>A:</label> <input type="date" name="dataFine" value="<%= (dataFine != null) ? dataFine : "" %>">
        <button type="submit">Filtra</button>
<a href="AdminServlet"><button type="button">Azzera</button></a>
</form>
    <table border="1" style="width: 100%; text-align: left; border-collapse: collapse; padding: 6px;">
        <thead style="background: #ddd;">
            <tr>
                <th>ID Ordine</th><th>Cliente (ID - Email)</th><th>Data</th><th>Totale Speso</th><th>Stato</th>
            </tr>
        </thead>
        <tbody>
            <%
               
                String queryOrdini = "SELECT o.*, u.nome, u.cognome, u.email FROM ordini o JOIN utenti u ON o.id_utente = u.id_utente WHERE 1=1";
                
                if (filtroCliente != null && !filtroCliente.trim().isEmpty()) {
                    queryOrdini += " AND (u.id_utente = ? OR u.email LIKE ?)";
                }
                if (dataInizio != null && !dataInizio.trim().isEmpty()) {
                    queryOrdini += " AND o.data_ordine >= ?";
                }
                if (dataFine != null && !dataFine.trim().isEmpty()) {
                    queryOrdini += " AND o.data_ordine <= ?";
                }

                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                boolean hasOrders = false;

                try {
                    InitialContext ctx = new InitialContext();
                    DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/shirtinvasion");
                    con = ds.getConnection();
                    ps = con.prepareStatement(queryOrdini);
                    int paramIndex = 1;

                    if (filtroCliente != null && !filtroCliente.trim().isEmpty()) {
                        String filtro = filtroCliente.trim();
                        ps.setInt(paramIndex++, filtro.matches("\\d+") ? Integer.parseInt(filtro) : -1);
                        ps.setString(paramIndex++, "%" + filtro + "%");
                    }
                    if (dataInizio != null && !dataInizio.trim().isEmpty()) {
                        ps.setDate(paramIndex++, Date.valueOf(dataInizio));
                    }
                    if (dataFine != null && !dataFine.trim().isEmpty()) {
                        ps.setDate(paramIndex++, Date.valueOf(dataFine));
                    }

                    rs = ps.executeQuery();
                    while (rs.next()) {
                        hasOrders = true;
            %>
                        <tr>
                            <td><%= rs.getInt("id_ordine") %></td>
                            <td>[ID: <%= rs.getInt("id_utente") %>] <%= rs.getString("nome") %> <%= rs.getString("cognome") %> (<%= rs.getString("email") %>)</td>
                            <td><%= rs.getDate("data_ordine") %></td>
                            <td><strong>€<%= String.format("%.2f", rs.getDouble("totale")) %></strong></td>
                            <td><%= rs.getString("stato") %></td>
                        </tr>
            <%
                    }
                    if (!hasOrders) {
            %>
                        <tr><td colspan="5">Nessun ordine trovato per i filtri inseriti.</td></tr>
            <%
                    }
                } catch (Exception e) {
            %>
                    <tr><td colspan="5" style="color: red;">Errore database: <%= e.getMessage() %></td></tr>
            <%
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException e) {}
                    if (ps != null) try { ps.close(); } catch (SQLException e) {}
                    if (con != null) try { con.close(); } catch (SQLException e) {}
                }
            %>
            </tbody>
            </table>
            


