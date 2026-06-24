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
import model.Prodotto;

public class ProdottoDAO {

    private static DataSource ds;

    static {
        try {
            InitialContext ctx = new InitialContext();
            ds = (DataSource) ctx.lookup("java:comp/env/jdbc/shirtinvasion");
        } catch (NamingException e) {
            e.printStackTrace();
        }
    }
 // Metodo di supporto per chi chiama doRetrieveAll() senza filtri
    public List<Prodotto> doRetrieveAll() {
        return doRetrieveAll("", "", "");
    }
    public List<Prodotto> doRetrieveAll(String marca, String taglia, String ordine) {
        List<Prodotto> prodotti = new ArrayList<>();
        
        // Base della query query
        StringBuilder queryBuilder = new StringBuilder("SELECT * FROM prodotti WHERE attivo = 1");
        
        // Aggiungiamo i filtri solo se sono stati effettivamente selezionati
        if (marca != null && !marca.trim().isEmpty()) {
            queryBuilder.append(" AND marca = ?");
        }
        if (taglia != null && !taglia.trim().isEmpty()) {
            queryBuilder.append(" AND taglia = ?");
        }
        
        // Applichiamo l'ordinamento sul prezzo
        if (ordine != null && (ordine.equalsIgnoreCase("ASC") || ordine.equalsIgnoreCase("DESC"))) {
            queryBuilder.append(" ORDER BY prezzo ").append(ordine);
        }

        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(queryBuilder.toString())) {
            
            int paramIndex = 1;
            if (marca != null && !marca.trim().isEmpty()) {
                ps.setString(paramIndex++, marca);
            }
            if (taglia != null && !taglia.trim().isEmpty()) {
                ps.setString(paramIndex++, taglia);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Prodotto p = new Prodotto();
                    p.setIdProdotto(rs.getInt("id_prodotto"));
                    p.setNome(rs.getString("nome"));
                    p.setSquadra(rs.getString("squadra"));
                    p.setCampionato(rs.getString("campionato"));
                    p.setStagione(rs.getString("stagione"));
                    p.setMarca(rs.getString("marca"));
                    p.setTaglia(rs.getString("taglia"));
                    p.setPrezzo(rs.getDouble("prezzo"));
                    p.setQuantita(rs.getInt("quantita"));
                    p.setDescrizione(rs.getString("descrizione"));
                    p.setImmagine(rs.getString("immagine"));
                    p.setAttivo(rs.getBoolean("attivo"));
                    prodotti.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return prodotti;
    }

    public Prodotto doRetrieveById(int idProdotto) {
        String query = "SELECT * FROM prodotti WHERE id_prodotto = ?";
        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, idProdotto);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Prodotto p = new Prodotto();
                    p.setIdProdotto(rs.getInt("id_prodotto"));
                    p.setNome(rs.getString("nome"));
                    p.setSquadra(rs.getString("squadra"));
                    p.setCampionato(rs.getString("campionato"));
                    p.setStagione(rs.getString("stagione"));
                    p.setMarca(rs.getString("marca"));
                    p.setTaglia(rs.getString("taglia"));
                    p.setPrezzo(rs.getDouble("prezzo"));
                    p.setQuantita(rs.getInt("quantita"));
                    p.setDescrizione(rs.getString("descrizione"));
                    p.setImmagine(rs.getString("immagine"));
                    p.setAttivo(rs.getBoolean("attivo"));
                    return p;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean doSave(Prodotto prodotto) {
        String query ="INSERT INTO prodotti (nome, squadra, campionato, stagione, marca, taglia, prezzo, quantita, descrizione, immagine, attivo) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";  
        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, prodotto.getNome());
            ps.setString(2, prodotto.getSquadra());
            ps.setString(3, prodotto.getCampionato());
            ps.setString(4, prodotto.getStagione());
            ps.setString(5, prodotto.getMarca());
            ps.setString(6, prodotto.getTaglia());
            ps.setDouble(7, prodotto.getPrezzo());
            ps.setInt(8, prodotto.getQuantita());
            ps.setString(9, prodotto.getDescrizione());
            ps.setString(10, prodotto.getImmagine());
            ps.setBoolean(11, prodotto.isAttivo());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean doUpdate(Prodotto prodotto) {
        String query = "UPDATE prodotti SET nome = ?, squadra = ?, campionato = ?, stagione = ?, marca = ?, taglia = ?, prezzo = ?, quantita = ?, descrizione = ?, immagine = ?, attivo = ? WHERE id_prodotto = ?";        
         
        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, prodotto.getNome());
            ps.setString(2, prodotto.getSquadra());
            ps.setString(3, prodotto.getCampionato());
            ps.setString(4, prodotto.getStagione());
            ps.setString(5, prodotto.getMarca());
            ps.setString(6, prodotto.getTaglia());
            ps.setDouble(7, prodotto.getPrezzo());
            ps.setInt(8, prodotto.getQuantita());
            ps.setString(9, prodotto.getDescrizione());
            ps.setString(10, prodotto.getImmagine());
            ps.setBoolean(11, prodotto.isAttivo());
            
            ps.setInt(12, prodotto.getIdProdotto());  
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean doDelete(int idProdotto) {
        String query = "UPDATE prodotti SET attivo = false WHERE id_prodotto = ?";
        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, idProdotto);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Prodotto> doRetrieveByNome(String testo) {

        List<Prodotto> prodotti = new ArrayList<>();

        String query = 
            "SELECT * FROM prodotti " + 
            "WHERE attivo = 1 AND (" + 
            "nome LIKE ? OR " + 
            "squadra LIKE ? OR " + 
            "descrizione LIKE ? OR " + 
            "marca LIKE ? OR " + 
            "stagione LIKE ?" + 
            ")";

        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            String ricerca = "%" + testo + "%";

            ps.setString(1, ricerca);
            ps.setString(2, ricerca);
            ps.setString(3, ricerca);
            ps.setString(4, ricerca);
            ps.setString(5, ricerca);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Prodotto p = new Prodotto();

                    p.setIdProdotto(rs.getInt("id_prodotto"));
                    p.setNome(rs.getString("nome"));
                    p.setSquadra(rs.getString("squadra"));
                    p.setStagione(rs.getString("stagione"));
                    p.setMarca(rs.getString("marca"));
                    p.setTaglia(rs.getString("taglia"));
                    p.setPrezzo(rs.getDouble("prezzo"));
                    p.setQuantita(rs.getInt("quantita"));
                    p.setDescrizione(rs.getString("descrizione"));
                    p.setImmagine(rs.getString("immagine"));
                    p.setAttivo(rs.getBoolean("attivo"));

                    prodotti.add(p);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return prodotti;
    }

    public List<Prodotto> doRetrieveByCampionato(String campionato) {

        List<Prodotto> prodotti = new ArrayList<>();

        String query = 
            "SELECT * FROM prodotti " + 
            "WHERE campionato = ? AND attivo = 1";

        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, campionato);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Prodotto p = new Prodotto();

                    p.setIdProdotto(rs.getInt("id_prodotto"));
                    p.setNome(rs.getString("nome"));
                    p.setSquadra(rs.getString("squadra"));
                    p.setStagione(rs.getString("stagione"));
                    p.setMarca(rs.getString("marca"));
                    p.setTaglia(rs.getString("taglia"));
                    p.setPrezzo(rs.getDouble("prezzo"));
                    p.setQuantita(rs.getInt("quantita"));
                    p.setDescrizione(rs.getString("descrizione"));
                    p.setImmagine(rs.getString("immagine"));
                    p.setAttivo(rs.getBoolean("attivo"));

                    prodotti.add(p);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return prodotti;
    }

    public boolean aggiornaStock(int idProdotto, int quantitaDaSottrarre) {
        // La clausola "quantita >= ?" ci protegge da eventuali stock negativi a livello di database
        String query = "UPDATE prodotti SET quantita = quantita - ? WHERE id_prodotto = ? AND quantita >= ?";
        
        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, quantitaDaSottrarre);
            ps.setInt(2, idProdotto);
            ps.setInt(3, quantitaDaSottrarre);
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}