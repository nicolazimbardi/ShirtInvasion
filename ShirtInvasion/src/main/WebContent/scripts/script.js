// Funzione  per la modifica rapida 
function modificaRapida(id, stagione, marca, taglia, prezzo, stock, descrizione) {
    let nuovaStagione = prompt("Modifica Stagione:", stagione);
    if (nuovaStagione == null) return;
    let nuovaMarca = prompt("Modifica Marca:", marca);
    if (nuovaMarca == null) return;
    let nuovaTaglia = prompt("Modifica Taglia:", taglia);
    if (nuovaTaglia == null) return;
    let nuovoPrezzo = prompt("Modifica Prezzo (€):", prezzo);
    if (nuovoPrezzo == null) return;
    let nuovoStock = prompt("Modifica Stock (Quantità):", stock);
    if (nuovoStock == null) return;
    let nuovaDesc = prompt("Modifica Descrizione:", descrizione);
    if (nuovaDesc == null) return;

    document.getElementById('hidStagione' + id).value = nuovaStagione;
    document.getElementById('hidMarca' + id).value = nuovaMarca;
    document.getElementById('hidTaglia' + id).value = nuovaTaglia;
    document.getElementById('hidPrezzo' + id).value = nuovoPrezzo;
    document.getElementById('hidStock' + id).value = nuovoStock;
    document.getElementById('hidDesc' + id).value = nuovaDesc;

    document.getElementById('formModifica' + id).submit();
}

// Gestione Anteprima Immagine (Pannello Admin)
document.addEventListener('DOMContentLoaded', function() {
    const selectImmagine = document.getElementById('scelta-immagine');
    
    if (selectImmagine) {
        selectImmagine.addEventListener('change', function() {
            const select = this;
            const box = document.getElementById('box-anteprima');
            const img = document.getElementById('img-anteprima');
            
            const formAdmin = select.closest('form');
            const contextPath = formAdmin ? formAdmin.getAttribute('data-context') : '';

            if (select.value) {
                img.src = contextPath + '/images/' + select.value;
                box.style.display = 'flex'; 
            } else {
                box.style.display = 'none';
            }
        });
    }
});

// Gestione dello scroll al click di aggiungi al carrello 
document.addEventListener('DOMContentLoaded', function() {
    const pulsantiCarrello = document.querySelectorAll('.btn-add-cart');
    
    if (pulsantiCarrello.length > 0) {
        pulsantiCarrello.forEach(btn => {
            btn.addEventListener('click', () => {
                localStorage.setItem('catalogoScrollPos', window.scrollY);
            });
        });

        const scrollPos = localStorage.getItem('catalogoScrollPos');
        if (scrollPos) {
            window.scrollTo(0, parseInt(scrollPos));
            localStorage.removeItem('catalogoScrollPos');
        }
    }
});
