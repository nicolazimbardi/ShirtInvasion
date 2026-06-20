package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import model.Carrello;
import model.Prodotto;

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

        // Query per l'ordine (data e stato si compilano da soli con i default del tuo DB)
        String queryOrdine = "INSERT INTO ordini (id_utente, totale) VALUES (?, ?)";
        // Query per i dettagli
        String queryDettaglio = "INSERT INTO dettagli_ordine (id_ordine, id_prodotto, nome_prodotto, prezzo_unitario, quantita) VALUES (?, ?, ?, ?, 1)";

        try {
            conn = ds.getConnection();
            // Disabilitiamo l'autocommit per fare una transazione sicura
            conn.setAutoCommit(false);

            // 1. SALVIAMO L'ORDINE GENERALE
            // RETURN_GENERATED_KEYS ci permette di recuperare l'id_ordine appena generato dal DB
            psOrdine = conn.prepareStatement(queryOrdine, Statement.RETURN_GENERATED_KEYS);
            psOrdine.setInt(1, idUtente);
            psOrdine.setDouble(2, carrello.getPrezzoTotale());
            psOrdine.executeUpdate();

            // Recuperiamo l'ID dell'ordine
            rs = psOrdine.getGeneratedKeys();
            int idOrdineGenerato = 0;
            if (rs.next()) {
                idOrdineGenerato = rs.getInt(1);
            }

            // 2. SALVIAMO I DETTAGLI PER OGNI MAGLIA NEL CARRELLO
            psDettaglio = conn.prepareStatement(queryDettaglio);
            for (Prodotto p : carrello.getElementi()) {
                psDettaglio.setInt(1, idOrdineGenerato);
                psDettaglio.setInt(2, p.getIdProdotto());
                psDettaglio.setString(3, p.getNome());
                psDettaglio.setDouble(4, p.getPrezzo());
                psDettaglio.executeUpdate();
            }

            // Tutto è andato a buon fine: Confermiamo il salvataggio!
            conn.commit();
            return true;

        } catch (SQLException e) {
            // Se c'è un errore, annulliamo tutto (Rollback) per non lasciare dati a metà
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            // Chiusura sicura delle risorse
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
}