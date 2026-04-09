package web;

import java.io.IOException;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import metier.FichierUtil;
import metier.Reservation;

// servlet admin pour gerer les reservations de table des clients
@WebServlet("/reservations")
public class ReservationAdminServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	// traitement des requetes GET (liste des reservations ou changer statut)
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String action = request.getParameter("action");
		if (action == null) {
			action = "liste";
		}

		// affichage de la liste des reservations
		if ("liste".equals(action)) {
			HashMap<Integer, Reservation> hReservations = FichierUtil.lireReservations();
			request.setAttribute("reservations", hReservations);
			getServletConfig().getServletContext()
				.getRequestDispatcher("/WEB-INF/jsp/reservations.jsp")
				.forward(request, response);

		// changer le statut d une reservation (confirmer ou annuler)
		} else if ("changerStatut".equals(action)) {
			int id = Integer.parseInt(request.getParameter("id"));
			String statut = request.getParameter("statut");
			HashMap<Integer, Reservation> hReservations = FichierUtil.lireReservations();
			Reservation r = hReservations.get(id);
			if (r != null) {
				r.setStatut(statut);
			}
			FichierUtil.ecrireReservations(hReservations);
			// on redirige vers la liste apres modification
			response.sendRedirect(getServletContext().getContextPath() + "/reservations");

		// supprimer une reservation
		} else if ("supprimer".equals(action)) {
			int id = Integer.parseInt(request.getParameter("id"));
			HashMap<Integer, Reservation> hReservations = FichierUtil.lireReservations();
			hReservations.remove(id);
			FichierUtil.ecrireReservations(hReservations);
			response.sendRedirect(getServletContext().getContextPath() + "/reservations");
		}
	}

	// le POST redirige vers le GET
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}
}
