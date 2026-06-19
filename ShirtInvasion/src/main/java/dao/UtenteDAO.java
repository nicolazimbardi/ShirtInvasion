package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import model.Utente;

public class UtenteDAO {
    
    private static DataSource ds;

    static {
        try {
            InitialContext ctx = new InitialContext();
            ds = (DataSource) ctx.lookup("java:comp/env/jdbc/shirtinvasion");
        } catch (NamingException e) {
            e.printStackTrace();
        }
    }

    public Utente doRetrieveByEmailAndPassword(String email, String password) {
        String query = "SELECT * FROM utenti WHERE email = ? AND password = ?";
        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, email);
            ps.setString(2, password);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Utente u = new Utente();
                    u.setIdUtente(rs.getInt("id_utente"));
                    u.setNome(rs.getString("nome"));
                    u.setCognome(rs.getString("cognome"));
                    u.setEmail(rs.getString("email"));
                    u.setPassword(rs.getString("password"));
                    u.setIndirizzo(rs.getString("indirizzo"));
                    u.setTelefono(rs.getString("telefono"));
                    u.setRuolo(rs.getString("ruolo"));
                    return u;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean doSave(Utente utente) {
        String query = "INSERT INTO utenti (nome, cognome, email, password, indirizzo, telefono, ruolo) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, utente.getNome());
            ps.setString(2, utente.getCognome());
            ps.setString(3, utente.getEmail());
            ps.setString(4, utente.getPassword());
            ps.setString(5, utente.getIndirizzo());
            ps.setString(6, utente.getTelefono());
            ps.setString(7, utente.getRuolo() != null ? utente.getRuolo() : "CLIENTE");
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean doUpdate(Utente utente) {
        String query = "UPDATE utenti SET nome = ?, cognome = ?, email = ?, password = ?, indirizzo = ?, telefono = ?, ruolo = ? WHERE id_utente = ?";
        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, utente.getNome());
            ps.setString(2, utente.getCognome());
            ps.setString(3, utente.getEmail());
            ps.setString(4, utente.getPassword());
            ps.setString(5, utente.getIndirizzo());
            ps.setString(6, utente.getTelefono());
            ps.setString(7, utente.getRuolo());
            ps.setInt(8, utente.getIdUtente());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean doDelete(int idUtente) {
        String query = "DELETE FROM utenti WHERE id_utente = ?";
        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, idUtente);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
s