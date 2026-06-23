document.addEventListener("DOMContentLoaded", function() {
    
    // Recuperiamo gli elementi dall'HTML
    const searchBar = document.getElementById("searchBar");
    const suggerimentiBox = document.getElementById("suggerimentiBox");

    // verifica che la barra esista in questa pagina prima di avviare lo script
    if (searchBar && suggerimentiBox) {
        
        searchBar.addEventListener("input", function() {
            const query = searchBar.value.trim();

            // Fai partire la chiamata AJAX solo se ci sono almeno 2 lettere
            if (query.length >= 2) {
                
                // Chiama la Servlet passandogli il testo 
                // Se la servlet si trova in una cartella specifica, adatta l'URL
                fetch("RicercaAjaxServlet?q=" + encodeURIComponent(query))
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
                                div.style.padding = "10px";
                                div.style.cursor = "pointer";
                                div.style.borderBottom = "1px solid #eee";
                                
                                // Mostra il Nome e la Squadra
                                div.innerHTML = `<strong>${prodotto.nome}</strong> - <em>${prodotto.squadra}</em>`;

                               
                                //Ti porta alla pagina del singolo prodotto.
                                div.addEventListener("click", function() {
                                    window.location.href = "ProdottoServlet?id=" + prodotto.idProdotto;
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
                // Se ci sono meno di 2 lettere  nasconde il box
                suggerimentiBox.style.display = "none";
                suggerimentiBox.innerHTML = "";
            }
        });

        //  nasconde il menu se l'utente clicca un punto a caso fuori dalla barra
        document.addEventListener("click", function(event) {
            if (event.target !== searchBar && event.target !== suggerimentiBox) {
                suggerimentiBox.style.display = "none";
            }
        });
    }
});