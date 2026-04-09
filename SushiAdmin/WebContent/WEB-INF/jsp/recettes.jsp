<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="metier.Recette" %>
<jsp:useBean id="recettes" class="java.util.HashMap" scope="request"></jsp:useBean>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SushiAdmin - Recettes</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>

<!-- Barre de navigation principale -->
<nav class="navbar navbar-dark bg-dark">
  <div class="container-fluid">
    <a class="navbar-brand" href="sushis">SushiAdmin</a>
    <div>
      <a href="sushis" class="btn btn-outline-light btn-sm me-2">SUSHIS</a>
      <a href="recettes" class="btn btn-outline-light btn-sm me-2">RECETTES</a>
      <a href="livraisons" class="btn btn-outline-light btn-sm me-2">LIVRAISONS</a>
      <a href="commandes" class="btn btn-outline-warning btn-sm me-2">COMMANDES</a>
      <a href="reservations" class="btn btn-outline-warning btn-sm">RESERVATIONS</a>
    </div>
  </div>
</nav>

<div class="container-fluid mt-4">

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>NOS RECETTES</h2>
        <!-- Bouton d'ajout d'une nouvelle recette -->
        <a href="recettes?action=formulaire" class="btn btn-danger">Ajouter une recette</a>
    </div>

    <table class="table table-hover">
        <thead class="table-dark">
            <tr>
                <th>#</th>
                <th>Nom</th>
                <th>Ingredients</th>
                <th>Description</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <%! int i = 1; %> <%-- compteur de ligne pour l'affichage --%>
            <c:forEach var="r" items="${recettes}">
                <tr>
                    <td><%= i++ %></td>
                    <td><c:out value="${r.value.nom}"/></td>
                    <td><c:out value="${r.value.ingredients}"/></td>
                    <td><c:out value="${r.value.description}"/></td>
                    <td>
                        <!-- Modifier ou supprimer la recette -->
                        <a href="recettes?action=formulaire&id=<c:out value='${r.value.id}'/>" class="btn btn-warning btn-sm me-1">Modifier</a>
                        <a href="recettes?action=supprimer&id=<c:out value='${r.value.id}'/>" class="btn btn-secondary btn-sm">Supprimer</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.min.js" integrity="sha384-QJHtvGhmr9XOIpI6YVutG+2QOK9T+ZnN4kzFN1RtK3zEFEIsxhlmWl5/YESvpZ13" crossorigin="anonymous"></script>
</body>
</html>
