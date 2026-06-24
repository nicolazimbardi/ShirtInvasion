document.addEventListener("DOMContentLoaded", function() {
    
    // --- 1. VALIDAZIONE FORM DATI PROFILO ---
    const formProfilo = document.getElementById("form-profilo");
    
    if (formProfilo) {
        formProfilo.addEventListener("submit", function(event) {
            const email = document.getElementById("email").value;
            const telefono = document.getElementById("telefono").value;

            // Controllo Email: deve essere nel formato test@test.com
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                alert("Per favore, inserisci un indirizzo email valido.");
                event.preventDefault(); // Blocca l'invio del form
                return;
            }

            // Controllo Telefono: opzionale, ma se inserito deve avere tra 9 e 15 caratteri (numeri e prefisso +)
            if (telefono.trim() !== "") {
                const telRegex = /^[0-9+ ]{9,15}$/;
                if (!telRegex.test(telefono)) {
                    alert("Il numero di telefono inserito non è valido. Usa solo numeri.");
                    event.preventDefault();
                    return;
                }
            }
        });
    }

    // --- 2. VALIDAZIONE FORM NUOVO INDIRIZZO ---
    const formIndirizzo = document.getElementById("form-indirizzo");
    
    if (formIndirizzo) {
        formIndirizzo.addEventListener("submit", function(event) {
            const cap = document.getElementById("cap").value;
            const provincia = document.getElementById("provincia").value;

            // Controllo CAP: esattamente 5 numeri
            const capRegex = /^[0-9]{5}$/;
            if (!capRegex.test(cap)) {
                alert("Il CAP deve essere composto esattamente da 5 numeri (es. 84018).");
                event.preventDefault();
                return;
            }

            // Controllo Provincia: esattamente 2 lettere (es. SA, NA, RM)
            const provRegex = /^[a-zA-Z]{2}$/;
            if (!provRegex.test(provincia)) {
                alert("La provincia deve contenere esattamente 2 lettere (es. SA).");
                event.preventDefault();
                return;
            }
        });
    }
});