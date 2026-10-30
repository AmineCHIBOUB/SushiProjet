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
    <title>Commander - SushiApp</title>
    <!-- Bootstrap 5.1.3 CDN -->
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
                    <!-- lien actif sur cette page -->
                    <a class="nav-link active" href="${pageContext.request.contextPath}/sushis?action=commander">Commander</a>
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

<!-- ===== EN-TETE DE PAGE ===== -->
<div class="page-header">
    <div class="container">
        <p class="section-subtitle">Composez votre repas</p>
        <h1 class="section-title">PASSER UNE COMMANDE</h1>
        <div class="section-divider mx-auto"></div>
    </div>
</div>

<!-- ===== FORMULAIRE DE COMMANDE ===== -->
<section class="commande-section">
    <div class="container">
        <!--
            Formulaire principal : action vers CommandeServlet en POST
            le champ hidden "action" vaut "passer" pour identifier le traitement
        -->
        <%-- message si une quantite demandee depasse le stock disponible --%>
        <c:if test="${param.erreur == 'stock'}">
            <div class="alert alert-danger mb-4">
                Stock insuffisant pour « <c:out value="${param.plat}"/> ».
                Merci d'ajuster la quantité.
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/commandes" method="post" id="formCommande">
            <!-- champ cache pour indiquer l action au servlet -->
            <input type="hidden" name="action" value="passer">

            <div class="row g-4">

                <!-- ===== COLONNE GAUCHE : le formulaire ===== -->
                <div class="col-12 col-md-7">

                    <!-- bloc infos client -->
                    <div class="detail-card mb-4">
                        <h3 class="text-gold mb-4" style="font-size:0.85rem;letter-spacing:3px;text-transform:uppercase;font-weight:600;">
                            Vos informations
                        </h3>

                        <!-- nom du client -->
                        <div class="mb-3">
                            <label for="client" class="form-label">Nom du client</label>
                            <input type="text"
                                   class="form-control"
                                   id="client"
                                   name="client"
                                   placeholder="Votre nom complet"
                                   required>
                        </div>

                        <!-- adresse de livraison -->
                        <div class="mb-3">
                            <label for="adresse" class="form-label">Adresse de livraison</label>
                            <input type="text"
                                   class="form-control"
                                   id="adresse"
                                   name="adresse"
                                   placeholder="Votre adresse (si livraison a domicile)">
                        </div>
                    </div>

                    <!-- bloc selection du mode de livraison -->
                    <div class="detail-card mb-4">
                        <h3 class="text-gold mb-4" style="font-size:0.85rem;letter-spacing:3px;text-transform:uppercase;font-weight:600;">
                            Mode de livraison
                        </h3>

                        <%-- on boucle sur les modes de livraison disponibles --%>
                        <c:forEach var="l" items="${livraisons}">
                            <div class="form-check mb-3 p-3" style="background:var(--bg4);border:1px solid var(--border);">
                                <input class="form-check-input"
                                       type="radio"
                                       name="livraison"
                                       id="liv_<c:out value='${l.value.id}'/>"
                                       value="<c:out value='${l.value.id}'/>"
                                       required>
                                <label class="form-check-label d-flex justify-content-between"
                                       for="liv_<c:out value='${l.value.id}'/>">
                                    <span><c:out value="${l.value.nom}"/>
                                          <small style="color:var(--muted);margin-left:0.5rem;">
                                              (<c:out value="${l.value.type}"/>)
                                          </small>
                                    </span>
                                    <span class="text-gold fw-bold">
                                        <c:choose>
                                            <c:when test="${l.value.tarif == 0}">Gratuit</c:when>
                                            <c:otherwise>+<c:out value="${l.value.tarif}"/> €</c:otherwise>
                                        </c:choose>
                                    </span>
                                </label>
                            </div>
                        </c:forEach>

                        <%-- si aucun mode de livraison n est configure --%>
                        <c:if test="${empty livraisons}">
                            <p style="color:var(--muted);">Aucun mode de livraison disponible.</p>
                        </c:if>
                    </div>

                    <!-- bloc selection des sushis avec quantites -->
                    <div class="detail-card mb-4">
                        <h3 class="text-gold mb-4" style="font-size:0.85rem;letter-spacing:3px;text-transform:uppercase;font-weight:600;">
                            Choisissez vos sushis
                        </h3>

                        <%-- boucle sur tous les sushis du menu --%>
                        <c:forEach var="s" items="${sushis}">
                            <div class="sushi-order-item">
                                <!-- miniature du sushi -->
                                <c:choose>
                                    <c:when test="${not empty s.value.image}">
                                        <img src="<c:out value='${s.value.image}'/>"
                                             alt="<c:out value='${s.value.nom}'/>">
                                    </c:when>
                                    <c:otherwise>
                                        <!-- image par defaut si non definie -->
                                        <img src="https://images.unsplash.com/photo-1617196034183-421b4040ed20?w=70&h=70&fit=crop"
                                             alt="<c:out value='${s.value.nom}'/>">
                                    </c:otherwise>
                                </c:choose>

                                <!-- infos du sushi -->
                                <div class="sushi-info">
                                    <div class="nom"><c:out value="${s.value.nom}"/></div>
                                    <div class="prix"><c:out value="${s.value.prix}"/> €</div>
                                    <small style="color:var(--muted2);font-size:0.75rem;">
                                        <c:out value="${s.value.categorie}"/>
                                    </small>
                                    <%-- disponibilite selon le stock --%>
                                    <c:if test="${s.value.enRupture}">
                                        <span class="badge bg-danger ms-2">Rupture</span>
                                    </c:if>
                                    <c:if test="${s.value.stockBas}">
                                        <span class="badge bg-warning text-dark ms-2">Plus que <c:out value="${s.value.stock}"/></span>
                                    </c:if>
                                </div>

                                <!-- input quantite : nom = "qte_<idSushi>" pour le servlet -->
                                <input type="number"
                                       class="form-control qte-input"
                                       name="qte_<c:out value='${s.value.id}'/>"
                                       value="0"
                                       min="0"
                                       max="<c:out value='${s.value.stock < 99 ? s.value.stock : 99}'/>"
                                       <c:if test="${s.value.enRupture}">disabled</c:if>
                                       title="Quantite de <c:out value='${s.value.nom}'/>">
                            </div>
                        </c:forEach>

                        <c:if test="${empty sushis}">
                            <div class="alert-dark-custom">Menu indisponible pour le moment.</div>
                        </c:if>
                    </div>

                    <!-- bouton de validation -->
                    <button type="submit" class="btn-gold w-100 py-3" style="font-size:1rem;">
                        Confirmer la commande
                    </button>
                </div>

                <!-- ===== COLONNE DROITE : resume de commande ===== -->
                <div class="col-12 col-md-5">
                    <div class="order-summary">
                        <h4>Résumé de la commande</h4>

                        <!-- infos statiques de la commande en cours -->
                        <div class="info-ligne">
                            <span>Restaurant</span>
                            <span>SushiApp Paris</span>
                        </div>
                        <div class="info-ligne">
                            <span>Horaires</span>
                            <span>11h - 23h</span>
                        </div>
                        <div class="info-ligne">
                            <span>Delai estimé</span>
                            <span>20 - 35 min</span>
                        </div>
                        <div class="info-ligne">
                            <span>Statut</span>
                            <span class="badge-statut badge-attente">En attente</span>
                        </div>

                        <hr style="border-color:var(--border);margin:1.5rem 0;">

                        <!-- rappel des modes de livraison disponibles -->
                        <p style="color:var(--muted);font-size:0.8rem;letter-spacing:1px;text-transform:uppercase;margin-bottom:1rem;">
                            Modes disponibles
                        </p>
                        <c:forEach var="l" items="${livraisons}">
                            <div class="info-ligne">
                                <span><c:out value="${l.value.nom}"/></span>
                                <span class="text-gold">
                                    <c:choose>
                                        <c:when test="${l.value.tarif == 0}">Gratuit</c:when>
                                        <c:otherwise><c:out value="${l.value.tarif}"/> €</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </c:forEach>

                        <hr style="border-color:var(--border);margin:1.5rem 0;">

                        <!-- informations supplementaires -->
                        <p style="color:var(--muted2);font-size:0.8rem;line-height:1.6;">
                            Selectionnez vos sushis et indiquez les quantites souhaitees.
                            Le total sera calcule apres confirmation.
                        </p>
                    </div>
                </div>
            </div>
        </form>
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

<script>
    // validation basique avant envoi : on verifie qu au moins un sushi est selectionne
    document.getElementById('formCommande').addEventListener('submit', function(e) {
        var inputs = document.querySelectorAll('input[name^="qte_"]');
        var total  = 0;
        inputs.forEach(function(inp) {
            total += parseInt(inp.value) || 0;
        });
        if (total === 0) {
            e.preventDefault();
            alert('Veuillez choisir au moins un sushi avant de confirmer.');
        }
    });
</script>

</body>
</html>
