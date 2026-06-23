package model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Ordine implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int idOrdine;
    private int idUtente;
    private Timestamp dataOrdine;
    private double totale;
    private String stato;
    private List<DettaglioOrdine> dettagli;

    public Ordine() {
        this.dettagli = new ArrayList<>();
    }

    public int getIdOrdine() { return idOrdine; }
    public void setIdOrdine(int idOrdine) { this.idOrdine = idOrdine; }

    public int getIdUtente() { return idUtente; }
    public void setIdUtente(int idUtente) { this.idUtente = idUtente; }

    public Timestamp getDataOrdine() { return dataOrdine; }
    public void setDataOrdine(Timestamp dataOrdine) { this.dataOrdine = dataOrdine; }

    public double getTotale() { return totale; }
    public void setTotale(double totale) { this.totale = totale; }

    public String getStato() { return stato; }
    public void setStato(String stato) { this.stato = stato; }

    public List<DettaglioOrdine> getDettagli() { return dettagli; }
    public void setDettagli(List<DettaglioOrdine> dettagli) { this.dettagli = dettagli; }
    
    public void addDettaglio(DettaglioOrdine dettaglio) {
        this.dettagli.add(dettaglio);
    }
}