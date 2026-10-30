<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="metier.Commande, metier.CommandeLigne" %>
<jsp:useBean id="commande" class="metier.Commande" scope="request"></jsp:useBean>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SushiAdmin - Detail commande</title>
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

    <h2 class="mb-3">DETAIL COMMANDE</h2>

    <!-- Carte recapitulatif de la commande -->
    <div class="card mb-4">
        <div class="card-header">
            <strong>Informations de la commande</strong>
        </div>
        <div class="card-body">
            <p><strong>Client :</strong> <jsp:getProperty name="commande" property="client"/></p>
            <p><strong>Adresse :</strong> <jsp:getProperty name="commande" property="adresse"/></p>
            <p>
                <strong>Statut :</strong>
                <span class="badge bg-warning"><jsp:getProperty name="commande" property="statut"/></span>
            </p>
            <p><strong>Mode de livraison :</strong>
                <% if (commande.getLivraison() != null) { %>
                    <%= commande.getLivraison().getNom() %>
                <% } else { %>
                    Non defini
                <% } %>
            </p>
        </div>
    </div>

    <!-- Tableau des lignes de commande -->
    <h4 class="mb-2">Articles commandes</h4>
    <table class="table table-hover mb-3">
        <thead class="table-dark">
            <tr>
                <th>Sushi</th>
                <th>Image</th>
                <th>Quantite</th>
                <th>Sous-total</th>
            </tr>
        </thead>
        <tbody>
            <%
                // on itere sur la liste des lignes avec un for classique
                // car getLignes() retourne un ArrayList
                if (commande.getLignes() != null) {
                    for (CommandeLigne ligne : commande.getLignes()) {
            %>
                <tr>
                    <td><%= ligne.getSushi().getNom() != null ? ligne.getSushi().getNom() : "" %></td>
                    <td>
                        <!-- Miniature de l'image du sushi pour identifier facilement -->
                        <% if (ligne.getSushi().getImage() != null && !ligne.getSushi().getImage().isEmpty()) { %>
                            <img src="<%= ligne.getSushi().getImage() %>" style="width:50px;height:50px;object-fit:cover;" alt="sushi">
                        <% } %>
                    </td>
                    <td><%= ligne.getQuantite() %></td>
                    <td><%= ligne.getSousTotal() %> &euro;</td>
                </tr>
            <%
                    } // fin du for
                } // fin du if
            %>
        </tbody>
    </table>

    <!-- Affichage du total general de la commande -->
    <div class="d-flex justify-content-end mb-4">
        <h5>
            Total : <strong><jsp:getProperty name="commande" property="total"/> &euro;</strong>
        </h5>
    </div>

    <!-- Boutons pour changer le statut de la commande -->
    <div class="card mb-4">
        <div class="card-header">Changer le statut</div>
        <div class="card-body">
            <%-- on passe le nouvel etat via le parametre statut dans l'URL --%>
            <a href="commandes?action=changerStatut&id=<jsp:getProperty name='commande' property='id'/>&statut=en+attente"
               class="btn btn-warning btn-sm me-2">En attente</a>
            <a href="commandes?action=changerStatut&id=<jsp:getProperty name='commande' property='id'/>&statut=en+preparation"
               class="btn btn-primary btn-sm me-2">En preparation</a>
            <a href="commandes?action=changerStatut&id=<jsp:getProperty name='commande' property='id'/>&statut=livree"
               class="btn btn-success btn-sm me-2">Livree</a>
               <a href="commandes?action=changerStatut&id=<jsp:getProperty name='commande' property='id'/>&statut=annulee" class="btn btn-danger btn-sm me-2" onclick="return confirm('Annuler cette commande ? Les plats seront remis en stock.')">Annuler</a>
               <a href="commandes?action=facture&id=<jsp:getProperty name='commande' property='id'/>" class="btn btn-outline-light btn-sm">Facture</a>
        </div>
    </div>

    <!-- Retour vers la liste des commandes -->
    <a href="commandes" class="btn btn-secondary">Retour aux commandes</a>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.min.js" integrity="sha384-QJHtvGhmr9XOIpI6YVutG+2QOK9T+ZnN4kzFN1RtK3zEFEIsxhlmWl5/YESvpZ13" crossorigin="anonymous"></script>
</body>
</html>
