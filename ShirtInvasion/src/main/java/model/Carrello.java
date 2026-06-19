package model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class Carrello implements Serializable {
    private static final long serialVersionUID = 1L;

    private List<Prodotto> elementi;

    public Carrello() {
        this.elementi = new ArrayList<>();
    }

    public List<Prodotto> getElementi() {
        return elementi;
    }

    public void aggiungiProdotto(Prodotto p) {
        this.elementi.add(p);
    }

    public void rimuoviProdotto(int idProdotto) {
        this.elementi.removeIf(p -> p.getIdProdotto() == idProdotto);
    }

    public double getPrezzoTotale() {
        double totale = 0;
        for (Prodotto p : elementi) {
            totale += p.getPrezzo();
        }
        return totale;
    }

    public void svuota() {
        this.elementi.clear();
    }
}
