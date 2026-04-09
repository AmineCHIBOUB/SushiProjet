<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="metier.Commande" %>
<jsp:useBean id="commandes" class="java.util.HashMap" scope="request"></jsp:useBean>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes Commandes - SushiApp</title>
    <!-- Bootstrap 5.1.3 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
    <!-- CSS personnalise -->
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
                data-bs-toggle="collapse" data-bs-target="#navMenu"
                aria-controls="navMenu" aria-expanded="false" aria-label="Menu">
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
                    <a class="nav-link" href="${pageContext.request.contextPath}/reservations?action=formulaire">Réserver</a>
                </li>
                <li class="nav-item">
                    <!-- lien actif sur cette page -->
                    <a class="nav-link active" href="${pageContext.request.contextPath}/commandes?action=liste">Mes Commandes</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- ===== EN-TETE DE PAGE ===== -->
<div class="page-header">
    <div class="container">
        <p class="section-subtitle">Historique</p>
        <!-- titre change si on filtre par client -->
        <c:choose>
            <c:when test="${not empty clientFiltre}">
                <h1 class="section-title">COMMANDES DE <c:out value="${clientFiltre}"/></h1>
            </c:when>
            <c:otherwise>
                <h1 class="section-title">TOUTES LES COMMANDES</h1>
            </c:otherwise>
        </c:choose>
        <div class="section-divider mx-auto"></div>
    </div>
</div>

<!-- ===== LISTE DES COMMANDES ===== -->
<section class="commandes-section">
    <div class="container">

        <!-- barre d outils : recherche par client + bouton nouvelle commande -->
        <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
            <!-- formulaire de filtre par nom de client -->
            <form action="${pageContext.request.contextPath}/commandes" method="get"
                  class="d-flex gap-2" style="flex:1;max-width:400px;">
                <input type="hidden" name="action" value="liste">
                <input type="text"
                       class="form-control"
                       name="client"
                       placeholder="Filtrer par nom de client..."
                       value="<c:out value='${clientFiltre}'/>">
                <button type="submit" class="btn-gold-outline" style="white-space:nowrap;padding:0.6rem 1.2rem;">
                    Rechercher
                </button>
            </form>

            <!-- bouton pour passer une nouvelle commande -->
            <a href="${pageContext.request.contextPath}/sushis?action=commander" class="btn-gold">
                + Nouvelle commande
            </a>
        </div>

        <!-- tableau des commandes -->
        <c:choose>
            <c:when test="${not empty commandes}">
                <div style="overflow-x:auto;">
                    <table class="table table-dark-custom">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Client</th>
                                <th>Adresse</th>
                                <th>Livraison</th>
                                <th>Articles</th>
                                <th>Total</th>
                                <th>Statut</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%-- boucle sur toutes les commandes --%>
                            <c:forEach var="c" items="${commandes}">
                                <tr>
                                    <!-- id de la commande -->
                                    <td><strong>#<c:out value="${c.value.id}"/></strong></td>

                                    <!-- nom du client -->
                                    <td><strong><c:out value="${c.value.client}"/></strong></td>

                                    <!-- adresse (tronquee si trop longue) -->
                                    <td>
                                        <span title="<c:out value='${c.value.adresse}'/>">
                                            <c:out value="${c.value.adresse}"/>
                                        </span>
                                    </td>

                                    <!-- mode de livraison -->
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty c.value.livraison}">
                                                <c:out value="${c.value.livraison.nom}"/>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color:var(--muted2);">-</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <!-- nombre d articles dans la commande -->
                                    <td>
                                        <c:out value="${c.value.lignes.size()}"/> article(s)
                                    </td>

                                    <!-- total de la commande en or -->
                                    <td class="text-gold fw-bold">
                                        <c:out value="${c.value.total}"/> €
                                    </td>

                                    <!-- badge de statut colore -->
                                    <td>
                                        <c:choose>
                                            <c:when test="${c.value.statut == 'en attente'}">
                                                <span class="badge-statut badge-attente"><c:out value="${c.value.statut}"/></span>
                                            </c:when>
                                            <c:when test="${c.value.statut == 'en preparation'}">
                                                <span class="badge-statut badge-prepare"><c:out value="${c.value.statut}"/></span>
                                            </c:when>
                                            <c:when test="${c.value.statut == 'livre'}">
                                                <span class="badge-statut badge-livre"><c:out value="${c.value.statut}"/></span>
                                            </c:when>
                                            <c:when test="${c.value.statut == 'annule'}">
                                                <span class="badge-statut badge-annule"><c:out value="${c.value.statut}"/></span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-statut badge-attente"><c:out value="${c.value.statut}"/></span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <!-- lien vers le detail de la commande -->
                                    <td>
                                        <a href="${pageContext.request.contextPath}/commandes?action=detail&id=<c:out value='${c.value.id}'/>"
                                           class="btn-gold-outline"
                                           style="padding:0.4rem 1rem;font-size:0.75rem;">
                                            Voir le detail
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- compteur de resultats -->
                <p style="color:var(--muted2);font-size:0.8rem;margin-top:1rem;letter-spacing:1px;">
                    <c:out value="${commandes.size()}"/> commande(s) affichee(s)
                </p>
            </c:when>

            <c:otherwise>
                <!-- message quand il n y a aucune commande -->
                <div class="alert-dark-custom">
                    <p style="margin-bottom:1rem;">Aucune commande pour le moment.</p>
                    <a href="${pageContext.request.contextPath}/sushis?action=commander" class="btn-gold">
                        Passer ma premiere commande
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</section>

<!-- ===== FOOTER ===== -->
<footer class="sushi-footer">
    <div class="container">
        <div class="footer-brand">SUSHIAPP</div>
        <div class="footer-divider"></div>
        <p class="footer-copy">
            &copy; <%= new java.util.Date().getYear() + 1900 %> SushiApp &mdash; Tous droits r&eacute;serv&eacute;s.
        </p>
    </div>
</footer>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
