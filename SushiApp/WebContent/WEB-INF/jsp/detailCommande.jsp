<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="metier.Commande, metier.CommandeLigne" %>
<jsp:useBean id="commande" class="metier.Commande" scope="request"></jsp:useBean>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detail Commande - SushiApp</title>
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
                    <a class="nav-link active" href="${pageContext.request.contextPath}/commandes?action=liste">Mes Commandes</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- ===== CONTENU PRINCIPAL ===== -->
<section class="commandes-section">
    <div class="container">

        <!-- on verifie que la commande existe bien -->
        <c:choose>
            <c:when test="${not empty commande}">

                <!-- en-tete avec numero de commande et bouton retour -->
                <div class="d-flex justify-content-between align-items-center mb-5 flex-wrap gap-3">
                    <div>
                        <p class="section-subtitle">Detail de la commande</p>
                        <h1 class="section-title">COMMANDE #<c:out value="${commande.id}"/></h1>
                    </div>
                    <!-- facture et retour vers la liste -->
                    <div class="d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/commandes?action=facture&id=<c:out value='${commande.id}'/>"
                           class="btn-gold">
                            Facture
                        </a>
                        <a href="${pageContext.request.contextPath}/commandes?action=liste"
                           class="btn-gold-outline">
                            &larr; Retour aux commandes
                        </a>
                    </div>
                </div>

                <div class="row g-4">

                    <!-- ===== COLONNE GAUCHE : infos de la commande ===== -->
                    <div class="col-12 col-lg-5">

                        <!-- bloc informations client -->
                        <div class="detail-card mb-4">
                            <h3 class="text-gold mb-4"
                                style="font-size:0.8rem;letter-spacing:3px;text-transform:uppercase;font-weight:600;">
                                Informations client
                            </h3>

                            <!-- nom du client -->
                            <div class="mb-3">
                                <div class="detail-label">Client</div>
                                <div class="detail-value"><c:out value="${commande.client}"/></div>
                            </div>

                            <!-- adresse de livraison -->
                            <div class="mb-3">
                                <div class="detail-label">Adresse</div>
                                <div class="detail-value">
                                    <c:choose>
                                        <c:when test="${not empty commande.adresse}">
                                            <c:out value="${commande.adresse}"/>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color:var(--muted);">Non renseignee</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <!-- statut de la commande -->
                            <div class="mb-3">
                                <div class="detail-label">Statut</div>
                                <div class="detail-value" style="margin-top:0.3rem;">
                                    <c:choose>
                                        <c:when test="${commande.statut == 'en attente'}">
                                            <span class="badge-statut badge-attente"><c:out value="${commande.statut}"/></span>
                                        </c:when>
                                        <c:when test="${commande.statut == 'en preparation'}">
                                            <span class="badge-statut badge-prepare"><c:out value="${commande.statut}"/></span>
                                        </c:when>
                                        <c:when test="${commande.statut == 'livre'}">
                                            <span class="badge-statut badge-livre"><c:out value="${commande.statut}"/></span>
                                        </c:when>
                                        <c:when test="${commande.statut == 'annule'}">
                                            <span class="badge-statut badge-annule"><c:out value="${commande.statut}"/></span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-statut badge-attente"><c:out value="${commande.statut}"/></span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <!-- bloc mode de livraison -->
                        <div class="detail-card mb-4">
                            <h3 class="text-gold mb-4"
                                style="font-size:0.8rem;letter-spacing:3px;text-transform:uppercase;font-weight:600;">
                                Mode de livraison
                            </h3>

                            <c:choose>
                                <c:when test="${not empty commande.livraison}">
                                    <div class="mb-2">
                                        <div class="detail-label">Nom</div>
                                        <div class="detail-value"><c:out value="${commande.livraison.nom}"/></div>
                                    </div>
                                    <div class="mb-2">
                                        <div class="detail-label">Type</div>
                                        <div class="detail-value"><c:out value="${commande.livraison.type}"/></div>
                                    </div>
                                    <div>
                                        <div class="detail-label">Frais de livraison</div>
                                        <div class="detail-value text-gold fw-bold">
                                            <c:choose>
                                                <c:when test="${commande.livraison.tarif == 0}">Gratuit</c:when>
                                                <c:otherwise><c:out value="${commande.livraison.tarif}"/> €</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <p style="color:var(--muted);">Aucun mode de livraison associe.</p>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- total de la commande mis en valeur -->
                        <div class="total-line">
                            <span class="label">Total commande</span>
                            <span class="montant"><c:out value="${commande.total}"/> €</span>
                        </div>
                    </div>

                    <!-- ===== COLONNE DROITE : articles commandes ===== -->
                    <div class="col-12 col-lg-7">
                        <div class="detail-card">
                            <h3 class="text-gold mb-4"
                                style="font-size:0.8rem;letter-spacing:3px;text-transform:uppercase;font-weight:600;">
                                Articles commandes (<c:out value="${commande.lignes.size()}"/>)
                            </h3>

                            <!-- tableau des articles -->
                            <c:choose>
                                <c:when test="${not empty commande.lignes}">
                                    <table class="table table-dark-custom">
                                        <thead>
                                            <tr>
                                                <th>Photo</th>
                                                <th>Sushi</th>
                                                <th>Prix unitaire</th>
                                                <th>Qte</th>
                                                <th>Sous-total</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%-- boucle sur les lignes de la commande --%>
                                            <c:forEach var="ligne" items="${commande.lignes}">
                                                <tr>
                                                    <!-- miniature du sushi -->
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty ligne.sushi.image}">
                                                                <img src="<c:out value='${ligne.sushi.image}'/>"
                                                                     alt="<c:out value='${ligne.sushi.nom}'/>"
                                                                     class="detail-sushi-img">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <!-- image par defaut -->
                                                                <img src="https://images.unsplash.com/photo-1617196034183-421b4040ed20?w=60&h=60&fit=crop"
                                                                     alt="<c:out value='${ligne.sushi.nom}'/>"
                                                                     class="detail-sushi-img">
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>

                                                    <!-- nom et categorie du sushi -->
                                                    <td>
                                                        <strong><c:out value="${ligne.sushi.nom}"/></strong>
                                                        <br>
                                                        <small style="color:var(--muted2);">
                                                            <c:out value="${ligne.sushi.categorie}"/>
                                                        </small>
                                                    </td>

                                                    <!-- prix unitaire -->
                                                    <td><c:out value="${ligne.sushi.prix}"/> €</td>

                                                    <!-- quantite commandee -->
                                                    <td>
                                                        <strong>x<c:out value="${ligne.quantite}"/></strong>
                                                    </td>

                                                    <!-- sous-total de la ligne en or -->
                                                    <td class="text-gold fw-bold">
                                                        <c:out value="${ligne.sousTotal}"/> €
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>

                                    <!-- ligne de total recapitulative -->
                                    <div class="total-line mt-0">
                                        <span class="label">Total (livraison incluse)</span>
                                        <span class="montant"><c:out value="${commande.total}"/> €</span>
                                    </div>
                                </c:when>

                                <c:otherwise>
                                    <!-- si la commande est vide (ne devrait pas arriver) -->
                                    <div class="alert-dark-custom">
                                        Aucun article dans cette commande.
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

            </c:when>

            <c:otherwise>
                <!-- commande introuvable (mauvais id dans l url) -->
                <div class="text-center py-5">
                    <h2 class="section-title mb-4">Commande introuvable</h2>
                    <p style="color:var(--muted);margin-bottom:2rem;">
                        La commande demandee n existe pas ou a ete supprimee.
                    </p>
                    <a href="${pageContext.request.contextPath}/commandes?action=liste" class="btn-gold">
                        Retour aux commandes
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
