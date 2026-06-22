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
