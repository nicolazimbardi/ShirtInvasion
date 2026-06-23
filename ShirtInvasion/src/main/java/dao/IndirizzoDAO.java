package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import model.Indirizzo;

public class IndirizzoDAO {
    
    private static DataSource ds;

    static {
        try {
            InitialContext ctx = new InitialContext();
            ds = (DataSource) ctx.lookup("java:comp/env/jdbc/shirtinvasion");
        } catch (NamingException e) {
            e.printStackTrace();
        }
    }

    // Salva un nuovo indirizzo
    public boolean doSave(Indirizzo ind) {
        String query = "INSERT INTO indirizzi (id_utente, via, citta, cap, provincia, nazione, is_attivo) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, ind.getIdUtente());
            ps.setString(2, ind.getVia());
            ps.setString(3, ind.getCitta());
            ps.setString(4, ind.getCap());
            ps.setString(5, ind.getProvincia());
            ps.setString(6, ind.getNazione() != null ? ind.getNazione() : "Italia");
            ps.setBoolean(7, ind.isAttivo());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Recupera tutti gli indirizzi di un utente
    public List<Indirizzo> doRetrieveByUtente(int idUtente) {
        List<Indirizzo> indirizzi = new ArrayList<>();
        String query = "SELECT * FROM indirizzi WHERE id_utente = ?";
        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, idUtente);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Indirizzo ind = new Indirizzo();
                    ind.setIdIndirizzo(rs.getInt("id_indirizzo"));
                    ind.setIdUtente(rs.getInt("id_utente"));
                    ind.setVia(rs.getString("via"));
                    ind.setCitta(rs.getString("citta"));
                    ind.setCap(rs.getString("cap"));
                    ind.setProvincia(rs.getString("provincia"));
                    ind.setNazione(rs.getString("nazione"));
                    ind.setAttivo(rs.getBoolean("is_attivo"));
                    indirizzi.add(ind);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return indirizzi;
    }

    // Elimina un indirizzo
    public boolean doDelete(int idIndirizzo) {
        String query = "DELETE FROM indirizzi WHERE id_indirizzo = ?";
        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, idIndirizzo);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Imposta un indirizzo come "Attivo" e disattiva tutti gli altri per quell'utente
    public boolean impostaAttivo(int idIndirizzo, int idUtente) {
        String resetQuery = "UPDATE indirizzi SET is_attivo = 0 WHERE id_utente = ?";
        String setActiveQuery = "UPDATE indirizzi SET is_attivo = 1 WHERE id_indirizzo = ?";
        
        try (Connection conn = ds.getConnection()) {
            // Disattiva tutti
            try (PreparedStatement psReset = conn.prepareStatement(resetQuery)) {
                psReset.setInt(1, idUtente);
                psReset.executeUpdate();
            }
            // Attiva solo quello scelto
            try (PreparedStatement psActive = conn.prepareStatement(setActiveQuery)) {
                psActive.setInt(1, idIndirizzo);
                return psActive.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}