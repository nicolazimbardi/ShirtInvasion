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

        String queryOrdine = "INSERT INTO ordini (id_utente, totale) VALUES (?, ?)";
        // Inserito il quinto parametro (?) per la Quantità
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
                
                // Salviamo la VERA quantità dal carrello
                psDettaglio.setInt(5, p.getQuantitaCarrello()); 
                
                psDettaglio.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
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