<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SushiAdmin - Stocks</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>

<!-- Barre de navigation principale -->
<nav class="navbar navbar-dark bg-dark">
  <div class="container-fluid">
    <a class="navbar-brand" href="sushis">SushiAdmin</a>
    <div>
      <a href="tableau-de-bord" class="btn btn-outline-warning btn-sm me-2">TABLEAU DE BORD</a>
      <a href="sushis" class="btn btn-outline-light btn-sm me-2">SUSHIS</a>
      <a href="stocks" class="btn btn-light btn-sm me-2">STOCKS</a>
      <a href="recettes" class="btn btn-outline-light btn-sm me-2">RECETTES</a>
      <a href="livraisons" class="btn btn-outline-light btn-sm me-2">LIVRAISONS</a>
      <a href="commandes" class="btn btn-outline-warning btn-sm me-2">COMMANDES</a>
      <a href="reservations" class="btn btn-outline-warning btn-sm">RESERVATIONS</a>
    </div>
  </div>
</nav>

<div class="container-fluid mt-4">

    <h2 class="mb-1">STOCKS</h2>
    <p class="text-muted mb-4">Le stock baisse automatiquement à chaque commande et remonte si une commande est annulée.</p>

    <table class="table table-hover align-middle">
        <thead class="table-dark">
            <tr>
                <th>Plat</th>
                <th>Catégorie</th>
                <th>Stock</th>
                <th>État</th>
                <th>Réapprovisionner</th>
                <th>Seuil d'alerte</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="s" items="${sushis}">
                <tr>
                    <td><c:out value="${s.value.nom}"/></td>
                    <td><c:out value="${s.value.categorie}"/></td>
                    <td><strong><c:out value="${s.value.stock}"/></strong></td>
                    <td>
                        <c:choose>
                            <c:when test="${s.value.enRupture}"><span class="badge bg-danger">Rupture</span></c:when>
                            <c:when test="${s.value.stockBas}"><span class="badge bg-warning text-dark">Stock bas</span></c:when>
                            <c:otherwise><span class="badge bg-success">OK</span></c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <!-- entree en stock -->
                        <form method="post" action="stocks" class="d-flex gap-2">
                            <input type="hidden" name="action" value="reapprovisionner">
                            <input type="hidden" name="id" value="<c:out value='${s.value.id}'/>">
                            <input type="number" name="quantite" min="1" value="10" class="form-control form-control-sm" style="width:90px" required>
                            <button type="submit" class="btn btn-success btn-sm">+ Ajouter</button>
                        </form>
                    </td>
                    <td>
                        <!-- seuil en dessous duquel le plat est signale -->
                        <form method="post" action="stocks" class="d-flex gap-2">
                            <input type="hidden" name="action" value="seuil">
                            <input type="hidden" name="id" value="<c:out value='${s.value.id}'/>">
                            <input type="number" name="seuil" min="0" value="<c:out value='${s.value.seuilAlerte}'/>" class="form-control form-control-sm" style="width:80px" required>
                            <button type="submit" class="btn btn-outline-light btn-sm">OK</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.min.js" integrity="sha384-QJHtvGhmr9XOIpI6YVutG+2QOK9T+ZnN4kzFN1RtK3zEFEIsxhlmWl5/YESvpZ13" crossorigin="anonymous"></script>
</body>
</html>
