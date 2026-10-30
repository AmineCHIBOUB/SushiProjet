<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="metier.Livraison" %>
<jsp:useBean id="livraisons" class="java.util.HashMap" scope="request"></jsp:useBean>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SushiAdmin - Tarifs Livraison</title>
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
      <a href="stocks" class="btn btn-outline-light btn-sm me-2">STOCKS</a>
      <a href="recettes" class="btn btn-outline-light btn-sm me-2">RECETTES</a>
      <a href="livraisons" class="btn btn-outline-light btn-sm me-2">LIVRAISONS</a>
      <a href="commandes" class="btn btn-outline-warning btn-sm me-2">COMMANDES</a>
      <a href="reservations" class="btn btn-outline-warning btn-sm">RESERVATIONS</a>
    </div>
  </div>
</nav>

<div class="container-fluid mt-4">

    <h2 class="mb-4">TARIFS LIVRAISON</h2>

    <!-- Affichage des modes de livraison sous forme de cartes Bootstrap -->
    <div class="row">
        <c:forEach var="l" items="${livraisons}">
            <div class="col-md-4 mb-3">
                <div class="card">
                    <!-- En-tete de la carte avec le nom du mode de livraison -->
                    <div class="card-header">
                        <strong><c:out value="${l.value.nom}"/></strong>
                    </div>
                    <div class="card-body">

                        <!-- Informations sur le type de livraison -->
                        <p class="mb-2">
                            <span class="badge bg-secondary">
                                <c:out value="${l.value.type}"/>
                            </span>
                        </p>
                        <p class="mb-3">
                            Tarif actuel : <strong><c:out value="${l.value.tarif}"/> &euro;</strong>
                        </p>

                        <!-- Formulaire de modification du tarif pour ce mode de livraison -->
                        <form action="livraisons" method="post">
                            <%-- on envoie l'action modifier avec l'id et le type du mode --%>
                            <input type="hidden" name="action" value="modifier">
                            <input type="hidden" name="id" value="<c:out value='${l.value.id}'/>">
                            <input type="hidden" name="type" value="<c:out value='${l.value.type}'/>">

                            <div class="mb-2">
                                <label class="form-label" for="tarif_<c:out value='${l.value.id}'/>">Nouveau tarif (&euro;)</label>
                                <input type="number" class="form-control form-control-sm"
                                       id="tarif_<c:out value='${l.value.id}'/>"
                                       name="tarif" step="0.01" min="0"
                                       value="<c:out value='${l.value.tarif}'/>">
                            </div>

                            <button type="submit" class="btn btn-warning btn-sm">Modifier le tarif</button>
                        </form>

                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.min.js" integrity="sha384-QJHtvGhmr9XOIpI6YVutG+2QOK9T+ZnN4kzFN1RtK3zEFEIsxhlmWl5/YESvpZ13" crossorigin="anonymous"></script>
</body>
</html>
