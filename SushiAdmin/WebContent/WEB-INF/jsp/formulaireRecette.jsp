<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="metier.Recette" %>
<jsp:useBean id="recette" class="metier.Recette" scope="request"></jsp:useBean>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%-- titre de la page selon qu'on est en ajout ou modification --%>
    <title>SushiAdmin -
        <% if (recette.getId() > 0) { %>
            Modifier une recette
        <% } else { %>
            Ajouter une recette
        <% } %>
    </title>
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

    <!-- Titre affiche selon le mode : ajout ou modification -->
    <h2>
        <% if (recette.getId() > 0) { %>
            Modifier la recette
        <% } else { %>
            Ajouter une recette
        <% } %>
    </h2>

    <div class="card mt-3">
        <div class="card-body">
            <form action="recettes" method="post">

                <%-- input hidden pour l'action et l'id si on est en modification --%>
                <% if (recette.getId() > 0) { %>
                    <input type="hidden" name="action" value="modifier">
                    <input type="hidden" name="id" value="<%= recette.getId() %>">
                <% } else { %>
                    <input type="hidden" name="action" value="ajouter">
                <% } %>

                <div class="mb-3">
                    <label class="form-label" for="nom">Nom de la recette</label>
                    <input type="text" class="form-control" id="nom" name="nom"
                           value="<%= recette.getNom() != null ? recette.getNom() : "" %>" required>
                </div>

                <div class="mb-3">
                    <label class="form-label" for="ingredients">Ingredients</label>
                    <!-- Les ingredients sont saisis un par un ou separes par des virgules -->
                    <textarea class="form-control" id="ingredients" name="ingredients" rows="3"><%= recette.getIngredients() != null ? recette.getIngredients() : "" %></textarea>
                </div>

                <div class="mb-3">
                    <label class="form-label" for="description">Description / Etapes de preparation</label>
                    <textarea class="form-control" id="description" name="description" rows="3"><%= recette.getDescription() != null ? recette.getDescription() : "" %></textarea>
                </div>

                <!-- bouton enregistrer et retour a la liste -->
                <button type="submit" class="btn btn-danger me-2">Enregistrer</button>
                <a href="recettes" class="btn btn-secondary">Retour a la liste</a>

            </form>
        </div>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.min.js" integrity="sha384-QJHtvGhmr9XOIpI6YVutG+2QOK9T+ZnN4kzFN1RtK3zEFEIsxhlmWl5/YESvpZ13" crossorigin="anonymous"></script>
</body>
</html>
