// 1. Gestione Mostra/Nascondi form nuovo indirizzo
function gestisciNuovoIndirizzo() {
    let select = document.getElementById("indirizzoSelezionato");
    let divNuovo = document.getElementById("divNuovoIndirizzo");
    
    if (select.value === "nuovo") {
        divNuovo.style.display = "block";
    } else {
        divNuovo.style.display = "none";
        // Pulisce gli errori visivi se l'utente cambia idea e seleziona un indirizzo esistente
        nascondiErrori();
    }
}

// 2. Funzione per resettare graficamente gli errori
function nascondiErrori() {
    document.querySelectorAll('.error-msg').forEach(el => el.style.display = 'none');
    document.querySelectorAll('.input-error').forEach(el => el.classList.remove('input-error'));
}

// 3. Funzione di supporto per mostrare un errore specifico
function mostraErrore(inputId, errorId) {
    document.getElementById(inputId).classList.add("input-error");
    document.getElementById(errorId).style.display = "block";
}

// 4. Validazione al Submit
document.getElementById('checkout-form').addEventListener('submit', function(e) {
    e.preventDefault(); // Blocca l'invio di default
    nascondiErrori();   // Resetta errori precedenti
    let isValid = true;

    let selectIndirizzo = document.getElementById("indirizzoSelezionato").value;

    // Controllo se ha selezionato nulla
    if (!selectIndirizzo) {
        mostraErrore("indirizzoSelezionato", "errSelezionato");
        isValid = false;
    }

    // Se sceglie di inserire un NUOVO indirizzo, validiamo i campi con Regex
    if (selectIndirizzo === "nuovo") {
        let via = document.getElementById("via_nuovo").value.trim();
        let citta = document.getElementById("citta_nuovo").value.trim();
        let cap = document.getElementById("cap_nuovo").value.trim();
        let provincia = document.getElementById("provincia_nuovo").value.trim();

        // Controllo Via (Non vuoto)
        if (via === "") {
            mostraErrore("via_nuovo", "errVia");
            isValid = false;
        }

        // Controllo Città (Non vuoto)
        if (citta === "") {
            mostraErrore("citta_nuovo", "errCitta");
            isValid = false;
        }

        // Controllo CAP: Esattamente 5 numeri
        let capRegex = /^[0-9]{5}$/;
        if (!capRegex.test(cap)) {
            mostraErrore("cap_nuovo", "errCap");
            isValid = false;
        }

        // Controllo Provincia: Esattamente 2 lettere
        let provRegex = /^[A-Za-z]{2}$/;
        if (!provRegex.test(provincia)) {
            mostraErrore("provincia_nuovo", "errProv");
            isValid = false;
        }
    }

    // Se tutto è corretto, mostra l'overlay animato e invia la form
    if (isValid) {
        document.getElementById('loading-overlay').style.display = 'flex';
        // Simula il tempo di elaborazione per far vedere il loader (puoi anche togliere il setTimeout se preferisci invio immediato)
        setTimeout(() => {
            this.submit();
        }, 1500); 
    }
});