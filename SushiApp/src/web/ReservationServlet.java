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

// servlet pour gerer les reservations de table
// fonctionnalite innovante ajoutee au site
@WebServlet("/reservations")
public class ReservationServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	// traitement des requetes GET (afficher le formulaire ou la liste)
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String action = request.getParameter("action");
		// par defaut on affiche le formulaire de reservation
		if (action == null) {
			action = "formulaire";
		}

		// affichage du formulaire de reservation
		if ("formulaire".equals(action)) {
			// on regarde si une reservation vient d etre confirmee
			String confirmation = request.getParameter("confirmation");
			if (confirmation != null) {
				request.setAttribute("confirmation", "ok");
			}
			getServletConfig().getServletContext()
				.getRequestDispatcher("/WEB-INF/jsp/reservation.jsp")
				.forward(request, response);

		// affichage de la liste des reservations du client
		} else if ("liste".equals(action)) {
			HashMap<Integer, Reservation> hReservations = FichierUtil.lireReservations();

			// on peut filtrer par nom de client
			String client = request.getParameter("client");
			if (client != null && !client.isEmpty()) {
				HashMap<Integer, Reservation> hFiltre = new HashMap<>();
				for (Reservation r : hReservations.values()) {
					if (client.equalsIgnoreCase(r.getClient())) {
						hFiltre.put(r.getId(), r);
					}
				}
				request.setAttribute("reservations", hFiltre);
				request.setAttribute("clientFiltre", client);
			} else {
				request.setAttribute("reservations", hReservations);
			}

			getServletConfig().getServletContext()
				.getRequestDispatcher("/WEB-INF/jsp/mesReservations.jsp")
				.forward(request, response);
		}
	}

	// traitement des requetes POST (enregistrer une nouvelle reservation)
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		request.setCharacterEncoding("UTF-8");

		String action = request.getParameter("action");

		// creation d une nouvelle reservation
		if ("reserver".equals(action)) {
			// on recupere les informations du formulaire
			String client      = request.getParameter("client");
			String date        = request.getParameter("date");
			String heure       = request.getParameter("heure");
			int nbPersonnes    = Integer.parseInt(request.getParameter("nbPersonnes"));
			String telephone   = request.getParameter("telephone");

			// on charge les reservations existantes
			HashMap<Integer, Reservation> hReservations = FichierUtil.lireReservations();

			// on cree la nouvelle reservation
			Reservation r = new Reservation();
			r.setId(FichierUtil.prochainId(hReservations));
			r.setClient(client);
			r.setDate(date);
			r.setHeure(heure);
			r.setNbPersonnes(nbPersonnes);
			r.setTelephone(telephone);
			r.setStatut("en attente");

			// on l ajoute et on sauvegarde
			hReservations.put(r.getId(), r);
			FichierUtil.ecrireReservations(hReservations);

			// on redirige vers le formulaire avec un message de confirmation
			response.sendRedirect(getServletContext().getContextPath() + "/reservations?action=formulaire&confirmation=ok");
		}
	}
}
