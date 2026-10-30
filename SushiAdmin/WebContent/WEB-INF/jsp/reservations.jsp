<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="metier.Reservation" %>
<jsp:useBean id="reservations" class="java.util.HashMap" scope="request"></jsp:useBean>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SushiAdmin - Reservations</title>
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

    <h2>RESERVATIONS DE TABLE</h2>

    <%-- si aucune reservation on affiche un message --%>
    <c:if test="${empty reservations}">
        <div class="alert alert-warning mt-3">
            Aucune reservation pour le moment.
        </div>
    </c:if>

    <c:if test="${not empty reservations}">
        <table class="table table-hover mt-3">
            <thead class="table-dark">
                <tr>
                    <th>#</th>
                    <th>Client</th>
                    <th>Date</th>
                    <th>Heure</th>
                    <th>Personnes</th>
                    <th>Telephone</th>
                    <th>Statut</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%-- compteur de ligne comme fait le prof --%>
                <%! int i = 1; %>
                <c:forEach var="r" items="${reservations}">
                    <tr>
                        <td><%= i++ %></td>
                        <td><c:out value="${r.value.client}"/></td>
                        <td><c:out value="${r.value.date}"/></td>
                        <td><c:out value="${r.value.heure}"/></td>
                        <td><c:out value="${r.value.nbPersonnes}"/></td>
                        <td><c:out value="${r.value.telephone}"/></td>
                        <td>
                            <!-- badge de statut avec couleur -->
                            <span class="badge bg-warning"><c:out value="${r.value.statut}"/></span>
                        </td>
                        <td>
                            <!-- boutons pour changer le statut de la reservation -->
                            <a href="reservations?action=changerStatut&id=<c:out value='${r.value.id}'/>&statut=confirmee"
                               class="btn btn-success btn-sm me-1">Confirmer</a>
                            <a href="reservations?action=changerStatut&id=<c:out value='${r.value.id}'/>&statut=annulee"
                               class="btn btn-secondary btn-sm me-1">Annuler</a>
                            <a href="reservations?action=supprimer&id=<c:out value='${r.value.id}'/>"
                               class="btn btn-secondary btn-sm">Supprimer</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.min.js" integrity="sha384-QJHtvGhmr9XOIpI6YVutG+2QOK9T+ZnN4kzFN1RtK3zEFEIsxhlmWl5/YESvpZ13" crossorigin="anonymous"></script>
</body>
</html>
