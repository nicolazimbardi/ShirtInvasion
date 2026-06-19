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
            System.out.println("Errore nell'inizializzazione del DataSource in UtenteDAO!");
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
                    Utente utente = new Utente();
                    utente.setIdUtente(rs.getInt("id_utente"));
                    utente.setNome(rs.getString("nome"));
                    utente.setCognome(rs.getString("cognome"));
                    utente.setEmail(rs.getString("email"));
                    utente.setPassword(rs.getString("password"));
                    utente.setIndirizzo(rs.getString("indirizzo"));
                    utente.setTelefono(rs.getString("telefono"));
                    utente.setRuolo(rs.getString("ruolo"));
                    return utente;
                }
            }
        } catch (SQLException e) {
            System.out.println("Errore nel metodo doRetrieveByEmailAndPassword!");
            e.printStackTrace();
        }
        return null; 
    }
}
