document.addEventListener("DOMContentLoaded", function() {
    
    // 1. Definiamo le Regex per ogni campo del form
    const validatori = {
        nome: {
            regex: /^[a-zA-ZÀ-ÿ\s']+$/,
            messaggio: "Il nome può contenere solo lettere e spazi."
        },
        cognome: {
            regex: /^[a-zA-ZÀ-ÿ\s']+$/,
            messaggio: "Il cognome può contenere solo lettere e spazi."
        },
        telefono: {
            regex: /^(\+?\d{9,15})$/, 
            messaggio: "Inserire un numero di telefono valido (da 9 a 15 cifre)."
        },
        via: {
            regex: /^[a-zA-Z0-9À-ÿ\s,.\-/]+$/,
            messaggio: "Formato via non valido (lettere, numeri e caratteri speciali minimi)."
        },
        citta: {
            regex: /^[a-zA-ZÀ-ÿ\s']+$/,
            messaggio: "La città può contenere solo lettere."
        },
        cap: {
            regex: /^\d{5}$/,
            messaggio: "Il CAP deve essere di esattamente 5 numeri."
        },
        provincia: {
            regex: /^[a-zA-Z]{2}$/,
            messaggio: "La provincia deve contenere esattamente 2 lettere."
        },
        nazione: {
            regex: /^[a-zA-ZÀ-ÿ\s']+$/,
            messaggio: "La nazione può contenere solo lettere."
        }
    };
	// 2. Funzione per iniettare l'errore nel DOM senza spaccare la griglia CSS
	    function mostraErrore(input, messaggio) {
	        let container = input.closest(".profile-form-group");
	        if (!container) return false;

	        // Trasformiamo il contenitore in "relative" per ancorare il messaggio di errore
	        container.style.position = "relative";

	        let errorSpan = container.querySelector(".error-msg");
	        if (!errorSpan) {
	            errorSpan = document.createElement("span");
	            errorSpan.className = "error-msg";
	            
	            // --- NUOVO STILE VISIVO ---
	            // Usiamo absolute per NON far spostare il form
	            errorSpan.style.position = "absolute"; 
	            errorSpan.style.top = "100%"; // Si posiziona al limite inferiore del contenitore
	            errorSpan.style.left = "0";
	            
	            // Font più piccolo, discreto e meno invadente
	            errorSpan.style.color = "#ff4d4d";
	            errorSpan.style.fontSize = "12px"; // Grandezza ridotta
	            errorSpan.style.fontWeight = "500"; // Meno in grassetto di prima
	            errorSpan.style.marginTop = "3px"; // Leggera distanza dall'input
	            errorSpan.style.lineHeight = "1.2";
	            errorSpan.style.width = "100%"; // Assicura che non sbordi di lato
	            
	            container.appendChild(errorSpan);
	        }
	        
	        // Ho rimosso la "❌" gigante per renderlo più pulito (puoi rimetterla se preferisci)
	        errorSpan.textContent = messaggio; 
	        
	        input.style.borderColor = "#ff4d4d";
	        input.style.backgroundColor = "#ffe6e6";
	        return false;
	    }

    // 3. Funzione per pulire l'errore se corretto
    function pulisciErrore(input) {
        let container = input.closest(".profile-form-group");
        if (!container) return true;

        let errorSpan = container.querySelector(".error-msg");
        if (errorSpan) {
            errorSpan.remove();
        }
        input.style.borderColor = "#2ed573";
        input.style.backgroundColor = "";
        return true;
    }

    // 4. Logica di validazione del singolo elemento
    function validaCampo(input) {
        const id = input.id;
        const valore = input.value.trim();

        if (input.hasAttribute("required") && valore === "") {
            return mostraErrore(input, "Questo campo è obbligatorio.");
        }

        if (!input.hasAttribute("required") && valore === "") {
            return pulisciErrore(input);
        }

        if (validatori[id] && !validatori[id].regex.test(valore)) {
            return mostraErrore(input, validatori[id].messaggio);
        }

        return pulisciErrore(input);
    }

    // 5. Assegniamo gli eventi in tempo reale sia su 'blur' (quando si esce dal campo) sia su 'input'
    const idCampi = ["nome", "cognome", "telefono", "via", "citta", "cap", "provincia", "nazione"];
    
    idCampi.forEach(id => {
        const inputElement = document.getElementById(id);
        if (inputElement) {
            // Evento attivato quando l'utente si sposta dal campo (Richiesta del Prof)
            inputElement.addEventListener("blur", function() {
                if (id === "provincia") this.value = this.value.toUpperCase();
                validaCampo(this);
            });
            // Opzionale ma consigliato per ripulire l'errore mentre digita la cosa giusta
            inputElement.addEventListener("input", function() {
                if (id === "provincia") this.value = this.value.toUpperCase();
                let container = this.closest(".profile-form-group");
                if (container && container.querySelector(".error-msg")) {
                    validaCampo(this); // Aggiorna l'errore real-time se ne aveva già fatto uno
                }
            });
        }
    });

    // 6. Validazione bloccante sul SUBMIT per Informazioni Personali
    const formProfilo = document.getElementById("form-profilo");
    if (formProfilo) {
        formProfilo.addEventListener("submit", function(event) {
            let formValido = true;
            const campiProfilo = ["nome", "cognome", "telefono"];
            
            campiProfilo.forEach(id => {
                const inputElement = document.getElementById(id);
                if (inputElement) {
                    const ris = validaCampo(inputElement);
                    if (!ris) formValido = false;
                }
            });

            if (!formValido) {
                event.preventDefault(); // BLOCCA l'invio al Server
            }
        });
    }

    // 7. Validazione bloccante sul SUBMIT per il Nuovo Indirizzo
    const formIndirizzo = document.getElementById("form-indirizzo");
    if (formIndirizzo) {
        formIndirizzo.addEventListener("submit", function(event) {
            let formValido = true;
            const campiIndirizzo = ["via", "citta", "cap", "provincia", "nazione"];
            
            campiIndirizzo.forEach(id => {
                const inputElement = document.getElementById(id);
                if (inputElement) {
                    const ris = validaCampo(inputElement);
                    if (!ris) formValido = false;
                }
            });

            if (!formValido) {
                event.preventDefault(); // BLOCCA l'invio al Server
            }
        });
    }
});