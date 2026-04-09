<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Réserver une table - SushiApp</title>
    <!-- Bootstrap 5.1.3 CDN -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
    <!-- notre feuille de style -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

<!-- ===== NAVBAR ===== -->
<nav class="navbar navbar-expand-lg sushi-navbar">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/sushis?action=menu">
            SUSHI<span>APP</span>
        </a>
        <button class="navbar-toggler" type="button"
                data-bs-toggle="collapse" data-bs-target="#navMenu">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navMenu">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/sushis?action=menu">Menu</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/sushis?action=commander">Commander</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/reservations?action=formulaire">Réserver</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/commandes?action=liste">Mes Commandes</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- ===== SECTION RESERVATION ===== -->
<section class="reservation-section">
    <div class="container">

        <!-- titre de la page -->
        <div class="text-center mb-5" style="padding-top:60px;">
            <p class="section-subtitle">Réservez votre expérience</p>
            <h2 class="section-title">RÉSERVER UNE TABLE</h2>
            <div class="section-divider mx-auto"></div>
        </div>

        <%-- message de confirmation si la reservation a ete enregistree --%>
        <c:if test="${not empty confirmation}">
            <div class="alert-confirmation text-center mb-4">
                <strong>Votre reservation a bien ete enregistree.</strong><br>
                Nous vous confirmerons par telephone. Merci de votre confiance.
            </div>
        </c:if>

        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <div class="reservation-card">

                    <!-- formulaire de reservation -->
                    <form action="reservations" method="post">
                        <!-- champ hidden pour l action -->
                        <input type="hidden" name="action" value="reserver">

                        <!-- nom du client -->
                        <div class="form-group-dark mb-3">
                            <label class="form-label-dark" for="client">Votre nom</label>
                            <input type="text" class="form-input-dark" id="client" name="client"
                                   placeholder="Nom complet" required>
                        </div>

                        <!-- telephone -->
                        <div class="form-group-dark mb-3">
                            <label class="form-label-dark" for="telephone">Telephone</label>
                            <input type="tel" class="form-input-dark" id="telephone" name="telephone"
                                   placeholder="06 12 34 56 78" required>
                        </div>

                        <!-- date de reservation -->
                        <div class="form-group-dark mb-3">
                            <label class="form-label-dark" for="date">Date</label>
                            <input type="date" class="form-input-dark" id="date" name="date" required>
                        </div>

                        <!-- heure de reservation -->
                        <div class="form-group-dark mb-3">
                            <label class="form-label-dark" for="heure">Heure</label>
                            <select class="form-input-dark" id="heure" name="heure" required>
                                <option value="">-- Choisir un creneau --</option>
                                <!-- creneaux du midi -->
                                <option value="11:30">11h30</option>
                                <option value="12:00">12h00</option>
                                <option value="12:30">12h30</option>
                                <option value="13:00">13h00</option>
                                <option value="13:30">13h30</option>
                                <!-- creneaux du soir -->
                                <option value="19:00">19h00</option>
                                <option value="19:30">19h30</option>
                                <option value="20:00">20h00</option>
                                <option value="20:30">20h30</option>
                                <option value="21:00">21h00</option>
                                <option value="21:30">21h30</option>
                            </select>
                        </div>

                        <!-- nombre de personnes -->
                        <div class="form-group-dark mb-3">
                            <label class="form-label-dark" for="nbPersonnes">Nombre de personnes</label>
                            <select class="form-input-dark" id="nbPersonnes" name="nbPersonnes" required>
                                <option value="1">1 personne</option>
                                <option value="2" selected>2 personnes</option>
                                <option value="3">3 personnes</option>
                                <option value="4">4 personnes</option>
                                <option value="5">5 personnes</option>
                                <option value="6">6 personnes</option>
                                <option value="7">7 personnes</option>
                                <option value="8">8 personnes</option>
                            </select>
                        </div>

                        <!-- bouton de soumission -->
                        <button type="submit" class="btn-gold w-100 mt-3">Confirmer la reservation</button>
                    </form>

                    <!-- lien vers la liste des reservations -->
                    <div class="text-center mt-3">
                        <a href="reservations?action=liste" class="link-gold">
                            Voir mes reservations
                        </a>
                    </div>

                </div>
            </div>
        </div>

    </div>
</section>

<!-- ===== FOOTER ===== -->
<footer class="sushi-footer">
    <div class="container">
        <div class="footer-brand">SUSHIAPP</div>
        <div class="footer-divider"></div>
        <p class="footer-copy">
            &copy; <%= new java.util.Date().getYear() + 1900 %> SushiApp &mdash; Restaurant Japonais Authentique, Bordeaux.
        </p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
