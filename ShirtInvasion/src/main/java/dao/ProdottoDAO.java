package dao;

import java.sql.Connection;
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
            System.out.println("Errore nell'inizializzazione del DataSource in ProdottoDAO!");
            e.printStackTrace();
        }
    }

   
    public List<Prodotto> doRetrieveAll() {
        List<Prodotto> prodotti = new ArrayList<>();
        
        String query = "SELECT * FROM prodotti WHERE attivo = 1";

        try (Connection conn = ds.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(query)) {

            while (rs.next()) {
                Prodotto prodotto = new Prodotto();
                prodotto.setIdProdotto(rs.getInt("id_prodotto"));
                prodotto.setNome(rs.getString("nome"));
                prodotto.setSquadra(rs.getString("squadra"));
                prodotto.setStagione(rs.getString("stagione"));
                prodotto.setMarca(rs.getString("marca"));
                prodotto.setTaglia(rs.getString("taglia"));
                prodotto.setPrezzo(rs.getDouble("prezzo"));
                prodotto.setQuantita(rs.getInt("quantita"));
                prodotto.setDescrizione(rs.getString("descrizione"));
                prodotto.setImmagine(rs.getString("immagine"));
                prodotto.setAttivo(rs.getBoolean("attivo"));
                
                prodotti.add(prodotto);
            }
        } catch (SQLException e) {
            System.out.println("Errore nel metodo doRetrieveAll di ProdottoDAO!");
            e.printStackTrace();
        }
        return prodotti;
    }
}
