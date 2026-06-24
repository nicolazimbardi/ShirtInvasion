document.addEventListener("DOMContentLoaded", function() {
    
    // ==========================================
    // 1. GESTIONE RICERCA PRODOTTI AJAX
    // ==========================================
    const searchBar = document.getElementById("searchBar");
    const suggerimentiBox = document.getElementById("suggerimentiBox");

    // verifica che la barra esista in questa pagina prima di avviare lo script
    if (searchBar && suggerimentiBox) {
        
        searchBar.addEventListener("input", function() {
            const query = searchBar.value.trim();

            // Fai partire la chiamata AJAX solo se ci sono almeno 2 lettere
            if (query.length >= 2) {
                
                // Aggiungiamo contextPath se disponibile per sicurezza sui percorsi
                const urlRicerca = (typeof contextPath !== 'undefined' ? contextPath : '') + "/RicercaAjaxServlet?q=" + encodeURIComponent(query);

                fetch(urlRicerca)
                    .then(response => response.json()) // Trasforma la risposta in un oggetto JS
                    .then(data => {
                        
                        // Svuota i vecchi suggerimenti
                        suggerimentiBox.innerHTML = "";

                        if (data.length > 0) {
                            // Rende visibile il menu a tendina
                            suggerimentiBox.style.display = "block";

                            // Cicla su ogni prodotto trovato nel database
                            data.forEach(prodotto => {
                                const div = document.createElement("div");

                                div.style.display = "flex";
                                div.style.alignItems = "center";
                                div.style.gap = "10px";
                                div.style.padding = "10px";
                                div.style.cursor = "pointer";
                                div.style.borderBottom = "1px solid #eee";

                                div.innerHTML = `
                                    <img
                                        src="images/${prodotto.immagine}"
                                        alt="${prodotto.nome}"
                                        style="width:60px;height:60px;object-fit:cover;border-radius:5px;">

                                    <div>
                                        <strong>${prodotto.nome}</strong><br>
                                        <span>${prodotto.squadra}</span>
                                    </div>
                                `;

                                // Ti porta alla pagina del singolo prodotto.
                                div.addEventListener("click", function() {
                                    const urlDettaglio = (typeof contextPath !== 'undefined' ? contextPath : '') + "/DettaglioServlet?id=" + prodotto.idProdotto;
                                    window.location.href = urlDettaglio;
                                });

                                div.addEventListener("mouseenter", () => div.style.backgroundColor = "#f0f0f0");
                                div.addEventListener("mouseleave", () => div.style.backgroundColor = "white");

                                // Aggiunge il suggerimento al box
                                suggerimentiBox.appendChild(div);
                            });
                        } else {
                            // Se il database non trova nulla
                            suggerimentiBox.style.display = "block";
                            suggerimentiBox.innerHTML = "<div style='padding: 10px; color: gray;'>Nessun prodotto trovato.</div>";
                        }
                    })
                    .catch(error => console.error("Errore nella ricerca AJAX:", error));
                    
            } else {
                // Se ci sono meno di 2 lettere nasconde il box
                suggerimentiBox.style.display = "none";
                suggerimentiBox.innerHTML = "";
            }
        });

        // nasconde il menu se l'utente clicca un punto a caso fuori dalla barra
        document.addEventListener("click", function(event) {
            if (event.target !== searchBar && event.target !== suggerimentiBox) {
                suggerimentiBox.style.display = "none";
            }
        });
    }
}); // <--- Questa è la parte che mancava!