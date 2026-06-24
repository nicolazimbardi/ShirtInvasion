const sidebar = document.getElementById("sidebarMenu");
const overlay = document.getElementById("menuOverlay");
const openBtn = document.getElementById("menuButton");
const closeBtn = document.querySelector(".close-btn");

openBtn.addEventListener("click", () => {
    sidebar.classList.add("open");
    overlay.classList.add("show");
});

closeBtn.addEventListener("click", () => {
    sidebar.classList.remove("open");
    overlay.classList.remove("show");
});

overlay.addEventListener("click", () => {
    sidebar.classList.remove("open");
    overlay.classList.remove("show");
});