package model;

import java.io.Serializable;

public class Prodotto implements Serializable {

    private static final long serialVersionUID = 1L;
    private int idProdotto;
    private String nome;
    private String squadra;
    private String stagione;
    private String marca;
    private String taglia;
    private double prezzo;
    private String campionato;
    private int quantita; 
    
    private String descrizione;
    private String immagine;
    private boolean attivo;

    
    private int quantitaCarrello = 1;

    public Prodotto() {}

    public Prodotto(int idProdotto, String nome, String squadra, String stagione, String marca, String taglia,
            double prezzo,String campionato, int quantita, String descrizione, String immagine, boolean attivo) {
        this.idProdotto = idProdotto;
        this.nome = nome;
        this.squadra = squadra;
        this.stagione = stagione;
        this.marca = marca;
        this.taglia = taglia;
        this.prezzo = prezzo;
        this.campionato=campionato;
        this.quantita = quantita;
        this.descrizione = descrizione;
        this.immagine = immagine;
        this.attivo = attivo;
    }

    // --- GETTER E SETTER ORIGINALI ---

    public int getIdProdotto() { return idProdotto; }
    public void setIdProdotto(int idProdotto) { this.idProdotto = idProdotto; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public String getSquadra() { return squadra; }
    public void setSquadra(String squadra) { this.squadra = squadra; }

    public String getStagione() { return stagione; }
    public void setStagione(String stagione) { this.stagione = stagione; }

    public String getMarca() { return marca; }
    public void setMarca(String marca) { this.marca = marca; }

    public String getTaglia() { return taglia; }
    public void setTaglia(String taglia) { this.taglia = taglia; }

    public double getPrezzo() { return prezzo; }
    public void setPrezzo(double prezzo) { this.prezzo = prezzo; }
    public String getCampionato() {
        return campionato;
    }

    public void setCampionato(String campionato) {
        this.campionato = campionato;
    }

    public int getQuantita() { return quantita; }
    public void setQuantita(int quantita) { this.quantita = quantita; }

    public String getDescrizione() { return descrizione; }
    public void setDescrizione(String descrizione) { this.descrizione = descrizione; }

    public String getImmagine() { return immagine; }
    public void setImmagine(String immagine) { this.immagine = immagine; }

    public boolean isAttivo() { return attivo; }
    public void setAttivo(boolean attivo) { this.attivo = attivo; }

    // --- NUOVI GETTER E SETTER PER IL CARRELLO ---

    public int getQuantitaCarrello() { return quantitaCarrello; }
    public void setQuantitaCarrello(int quantitaCarrello) { this.quantitaCarrello = quantitaCarrello; }

    @Override
    public String toString() {
        return "Prodotto [idProdotto=" + idProdotto + ", nome=" + nome + ", squadra=" + squadra + ", prezzo=" + prezzo + "]";
    }
}