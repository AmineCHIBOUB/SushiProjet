package web;

import java.io.IOException;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import metier.FichierUtil;
import metier.Sushi;

// servlet admin pour gerer les sushis (ajout, modif, suppression, liste)
@WebServlet("/sushis")
public class SushiAdminServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	public void init() throws ServletException {
		// TODO Auto-generated method stub
		super.init();
		// on initialise le chemin des fichiers avec le chemin reel du serveur
		String chemin = getServletContext().getRealPath("/");
		FichierUtil.init(chemin);
	}

	// traitement des requetes GET (afficher la liste, le formulaire, ou supprimer)
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String action = request.getParameter("action");
		// par defaut on affiche la liste
		if (action == null) {
			action = "liste";
		}

		// affichage de la liste des sushis
		if ("liste".equals(action)) {
			HashMap<Integer, Sushi> hSushis = FichierUtil.lireSushis();
			request.setAttribute("sushis", hSushis);
			getServletConfig().getServletContext()
				.getRequestDispatcher("/WEB-INF/jsp/sushis.jsp")
				.forward(request, response);

		// affichage du formulaire (ajout ou modification)
		} else if ("formulaire".equals(action)) {
			String idParam = request.getParameter("id");
			// si on a un id c est une modification, on charge le sushi
			if (idParam != null) {
				HashMap<Integer, Sushi> hSushis = FichierUtil.lireSushis();
				request.setAttribute("sushi", hSushis.get(Integer.parseInt(idParam)));
			}
			getServletConfig().getServletContext()
				.getRequestDispatcher("/WEB-INF/jsp/formulaireSushi.jsp")
				.forward(request, response);

		// suppression d un sushi
		} else if ("supprimer".equals(action)) {
			int id = Integer.parseInt(request.getParameter("id"));
			HashMap<Integer, Sushi> hSushis = FichierUtil.lireSushis();
			hSushis.remove(id);
			FichierUtil.ecrireSushis(hSushis);
			// on redirige vers la liste apres suppression
			response.sendRedirect(getServletContext().getContextPath() + "/sushis");
		}
	}

	// traitement des requetes POST (ajout ou modification d un sushi)
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		request.setCharacterEncoding("UTF-8");
		// on recupere les parametres du formulaire
		String action      = request.getParameter("action");
		String nom         = request.getParameter("nom");
		String description = request.getParameter("description");
		double prix        = Double.parseDouble(request.getParameter("prix"));
		String categorie   = request.getParameter("categorie");
		// on recupere aussi l url de l image
		String image       = request.getParameter("image");

		HashMap<Integer, Sushi> hSushis = FichierUtil.lireSushis();

		// modification d un sushi existant
		if ("modifier".equals(action)) {
			int id = Integer.parseInt(request.getParameter("id"));
			Sushi sushi = hSushis.get(id);
			sushi.setNom(nom);
			sushi.setDescription(description);
			sushi.setPrix(prix);
			sushi.setCategorie(categorie);
			sushi.setImage(image);
		} else {
			// ajout d un nouveau sushi
			Sushi sushi = new Sushi();
			sushi.setId(FichierUtil.prochainId(hSushis));
			sushi.setNom(nom);
			sushi.setDescription(description);
			sushi.setPrix(prix);
			sushi.setCategorie(categorie);
			sushi.setImage(image);
			hSushis.put(sushi.getId(), sushi);
		}

		// on sauvegarde et on redirige vers la liste
		FichierUtil.ecrireSushis(hSushis);
		response.sendRedirect(getServletContext().getContextPath() + "/sushis");
	}
}
