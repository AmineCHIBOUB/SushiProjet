<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="metier.Sushi, metier.Livraison" %>
<jsp:useBean id="sushis" class="java.util.HashMap" scope="request"></jsp:useBean>
<jsp:useBean id="livraisons" class="java.util.HashMap" scope="request"></jsp:useBean>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SushiApp - Restaurant Japonais Authentique</title>
    <!-- Bootstrap 5.1.3 CDN -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
    <!-- Notre feuille de style personnalisee -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

<!-- ===== NAVBAR ===== -->
<nav class="navbar navbar-expand-lg sushi-navbar">
    <div class="container">
        <!-- logo du restaurant -->
        <a class="navbar-brand" href="${pageContext.request.contextPath}/sushis?action=menu">
            SUSHI<span>APP</span>
        </a>

        <!-- bouton hamburger pour mobile -->
        <button class="navbar-toggler" type="button"
                data-bs-toggle="collapse" data-bs-target="#navMenu"
                aria-controls="navMenu" aria-expanded="false" aria-label="Menu">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- liens de navigation -->
        <div class="collapse navbar-collapse" id="navMenu">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/sushis?action=menu">Menu</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/sushis?action=commander">Commander</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/reservations?action=formulaire">Réserver</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/commandes?action=liste">Mes Commandes</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- ===== HERO SECTION ===== -->
<section class="hero-section">
    <div class="hero-content">
        <!-- etiquette en haut du hero -->
        <div class="hero-tag">Restaurant Japonais · Bordeaux</div>

        <!-- grand titre principal -->
        <h1 class="hero-title">
            SUSHI<br><span class="gold-word">APP</span>
        </h1>

        <!-- ligne decorative or -->
        <div class="hero-divider"></div>

        <!-- sous-titre -->
        <p class="hero-subtitle">Restaurant Japonais Authentique</p>

        <!-- bouton d action principal -->
        <a href="#menu" class="btn-gold">Voir le menu</a>
        &nbsp;&nbsp;
        <a href="${pageContext.request.contextPath}/sushis?action=commander" class="btn-gold-outline mt-2">
            Commander
        </a>
    </div>
</section>

<!-- ===== SECTION MENU - NOS CREATIONS ===== -->
<section class="menu-section" id="menu">
    <div class="container">
        <!-- titre de la section -->
        <div class="text-center mb-5">
            <p class="section-subtitle">Sélection du chef</p>
            <h2 class="section-title">NOS CRÉATIONS</h2>
            <div class="section-divider mx-auto"></div>
        </div>

        <!-- FONCTIONNALITE INNOVANTE : filtres par categorie -->
        <!-- le client peut cliquer sur une categorie pour filtrer le menu -->
        <div class="text-center mb-4">
            <button class="btn-filtre active" onclick="filtrerMenu('tous')">Tous</button>
            <button class="btn-filtre" onclick="filtrerMenu('nigiri')">Nigiri</button>
            <button class="btn-filtre" onclick="filtrerMenu('maki')">Maki</button>
            <button class="btn-filtre" onclick="filtrerMenu('sashimi')">Sashimi</button>
            <button class="btn-filtre" onclick="filtrerMenu('accompagnement')">Accompagnement</button>
            <button class="btn-filtre" onclick="filtrerMenu('plateau')">Plateau</button>
            <button class="btn-filtre" onclick="filtrerMenu('dessert')">Dessert</button>
        </div>

        <!-- grille des cartes sushis : 3 colonnes sur desktop -->
        <div class="row g-4">
            <%-- on boucle sur tous les sushis disponibles --%>
            <c:forEach var="s" items="${sushis}">
                <div class="col-12 col-md-6 col-lg-4 sushi-item" data-categorie="<c:out value='${s.value.categorie}'/>">
                    <div class="sushi-card">
                        <!-- image du sushi avec la categorie par dessus -->
                        <div class="card-img-wrap">
                            <c:choose>
                                <c:when test="${not empty s.value.image}">
                                    <%-- on affiche l image du sushi si elle existe --%>
                                    <img src="<c:out value='${s.value.image}'/>" alt="<c:out value='${s.value.nom}'/>">
                                </c:when>
                                <c:otherwise>
                                    <%-- image par defaut si aucune image n est definie --%>
                                    <img src="https://images.unsplash.com/photo-1617196034183-421b4040ed20?w=400&h=200&fit=crop"
                                         alt="<c:out value='${s.value.nom}'/>">
                                </c:otherwise>
                            </c:choose>
                            <!-- tag de categorie positionne sur l image -->
                            <span class="category-tag"><c:out value="${s.value.categorie}"/></span>
                        </div>

                        <!-- corps de la carte -->
                        <div class="card-body">
                            <h3 class="card-title"><c:out value="${s.value.nom}"/></h3>
                            <p class="card-desc"><c:out value="${s.value.description}"/></p>

                            <!-- prix en or -->
                            <div class="price">
                                <c:out value="${s.value.prix}"/> €
                            </div>

                            <!-- bouton pour passer a la commande -->
                            <a href="${pageContext.request.contextPath}/sushis?action=commander"
                               class="btn-gold-outline w-100 text-center">
                                Commander
                            </a>
                        </div>
                    </div>
                </div>
            </c:forEach>

            <%-- message si aucun sushi n est disponible --%>
            <c:if test="${empty sushis}">
                <div class="col-12">
                    <div class="alert-dark-custom">
                        Le menu est en cours de mise a jour. Revenez bientot.
                    </div>
                </div>
            </c:if>
        </div>
    </div>
