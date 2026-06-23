const menuBtn = document.getElementById("menuBtn");
const menuDropdown = document.getElementById("menuDropdown");

if(menuBtn && menuDropdown){

    menuBtn.addEventListener("click", function(e){

        e.stopPropagation();

        if(menuDropdown.style.display === "block"){
            menuDropdown.style.display = "none";
        }else{
            menuDropdown.style.display = "block";
        }

    });

    document.addEventListener("click", function(){
        menuDropdown.style.display = "none";
    });
}