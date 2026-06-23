document.addEventListener("DOMContentLoaded", function() {
    // Selezioniamo il form e tutti i campi necessari
    const registrazioneForm = document.getElementById("registrazioneForm");
    const emailInput = document.getElementById("email");
    const telefonoInput = document.getElementById("telefono");
    const passwordInput = document.getElementById("password");
    const confermaPasswordInput = document.getElementById("confermaPassword");

    // Funzione per rimuovere i messaggi di errore precedenti
    function clearErrors() {
        const errorMessages = document.querySelectorAll(".js-error-msg");
        errorMessages.forEach(msg => msg.remove());
    }

    // Funzione per mostrare l'errore sotto il rispettivo campo
    function showError(inputElement, message) {
        const errorDiv = document.createElement("div");
        errorDiv.className = "js-error-msg";
        errorDiv.style.color = "red";
        errorDiv.style.fontSize = "0.85em";
        errorDiv.style.marginTop = "5px";
        errorDiv.innerText = message;
        
        inputElement.parentNode.appendChild(errorDiv);
    }

    // Listener sul submit del form
    registrazioneForm.addEventListener("submit", function(event) {
        let isValid = true;
        
      
        clearErrors();

        //  Validazione Email
        const emailValue = emailInput.value.trim();
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailValue) {
            showError(emailInput, "Il campo email è obbligatorio.");
            isValid = false;
        } else if (!emailRegex.test(emailValue)) {
            showError(emailInput, "Inserisci un indirizzo email valido.");
            isValid = false;
        }

        //  Validazione Telefono 
        const telefonoValue = telefonoInput.value.trim();
        const telefonoRegex = /^[0-9]{9,11}$/;
        if (!telefonoValue) {
            showError(telefonoInput, "Il numero di telefono è obbligatorio.");
            isValid = false;
        } else if (!telefonoRegex.test(telefonoValue)) {
            showError(telefonoInput, "Inserisci un numero di telefono valido (solo numeri, da 9 a 11 cifre).");
            isValid = false;
        }

        //  Validazione Password principale
        const passwordValue = passwordInput.value;
        const uppercaseRegex = /[A-Z]/;
        const specialCharRegex = /[!@#$%^&*(),.?":{}|<>_+\-=\[\]\\]/;

        if (!passwordValue) {
            showError(passwordInput, "La password è obbligatoria.");
            isValid = false;
        } else if (passwordValue.length < 6) {
            showError(passwordInput, "La password deve contenere almeno 6 caratteri.");
            isValid = false;
        } else if (!uppercaseRegex.test(passwordValue)) {
            showError(passwordInput, "La password deve contenere almeno una lettera maiuscola.");
            isValid = false;
        } else if (!specialCharRegex.test(passwordValue)) {
            showError(passwordInput, "La password deve contenere almeno un carattere speciale.");
            isValid = false;
        }

        //  Validazione Conferma Password
        const confermaPasswordValue = confermaPasswordInput.value;
        if (!confermaPasswordValue) {
            showError(confermaPasswordInput, "Conferma la tua password.");
            isValid = false;
        } else if (passwordValue !== confermaPasswordValue) {
            showError(confermaPasswordInput, "Le password non corrispondono.");
            isValid = false;
        }

        //Blocca l'invio del form alla servlet se c'è anche un solo errore
        if (!isValid) {
            event.preventDefault();
        }
    });
});