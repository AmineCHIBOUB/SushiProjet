<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="metier.Commande" %>
<jsp:useBean id="commandes" class="java.util.HashMap" scope="request"></jsp:useBean>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SushiAdmin - Commandes</title>
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

    <h2 class="mb-3">COMMANDES</h2>

    <table class="table table-hover">
        <thead class="table-dark">
            <tr>
                <th>#</th>
                <th>Client</th>
                <th>Adresse</th>
                <th>Statut</th>
                <th>Total</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <%! int i = 1; %> <%-- compteur pour numeroter les commandes --%>
            <c:forEach var="c" items="${commandes}">
                <tr>
                    <td><%= i++ %></td>
                    <td><c:out value="${c.value.client}"/></td>
                    <td><c:out value="${c.value.adresse}"/></td>
                    <td>
                        <!-- Badge de statut : la couleur est geree en CSS via le theme -->
                        <span class="badge bg-warning">
                            <c:out value="${c.value.statut}"/>
                        </span>
                    </td>
                    <td><c:out value="${c.value.total}"/> &euro;</td>
                    <td>
                        <!-- Boutons pour changer le statut rapidement -->
                        <a href="commandes?action=changerStatut&id=<c:out value='${c.value.id}'/>&statut=en+preparation" class="btn btn-primary btn-sm me-1">Preparer</a>
                        <a href="commandes?action=changerStatut&id=<c:out value='${c.value.id}'/>&statut=livree" class="btn btn-success btn-sm me-1">Livree</a>
                        <!-- Detail et suppression -->
                        <a href="commandes?action=detail&id=<c:out value='${c.value.id}'/>" class="btn btn-warning btn-sm me-1">Detail</a>
                        <a href="commandes?action=supprimer&id=<c:out value='${c.value.id}'/>" class="btn btn-secondary btn-sm">Supprimer</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.min.js" integrity="sha384-QJHtvGhmr9XOIpI6YVutG+2QOK9T+ZnN4kzFN1RtK3zEFEIsxhlmWl5/YESvpZ13" crossorigin="anonymous"></script>
</body>
</html>
