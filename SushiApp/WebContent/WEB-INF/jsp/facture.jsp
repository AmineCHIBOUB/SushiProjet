<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="fr_FR"/>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Facture <c:out value="${commande.numeroFacture}"/></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
    <style>
        /* facture sur fond blanc, prete a imprimer ou a enregistrer en PDF */
        body { background: #f2f2f2; color: #111; }
        .facture { max-width: 800px; margin: 2rem auto; background: #fff; padding: 3rem; box-shadow: 0 2px 12px rgba(0,0,0,.08); }
        .facture h1 { color: #b38a3e; letter-spacing: 4px; }
        .totaux td { padding: .25rem .75rem; }
        @media print {
            body { background: #fff; }
            .facture { box-shadow: none; margin: 0; padding: 0; }
            .no-print { display: none !important; }
        }
    </style>
</head>
<body>

<c:choose>
<c:when test="${empty commande}">
    <div class="facture"><p>Commande introuvable.</p></div>
</c:when>
<c:otherwise>

<div class="facture">

    <div class="no-print d-flex justify-content-end gap-2 mb-4">
        <button onclick="history.back()" class="btn btn-outline-secondary btn-sm">Retour</button>
        <button onclick="window.print()" class="btn btn-dark btn-sm">Imprimer / Enregistrer en PDF</button>
    </div>

    <!-- En-tete : restaurant et numero de facture -->
    <div class="d-flex justify-content-between mb-5">
        <div>
            <h1 class="h3 mb-1">SUSHI</h1>
            <div class="text-muted small">Restaurant japonais</div>
        </div>
        <div class="text-end">
            <div class="h5 mb-1">FACTURE</div>
            <div><strong><c:out value="${commande.numeroFacture}"/></strong></div>
            <div class="text-muted small">Date : <c:out value="${not empty commande.date ? commande.date : '-'}"/></div>
        </div>
    </div>

    <!-- Client et livraison -->
    <div class="row mb-4">
        <div class="col-6">
            <div class="text-muted small text-uppercase">Facturé à</div>
            <div><strong><c:out value="${commande.client}"/></strong></div>
            <div><c:out value="${commande.adresse}"/></div>
        </div>
        <div class="col-6 text-end">
            <div class="text-muted small text-uppercase">Mode de livraison</div>
            <div><c:out value="${commande.livraison != null ? commande.livraison.nom : '-'}"/></div>
            <div class="text-muted small">Statut : <c:out value="${commande.statut}"/></div>
        </div>
    </div>

    <!-- Lignes de la commande -->
    <table class="table">
        <thead>
            <tr>
                <th>Désignation</th>
                <th class="text-end">Prix unitaire TTC</th>
                <th class="text-end">Quantité</th>
                <th class="text-end">Total TTC</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="l" items="${commande.lignes}">
                <tr>
                    <td><c:out value="${l.sushi.nom}"/></td>
                    <td class="text-end"><fmt:formatNumber value="${l.sushi.prix}" type="currency" currencySymbol="€"/></td>
                    <td class="text-end"><c:out value="${l.quantite}"/></td>
                    <td class="text-end"><fmt:formatNumber value="${l.sousTotal}" type="currency" currencySymbol="€"/></td>
                </tr>
            </c:forEach>
            <c:if test="${commande.livraison != null && commande.livraison.tarif > 0}">
                <tr>
                    <td>Livraison (<c:out value="${commande.livraison.nom}"/>)</td>
                    <td class="text-end"><fmt:formatNumber value="${commande.livraison.tarif}" type="currency" currencySymbol="€"/></td>
                    <td class="text-end">1</td>
                    <td class="text-end"><fmt:formatNumber value="${commande.livraison.tarif}" type="currency" currencySymbol="€"/></td>
                </tr>
            </c:if>
        </tbody>
    </table>

    <!-- Totaux -->
    <div class="d-flex justify-content-end">
        <table class="totaux">
            <tr>
                <td>Total HT</td>
                <td class="text-end"><fmt:formatNumber value="${commande.totalHT}" type="currency" currencySymbol="€"/></td>
            </tr>
            <tr>
                <td>TVA 10 %</td>
                <td class="text-end"><fmt:formatNumber value="${commande.montantTVA}" type="currency" currencySymbol="€"/></td>
            </tr>
            <tr class="fw-bold border-top">
                <td>Total TTC</td>
                <td class="text-end"><fmt:formatNumber value="${commande.total}" type="currency" currencySymbol="€"/></td>
            </tr>
        </table>
    </div>

    <p class="text-muted small mt-5 mb-0">Merci pour votre commande.</p>
</div>

</c:otherwise>
</c:choose>

</body>
</html>
