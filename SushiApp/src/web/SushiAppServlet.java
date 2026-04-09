package web;

import java.io.IOException;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import metier.FichierUtil;
import metier.Livraison;
import metier.Sushi;

// servlet principale du site client SushiApp
// gere l affichage du menu et la page de commande
@WebServlet("/sushis")
public class SushiAppServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	// initialisation de la servlet : on configure le chemin des fichiers de donnees
	@Override
	public void init() throws ServletException {
		super.init();
		// on passe le chemin reel du serveur pour que FichierUtil trouve le dossier sushi_data
		String chemin = getServletContext().getRealPath("/");
		FichierUtil.init(chemin);
	}

	// traitement des requetes GET
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// on recupere l action demandee (menu par defaut)
		String action = request.getParameter("action");
		if (action == null) {
			action = "menu";
		}

		// affichage de la page menu principale
		if ("menu".equals(action)) {
			// on charge les sushis et les modes de livraison
			HashMap<Integer, Sushi>     hSushis    = FichierUtil.lireSushis();
			HashMap<Integer, Livraison> hLivraisons = FichierUtil.lireLivraisons();

			// on les passe a la JSP via les attributs de la requete
			request.setAttribute("sushis",     hSushis);
			request.setAttribute("livraisons", hLivraisons);

			// forward vers la page menu
			getServletConfig().getServletContext()
				.getRequestDispatcher("/WEB-INF/jsp/menu.jsp")
				.forward(request, response);

		// affichage du formulaire de commande
		} else if ("commander".equals(action)) {
			// on charge les memes donnees pour le formulaire
			HashMap<Integer, Sushi>     hSushis    = FichierUtil.lireSushis();
			HashMap<Integer, Livraison> hLivraisons = FichierUtil.lireLivraisons();

			request.setAttribute("sushis",     hSushis);
			request.setAttribute("livraisons", hLivraisons);

			// forward vers la page de commande
			getServletConfig().getServletContext()
				.getRequestDispatcher("/WEB-INF/jsp/commander.jsp")
				.forward(request, response);
		}
	}
}
