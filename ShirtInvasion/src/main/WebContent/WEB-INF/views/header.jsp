<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Utente" %>
<%@ page import="model.Carrello" %>
<%@ page import="model.Prodotto" %>

<div id="menuOverlay" class="menu-overlay" onclick="closeSidebar()"></div>

<nav id="sidebarMenu" class="sidebar">
    <a href="javascript:void(0)" class="close-btn" onclick="closeSidebar()">&times;</a>
    <div class="sidebar-header">
        <h2>Campionati</h2>
    </div>
    <a href="${pageContext.request.contextPath}/campionato?nome=Serie A">Serie A</a>
    <a href="${pageContext.request.contextPath}/campionato?nome=Premier League">Premier League</a>
    <a href="${pageContext.request.contextPath}/campionato?nome=La Liga">La Liga</a>
</nav>

<header class="main-header">
    <div class="header-left" style="display: flex; align-items: center; gap: 15px;">
        <button class="hamburger-btn" onclick="openSidebar()">☰</button>
        <div class="logo">
            <a href="${pageContext.request.contextPath}/" style="text-decoration: none; color: inherit;">
                <h1>Shirt<span>Invasion</span> <img src="${pageContext.request.contextPath}/images/logo-icon.png" alt="Logo" class="header-logo-img"></h1>
            </a>
        </div>
    </div>
    
    <nav class="nav-bar">
        <ul>
            <% 
                // CONTROLLO PAGINA ATTUALE: verifica se l'utente è nel carrello o nel pannello admin
                String currentURI = request.getRequestURI();
                boolean isCarrelloPage = currentURI.contains("CarrelloServlet") || currentURI.contains("carrello.jsp");
                boolean isAdminPage = currentURI.contains("AdminServlet") || currentURI.contains("admin.jsp");

                // Calcolo articoli nel carrello
                Carrello carrelloSession = (Carrello) session.getAttribute("carrello");
                int numeroArticoli = 0;
                if (carrelloSession != null && carrelloSession.getElementi() != null) {
                    for (Prodotto p : carrelloSession.getElementi()) {
                        numeroArticoli += p.getQuantitaCarrello();
                    }
                }

                // Gestione Utente
                Utente utenteLoggatoHeader = (Utente) session.getAttribute("utente");
                
                if (utenteLoggatoHeader != null) { 
                    if (!"ADMIN".equalsIgnoreCase(utenteLoggatoHeader.getRuolo())) {
            %>
                        <li class="user-menu-item">
                            <div class="user-menu-container">
                                <div class="user-menu-trigger">
                                   Ciao, <%= utenteLoggatoHeader.getNome() %> ▼
                                </div>
                                <div class="dropdown-content">
                                    <a href="${pageContext.request.contextPath}/"><span>Home</span> <span>🏠</span></a>
                                    <a href="${pageContext.request.contextPath}/ProfiloServlet"><span>Profilo</span> <span>👤</span></a>
                                    <a href="${pageContext.request.contextPath}/OrdiniServlet"><span>Ordini effettuati</span> <span>📦</span></a>
                                    <a href="${pageContext.request.contextPath}/LogoutServlet" class="logout-link"><span>Esci</span> <span>🚪</span></a>
                                </div>
                            </div>
                        </li>
                        
                        <%-- Switch dinamico Carrello / Home per utente loggato --%>
                        <% if (!isCarrelloPage) { %>
                            <li>
                                <a href="${pageContext.request.contextPath}/CarrelloServlet" class="cart-nav-link">
                                    Il mio Carrello 🛒
                                    <% if (numeroArticoli > 0) { %><span class="cart-badge"><%= numeroArticoli %></span><% } %>
                                </a>
                            </li>
                        <% } else { %>
                            <li>
                                <a href="${pageContext.request.contextPath}/" class="cart-nav-link">
                                    Torna alla Home 🏠
                                </a>
                            </li>
                        <% } %>

            <% 
                    } else { 
                        // --------- GESTIONE HEADER PER L'ADMIN ---------
                        if (isAdminPage) { 
            %>
                            <li style="color: #ffcc00; font-weight: bold; padding: 10px 15px;">
                                Admin: <%= utenteLoggatoHeader.getNome() %> <%= utenteLoggatoHeader.getCognome() %>
                            </li>
            <% 
                        } else { 
            %>
                            <li><a href="${pageContext.request.contextPath}/AdminServlet" style="color: #4CAF50; font-weight: bold;">Pannello Admin 🛠️</a></li>
            <% 
                        } 
            %>
                        <li><a href="${pageContext.request.contextPath}/" style="font-weight: bold;">Home 🏠</a></li>
                        <li><a href="${pageContext.request.contextPath}/LogoutServlet" style="color: #ff4d4d; font-weight: bold;">Esci 🚪</a></li>
            <% 
                    }
                } else { 
            %>
                    <%-- Switch dinamico Carrello / Home per ospite (non loggato) --%>
                    <% if (!isCarrelloPage) { %>
                        <li>
                            <a href="${pageContext.request.contextPath}/CarrelloServlet" class="cart-nav-link">
                                Il mio Carrello 🛒
                                <% if (numeroArticoli > 0) { %><span class="cart-badge"><%= numeroArticoli %></span><% } %>
                            </a>
                        </li>
                    <% } else { %>
                        <li>
                            <a href="${pageContext.request.contextPath}/" class="cart-nav-link">
                                Torna alla Home 🏠
                            </a>
                        </li>
                    <% } %>

                    <li><a href="${pageContext.request.contextPath}/LoginServlet" style="font-weight: bold;">Accedi</a></li>
                    <li><a href="${pageContext.request.contextPath}/RegistrazioneServlet" style="font-weight: bold;">Registrati</a></li>
            <% 
                } 
            %>
        </ul>
    </nav>
</header>

<script>
    function openSidebar() {
        document.getElementById("sidebarMenu").classList.add("open");
        document.getElementById("menuOverlay").classList.add("show");
    }
    function closeSidebar() {
        document.getElementById("sidebarMenu").classList.remove("open");
        document.getElementById("menuOverlay").classList.remove("show");
    }
</script>