</section>

<!-- ===== SECTION LIVRAISON ===== -->
<section class="livraison-section" id="livraison">
    <div class="container">
        <!-- titre de la section livraison -->
        <div class="text-center mb-5">
            <p class="section-subtitle">Nos modes de service</p>
            <h2 class="section-title">LIVRAISON</h2>
            <div class="section-divider mx-auto"></div>
        </div>

        <!-- cartes des modes de livraison -->
        <div class="row g-4 justify-content-center">
            <%-- on boucle sur tous les modes de livraison --%>
            <c:forEach var="l" items="${livraisons}">
                <div class="col-12 col-md-4">
                    <div class="livraison-card">
                        <!-- icone selon le type de livraison -->
                        <div class="liv-icon">
                            <c:choose>
                                <c:when test="${l.value.type == 'surplace'}">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" fill="currentColor" viewBox="0 0 16 16"><path d="M8.5 1a.5.5 0 0 0-1 0v1H6a2 2 0 0 0-2 2v1h8V4a2 2 0 0 0-2-2H8.5V1zM3 6v6.5A2.5 2.5 0 0 0 5.5 15h5a2.5 2.5 0 0 0 2.5-2.5V6H3z"/></svg>
                                </c:when>
                                <c:when test="${l.value.type == 'emporte'}">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" fill="currentColor" viewBox="0 0 16 16"><path d="M5.757 1.071a.5.5 0 0 1 .172.686L3.383 6h9.234L10.07 1.757a.5.5 0 1 1 .858-.514L13.783 6H15a1 1 0 0 1 1 1v1a1 1 0 0 1-1 1h-.396a2 2 0 0 1-1.735 1.5L12 14.5a.5.5 0 0 1-.5.5h-7a.5.5 0 0 1-.5-.5L3.131 10.5A2 2 0 0 1 1.396 9H1a1 1 0 0 1-1-1V7a1 1 0 0 1 1-1h1.217L5.07 1.243a.5.5 0 0 1 .686-.172z"/></svg>
                                </c:when>
                                <c:otherwise>
                                    <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" fill="currentColor" viewBox="0 0 16 16"><path d="M0 3.5A1.5 1.5 0 0 1 1.5 2h9A1.5 1.5 0 0 1 12 3.5V5h1.02a1.5 1.5 0 0 1 1.17.563l1.481 1.85a1.5 1.5 0 0 1 .329.938V10.5a1.5 1.5 0 0 1-1.5 1.5H14a2 2 0 1 1-4 0H6a2 2 0 1 1-4 0h-.5A1.5 1.5 0 0 1 0 10.5V3.5zM4 12a1 1 0 1 0 0-2 1 1 0 0 0 0 2zm8 0a1 1 0 1 0 0-2 1 1 0 0 0 0 2z"/></svg>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="liv-nom"><c:out value="${l.value.nom}"/></div>

                        <!-- tarif : gratuit si 0.0, sinon on affiche le prix -->
                        <div class="liv-tarif">
                            <c:choose>
                                <c:when test="${l.value.tarif == 0}">Gratuit</c:when>
                                <c:otherwise><c:out value="${l.value.tarif}"/> €</c:otherwise>
                            </c:choose>
                        </div>

                        <div class="liv-type"><c:out value="${l.value.type}"/></div>
                    </div>
                </div>
            </c:forEach>

            <%-- message si aucun mode de livraison n est configure --%>
            <c:if test="${empty livraisons}">
                <div class="col-12 text-center">
                    <p style="color: var(--muted);">Modes de livraison disponibles prochainement.</p>
                </div>
            </c:if>
        </div>
    </div>
</section>

<!-- ===== FOOTER ===== -->
<footer class="sushi-footer">
    <div class="container">
        <div class="footer-brand">SUSHIAPP</div>
        <div class="footer-divider"></div>
        <p class="footer-copy">
            &copy; <%= new java.util.Date().getYear() + 1900 %> SushiApp &mdash; Restaurant Japonais Authentique.
            Tous droits r&eacute;serv&eacute;s.
        </p>
    </div>
</footer>

<!-- Bootstrap JS bundle (inclut Popper) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // scroll fluide vers l ancre #menu quand on clique sur "Voir le menu"
    document.querySelectorAll('a[href^="#"]').forEach(function(anchor) {
        anchor.addEventListener('click', function(e) {
            var target = document.querySelector(this.getAttribute('href'));
            if (target) {
                e.preventDefault();
                target.scrollIntoView({ behavior: 'smooth', block: 'start' });
            }
        });
    });

    // fonction de filtre par categorie (fonctionnalite innovante)
    // cache ou affiche les cartes sushi selon la categorie selectionnee
    function filtrerMenu(categorie) {
        // on recupere toutes les cartes sushi
        var items = document.querySelectorAll('.sushi-item');
        for (var i = 0; i < items.length; i++) {
            if (categorie === 'tous' || items[i].getAttribute('data-categorie') === categorie) {
                items[i].style.display = '';
            } else {
                items[i].style.display = 'none';
            }
        }
        // on met a jour le bouton actif
        var boutons = document.querySelectorAll('.btn-filtre');
        for (var j = 0; j < boutons.length; j++) {
            boutons[j].classList.remove('active');
        }
        event.target.classList.add('active');
    }
</script>

</body>
</html>
