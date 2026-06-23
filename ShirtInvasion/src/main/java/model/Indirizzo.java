package model;

import java.io.Serializable;

public class Indirizzo implements Serializable {

    private static final long serialVersionUID = 1L;
    
    private int idIndirizzo;
    private int idUtente;
    private String via;
    private String citta;
    private String cap;
    private String provincia;
    private String nazione;
    private boolean attivo; // 1 se è l'indirizzo principale, 0 altrimenti

    public Indirizzo() {}

    public int getIdIndirizzo() { return idIndirizzo; }
    public void setIdIndirizzo(int idIndirizzo) { this.idIndirizzo = idIndirizzo; }

    public int getIdUtente() { return idUtente; }
    public void setIdUtente(int idUtente) { this.idUtente = idUtente; }

    public String getVia() { return via; }
    public void setVia(String via) { this.via = via; }

    public String getCitta() { return citta; }
    public void setCitta(String citta) { this.citta = citta; }

    public String getCap() { return cap; }
    public void setCap(String cap) { this.cap = cap; }

    public String getProvincia() { return provincia; }
    public void setProvincia(String provincia) { this.provincia = provincia; }

    public String getNazione() { return nazione; }
    public void setNazione(String nazione) { this.nazione = nazione; }

    public boolean isAttivo() { return attivo; }
    public void setAttivo(boolean attivo) { this.attivo = attivo; }
}