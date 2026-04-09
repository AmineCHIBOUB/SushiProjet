<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="metier.Sushi" %>
<jsp:useBean id="sushi" class="metier.Sushi" scope="request"></jsp:useBean>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%-- titre de la page selon qu'on est en ajout ou modification --%>
    <title>SushiAdmin -
        <% if (sushi.getId() > 0) { %>
            Modifier un sushi
        <% } else { %>
            Ajouter un sushi
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

    <!-- Titre dynamique selon le mode ajout ou modification -->
    <h2>
        <% if (sushi.getId() > 0) { %>
            Modifier le sushi
        <% } else { %>
            Ajouter un sushi
        <% } %>
    </h2>

    <div class="card mt-3">
        <div class="card-body">
            <form action="sushis" method="post">

                <%-- champ action hidden : ajouter ou modifier selon l'id du sushi --%>
                <% if (sushi.getId() > 0) { %>
                    <input type="hidden" name="action" value="modifier">
                    <input type="hidden" name="id" value="<%= sushi.getId() %>">
                <% } else { %>
                    <input type="hidden" name="action" value="ajouter">
                <% } %>

                <div class="mb-3">
                    <label class="form-label" for="nom">Nom</label>
                    <input type="text" class="form-control" id="nom" name="nom"
                           value="<%= sushi.getNom() != null ? sushi.getNom() : "" %>" required>
                </div>

                <div class="mb-3">
                    <label class="form-label" for="description">Description</label>
                    <!-- textarea necessite la valeur entre les balises, pas en attribut value -->
                    <textarea class="form-control" id="description" name="description" rows="3"><%= sushi.getDescription() != null ? sushi.getDescription() : "" %></textarea>
                </div>

                <div class="mb-3">
                    <label class="form-label" for="prix">Prix (&euro;)</label>
                    <input type="number" class="form-control" id="prix" name="prix" step="0.01" min="0"
                           value="<%= sushi.getPrix() > 0 ? sushi.getPrix() : "" %>">
                </div>

                <div class="mb-3">
                    <label class="form-label" for="categorie">Categorie</label>
                    <input type="text" class="form-control" id="categorie" name="categorie"
                           value="<%= sushi.getCategorie() != null ? sushi.getCategorie() : "" %>">
                </div>

                <div class="mb-3">
                    <label class="form-label" for="image">Image</label>
                    <!-- L'utilisateur saisit l'URL de l'image -->
                    <input type="text" class="form-control" id="image" name="image"
                           placeholder="URL de l'image du sushi"
                           value="<%= sushi.getImage() != null ? sushi.getImage() : "" %>">
                </div>

                <!-- bouton d'enregistrement et retour -->
                <button type="submit" class="btn btn-danger me-2">Enregistrer</button>
                <a href="sushis" class="btn btn-secondary">Retour a la liste</a>

            </form>
        </div>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.min.js" integrity="sha384-QJHtvGhmr9XOIpI6YVutG+2QOK9T+ZnN4kzFN1RtK3zEFEIsxhlmWl5/YESvpZ13" crossorigin="anonymous"></script>
</body>
</html>
