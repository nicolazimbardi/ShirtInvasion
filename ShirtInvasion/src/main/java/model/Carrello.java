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

    /**
     * Aggiunge un prodotto al carrello in modo intelligente.
     * Se la maglia è già presente, aumenta semplicemente la sua quantità.
     */
    public void aggiungiProdotto(Prodotto p) {
        for (Prodotto esistente : elementi) {
            if (esistente.getIdProdotto() == p.getIdProdotto()) {
                // Il prodotto esiste già nel carrello: incremento la quantità
                esistente.setQuantitaCarrello(esistente.getQuantitaCarrello() + 1);
                return; // Esce dal metodo senza aggiungere un nuovo elemento alla lista
            }
        }
        // Se arriviamo qui, il prodotto non era nel carrello: lo aggiungiamo con quantità 1
        p.setQuantitaCarrello(1);
        this.elementi.add(p);
    }

    public void rimuoviProdotto(int idProdotto) {
        this.elementi.removeIf(p -> p.getIdProdotto() == idProdotto);
    }

    /**
     * Nuova azione richiesta dalla servlet per modificare la quantità
     * direttamente digitando il numero nel carrello.
     */
    public void aggiornaQuantita(int idProdotto, int nuovaQuantita) {
        for (Prodotto p : elementi) {
            if (p.getIdProdotto() == idProdotto) {
                p.setQuantitaCarrello(nuovaQuantita);
                break;
            }
        }
    }

    /**
     * Calcola il prezzo totale del carrello tenendo conto delle quantità.
     */
    public double getPrezzoTotale() {
        double totale = 0;
        for (Prodotto p : elementi) {
            // Moltiplica il prezzo della singola maglia per quante ne sono state selezionate
            totale += p.getPrezzo() * p.getQuantitaCarrello();
        }
        return totale;
    }

    public void svuota() {
        this.elementi.clear();
    }
    
    /**
     * Calcola il numero totale di maglie fisiche presenti nel carrello.
     * Es: Se ho 2 maglie della Juve e 1 del Napoli, restituisce 3.
     */
    public int getNumeroTotaleArticoli() {
        int conteggio = 0;
        for (Prodotto p : elementi) {
            conteggio += p.getQuantitaCarrello();
        }
        return conteggio;
    }
}