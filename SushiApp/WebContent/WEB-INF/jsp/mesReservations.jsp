<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="metier.Reservation" %>
<jsp:useBean id="reservations" class="java.util.HashMap" scope="request"></jsp:useBean>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes Reservations - SushiApp</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

<!-- ===== NAVBAR ===== -->
<nav class="navbar navbar-expand-lg sushi-navbar">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/sushis?action=menu">
            SUSHI<span>APP</span>
        </a>
        <button class="navbar-toggler" type="button"
                data-bs-toggle="collapse" data-bs-target="#navMenu">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navMenu">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/sushis?action=menu">Menu</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/sushis?action=commander">Commander</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/reservations?action=formulaire">Réserver</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/commandes?action=liste">Mes Commandes</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- ===== SECTION LISTE DES RESERVATIONS ===== -->
<section class="reservation-section">
    <div class="container" style="padding-top:60px; padding-bottom:60px;">

        <div class="text-center mb-5">
            <h2 class="section-title">MES RESERVATIONS</h2>
            <div class="section-divider mx-auto"></div>
        </div>

        <!-- formulaire de recherche par nom -->
        <div class="row justify-content-center mb-4">
            <div class="col-md-6">
                <form action="reservations" method="get" class="d-flex">
                    <input type="hidden" name="action" value="liste">
                    <input type="text" class="form-input-dark flex-grow-1 me-2" name="client"
                           placeholder="Rechercher par nom..." value="${clientFiltre}">
                    <button type="submit" class="btn-gold">Rechercher</button>
                </form>
            </div>
        </div>

        <%-- affichage des reservations si il y en a --%>
        <c:choose>
            <c:when test="${not empty reservations}">
                <div class="row g-4 justify-content-center">
                    <%-- on boucle sur les reservations --%>
                    <c:forEach var="r" items="${reservations}">
                        <div class="col-md-6 col-lg-4">
                            <div class="reservation-card-mini">
                                <!-- date et heure en haut -->
                                <div class="resa-date">
                                    <c:out value="${r.value.date}"/> a <c:out value="${r.value.heure}"/>
                                </div>
                                <!-- nom du client -->
                                <div class="resa-client">
                                    <c:out value="${r.value.client}"/>
                                </div>
                                <!-- details -->
                                <div class="resa-details">
                                    <c:out value="${r.value.nbPersonnes}"/> personne(s)
                                    &bull; Tel: <c:out value="${r.value.telephone}"/>
                                </div>
                                <!-- statut avec couleur -->
                                <div class="resa-statut">
                                    <span class="badge-statut badge-<c:out value='${r.value.statut == "en attente" ? "attente" : "confirme"}'/>">
                                        <c:out value="${r.value.statut}"/>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center" style="color: var(--muted); padding: 40px;">
                    Aucune reservation trouvee.
                </div>
            </c:otherwise>
        </c:choose>

        <!-- lien pour faire une nouvelle reservation -->
        <div class="text-center mt-4">
            <a href="reservations?action=formulaire" class="btn-gold-outline">
                Nouvelle reservation
            </a>
        </div>

    </div>
</section>

<!-- ===== FOOTER ===== -->
<footer class="sushi-footer">
    <div class="container">
        <div class="footer-brand">SUSHIAPP</div>
        <div class="footer-divider"></div>
        <p class="footer-copy">
            &copy; <%= new java.util.Date().getYear() + 1900 %> SushiApp &mdash; Restaurant Japonais Authentique, Bordeaux.
        </p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
