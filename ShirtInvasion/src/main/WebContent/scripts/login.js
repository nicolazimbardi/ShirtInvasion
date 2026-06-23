document.addEventListener("DOMContentLoaded", function() {
    const loginForm = document.getElementById("loginForm");
    const emailInput = document.getElementById("email");
    const passwordInput = document.getElementById("password");

    function clearErrors() {
        const errorMessages = document.querySelectorAll(".js-error-msg");
        errorMessages.forEach(msg => msg.remove());
    }

    function showError(inputElement, message) {
        const errorDiv = document.createElement("div");
        errorDiv.className = "js-error-msg";
        errorDiv.style.color = "red";
        errorDiv.style.fontSize = "0.85em";
        errorDiv.style.marginTop = "5px";
        errorDiv.innerText = message;
        
        inputElement.parentNode.appendChild(errorDiv);
    }

    loginForm.addEventListener("submit", function(event) {
        let isValid = true;
        
        clearErrors();

        const emailValue = emailInput.value.trim();
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/; 
        
        if (!emailValue) {
            showError(emailInput, "Il campo email non può essere vuoto.");
            isValid = false;
        } else if (!emailRegex.test(emailValue)) {
            showError(emailInput, "Per favore, inserisci un indirizzo email valido.");
            isValid = false;
        }

        // Validazione Password
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

        if (!isValid) {
            event.preventDefault();
        }
    });
});