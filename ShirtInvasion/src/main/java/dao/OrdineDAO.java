package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import model.Carrello;
import model.Prodotto;
import model.Ordine;
import model.DettaglioOrdine;

public class OrdineDAO {

    private static DataSource ds;

    static {
        try {
            InitialContext ctx = new InitialContext();
            ds = (DataSource) ctx.lookup("java:comp/env/jdbc/shirtinvasion");
        } catch (NamingException e) {
            e.printStackTrace();
        }
    }

    public boolean doSave(Carrello carrello, int idUtente) {
        Connection conn = null;
        PreparedStatement psOrdine = null;
        PreparedStatement psDettaglio = null;
        ResultSet rs = null;

        String queryOrdine = "INSERT INTO ordini (id_utente, totale) VALUES (?, ?)";
        String queryDettaglio = "INSERT INTO dettagli_ordine (id_ordine, id_prodotto, nome_prodotto, prezzo_unitario, quantita) VALUES (?, ?, ?, ?, ?)";

        try {
            conn = ds.getConnection();
            conn.setAutoCommit(false);

            psOrdine = conn.prepareStatement(queryOrdine, Statement.RETURN_GENERATED_KEYS);
            psOrdine.setInt(1, idUtente);
            psOrdine.setDouble(2, carrello.getPrezzoTotale());
            psOrdine.executeUpdate();

            rs = psOrdine.getGeneratedKeys();
            int idOrdineGenerato = 0;
            if (rs.next()) {
                idOrdineGenerato = rs.getInt(1);
            }

            psDettaglio = conn.prepareStatement(queryDettaglio);
            for (Prodotto p : carrello.getElementi()) {
                psDettaglio.setInt(1, idOrdineGenerato);
                psDettaglio.setInt(2, p.getIdProdotto());
                psDettaglio.setString(3, p.getNome());
                psDettaglio.setDouble(4, p.getPrezzo());
                psDettaglio.setInt(5, p.getQuantitaCarrello()); 
                psDettaglio.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (rs != null) rs.close();
                if (psDettaglio != null) psDettaglio.close();
                if (psOrdine != null) psOrdine.close();
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public boolean doSaveConTotale(Carrello carrello, int idUtente, double totaleFinale) {
        Connection conn = null;
        PreparedStatement psOrdine = null;
        PreparedStatement psDettaglio = null;
        ResultSet rs = null;

        String queryOrdine = "INSERT INTO ordini (id_utente, totale, stato) VALUES (?, ?, 'IN_LAVORAZIONE')";
        String queryDettaglio = "INSERT INTO dettagli_ordine (id_ordine, id_prodotto, nome_prodotto, prezzo_unitario, quantita) VALUES (?, ?, ?, ?, ?)";

        try {
            conn = ds.getConnection();
            conn.setAutoCommit(false);

            psOrdine = conn.prepareStatement(queryOrdine, Statement.RETURN_GENERATED_KEYS);
            psOrdine.setInt(1, idUtente);
            psOrdine.setDouble(2, totaleFinale);
            psOrdine.executeUpdate();

            rs = psOrdine.getGeneratedKeys();
            int idOrdineGenerato = 0;
            if (rs.next()) {
                idOrdineGenerato = rs.getInt(1);
            }

            psDettaglio = conn.prepareStatement(queryDettaglio);
            for (Prodotto p : carrello.getElementi()) {
                psDettaglio.setInt(1, idOrdineGenerato);
                psDettaglio.setInt(2, p.getIdProdotto());
                psDettaglio.setString(3, p.getNome());
                psDettaglio.setDouble(4, p.getPrezzo());
                psDettaglio.setInt(5, p.getQuantitaCarrello());
                psDettaglio.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (rs != null) rs.close();
                if (psDettaglio != null) psDettaglio.close();
                if (psOrdine != null) psOrdine.close();
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public List<Ordine> doRetrieveByUtente(int idUtente) {
        List<Ordine> ordini = new ArrayList<>();
        String query = "SELECT * FROM ordini WHERE id_utente = ? ORDER BY data_ordine DESC";
        String queryDettagli = "SELECT * FROM dettagli_ordine WHERE id_ordine = ?";
        
        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, idUtente);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Ordine o = new Ordine();
                    o.setIdOrdine(rs.getInt("id_ordine"));
                    o.setIdUtente(rs.getInt("id_utente"));
                    o.setDataOrdine(rs.getTimestamp("data_ordine"));
                    o.setTotale(rs.getDouble("totale"));
                    o.setStato(rs.getString("stato"));
                    
                    try (PreparedStatement psDet = conn.prepareStatement(queryDettagli)) {
                        psDet.setInt(1, o.getIdOrdine());
                        try (ResultSet rsDet = psDet.executeQuery()) {
                            while (rsDet.next()) {
                                DettaglioOrdine d = new DettaglioOrdine();
                                d.setIdDettaglio(rsDet.getInt("id_dettaglio"));
                                d.setIdOrdine(rsDet.getInt("id_ordine"));
                                d.setIdProdotto(rsDet.getInt("id_prodotto"));
                                d.setNomeProdotto(rsDet.getString("nome_prodotto"));
                                d.setPrezzoUnitario(rsDet.getDouble("prezzo_unitario"));
                                d.setQuantita(rsDet.getInt("quantita"));
                                o.addDettaglio(d);
                            }
                        }
                    }
                    ordini.add(o);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ordini;
    }
}