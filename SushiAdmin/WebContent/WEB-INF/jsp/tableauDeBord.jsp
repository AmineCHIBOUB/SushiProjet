<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="fr_FR"/>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SushiAdmin - Tableau de bord</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
    <link rel="stylesheet" href="assets/css/style.css">
    <style>
        .kpi { border: 1px solid var(--border); background: var(--bg); padding: 1.25rem; height: 100%; }
        .kpi-label { color: var(--muted); font-size: 0.75rem; letter-spacing: 2px; text-transform: uppercase; }
        .kpi-value { color: var(--gold); font-size: 2rem; font-weight: 700; }
        .kpi-sub { color: var(--muted); font-size: 0.85rem; }
        .bar { height: 8px; background: var(--gold); }
    </style>
</head>
<body>

<!-- Barre de navigation principale -->
<nav class="navbar navbar-dark bg-dark">
  <div class="container-fluid">
    <a class="navbar-brand" href="sushis">SushiAdmin</a>
    <div>
      <a href="tableau-de-bord" class="btn btn-warning btn-sm me-2">TABLEAU DE BORD</a>
      <a href="sushis" class="btn btn-outline-light btn-sm me-2">SUSHIS</a>
      <a href="stocks" class="btn btn-outline-light btn-sm me-2">STOCKS</a>
      <a href="recettes" class="btn btn-outline-light btn-sm me-2">RECETTES</a>
      <a href="livraisons" class="btn btn-outline-light btn-sm me-2">LIVRAISONS</a>
      <a href="commandes" class="btn btn-outline-warning btn-sm me-2">COMMANDES</a>
      <a href="reservations" class="btn btn-outline-warning btn-sm">RESERVATIONS</a>
    </div>
  </div>
</nav>

<div class="container-fluid mt-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0">TABLEAU DE BORD</h2>
        <a href="commandes?action=export" class="btn btn-outline-warning btn-sm">Exporter les commandes (CSV)</a>
    </div>

    <!-- Indicateurs cles -->
    <div class="row g-3 mb-4">
        <div class="col-6 col-lg-3">
            <div class="kpi">
                <div class="kpi-label">Chiffre d'affaires</div>
                <div class="kpi-value"><fmt:formatNumber value="${stats.chiffreAffaires}" type="currency" currencySymbol="€"/></div>
                <div class="kpi-sub"><c:out value="${stats.nombreCommandes}"/> commandes</div>
            </div>
        </div>
        <div class="col-6 col-lg-3">
            <div class="kpi">
                <div class="kpi-label">Aujourd'hui</div>
                <div class="kpi-value"><fmt:formatNumber value="${stats.chiffreAffairesJour}" type="currency" currencySymbol="€"/></div>
                <div class="kpi-sub"><c:out value="${stats.nombreCommandesJour}"/> commandes</div>
            </div>
        </div>
        <div class="col-6 col-lg-3">
            <div class="kpi">
                <div class="kpi-label">Panier moyen</div>
                <div class="kpi-value"><fmt:formatNumber value="${stats.panierMoyen}" type="currency" currencySymbol="€"/></div>
                <div class="kpi-sub"><c:out value="${stats.articlesVendus}"/> articles vendus</div>
            </div>
        </div>
        <div class="col-6 col-lg-3">
            <div class="kpi">
                <div class="kpi-label">Réservations</div>
                <div class="kpi-value"><c:out value="${nombreReservations}"/></div>
                <div class="kpi-sub">tables réservées</div>
            </div>
        </div>
    </div>

    <div class="row g-3">

        <!-- Plats les plus vendus -->
        <div class="col-12 col-lg-5">
            <div class="kpi">
                <h5 class="mb-3">Top 5 des plats vendus</h5>
                <c:set var="max" value="${0}"/>
                <c:forEach var="t" items="${stats.topSushis}">
                    <c:if test="${t.value > max}"><c:set var="max" value="${t.value}"/></c:if>
                </c:forEach>
                <c:forEach var="t" items="${stats.topSushis}">
                    <div class="mb-3">
                        <div class="d-flex justify-content-between">
                            <span><c:out value="${t.key}"/></span>
                            <span class="text-warning"><c:out value="${t.value}"/></span>
                        </div>
                        <div class="bar" style="width: ${t.value * 100 / max}%"></div>
                    </div>
                </c:forEach>
                <c:if test="${empty stats.topSushis}">
                    <p class="kpi-sub">Aucune vente pour le moment.</p>
                </c:if>
            </div>
        </div>

        <!-- Commandes par statut -->
        <div class="col-12 col-md-6 col-lg-3">
            <div class="kpi">
                <h5 class="mb-3">Commandes par statut</h5>
                <table class="table table-sm table-dark mb-0">
                    <c:forEach var="s" items="${stats.commandesParStatut}">
                        <tr>
                            <td><c:out value="${s.key}"/></td>
                            <td class="text-end"><c:out value="${s.value}"/></td>
                        </tr>
                    </c:forEach>
                </table>
                <c:if test="${empty stats.commandesParStatut}">
                    <p class="kpi-sub">Aucune commande.</p>
                </c:if>
            </div>
        </div>

        <!-- Alertes de stock -->
        <div class="col-12 col-md-6 col-lg-4">
            <div class="kpi">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="mb-0">Alertes de stock</h5>
                    <a href="stocks" class="btn btn-outline-light btn-sm">Gérer</a>
                </div>
                <c:forEach var="s" items="${stats.alertesStock}">
                    <div class="d-flex justify-content-between mb-2">
                        <span><c:out value="${s.nom}"/></span>
                        <c:choose>
                            <c:when test="${s.enRupture}"><span class="badge bg-danger">Rupture</span></c:when>
                            <c:otherwise><span class="badge bg-warning text-dark"><c:out value="${s.stock}"/> restants</span></c:otherwise>
                        </c:choose>
                    </div>
                </c:forEach>
                <c:if test="${empty stats.alertesStock}">
                    <p class="kpi-sub">Tous les stocks sont suffisants.</p>
                </c:if>
            </div>
        </div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.min.js" integrity="sha384-QJHtvGhmr9XOIpI6YVutG+2QOK9T+ZnN4kzFN1RtK3zEFEIsxhlmWl5/YESvpZ13" crossorigin="anonymous"></script>
</body>
</html>
