package web;

import java.io.IOException;
import java.time.LocalDate;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import metier.Commande;
import metier.FichierUtil;
import metier.Livraison;
import metier.Reservation;
import metier.Statistiques;
import metier.Sushi;

/**
 * servlet admin du tableau de bord : chiffre d affaires, ventes et alertes de stock
 */
@WebServlet("/tableau-de-bord")
public class TableauDeBordServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HashMap<Integer, Sushi> hSushis = FichierUtil.lireSushis();
		HashMap<Integer, Livraison> hLivraisons = FichierUtil.lireLivraisons();
		HashMap<Integer, Commande> hCommandes = FichierUtil.lireCommandes(hSushis, hLivraisons);
		HashMap<Integer, Reservation> hReservations = FichierUtil.lireReservations();

		String aujourdhui = LocalDate.now().toString();
		Statistiques stats = new Statistiques(hCommandes.values(), hSushis.values(), aujourdhui);

		request.setAttribute("stats", stats);
		request.setAttribute("aujourdhui", aujourdhui);
		request.setAttribute("nombreReservations", hReservations.size());
		getServletConfig().getServletContext()
			.getRequestDispatcher("/WEB-INF/jsp/tableauDeBord.jsp")
			.forward(request, response);
	}
}
