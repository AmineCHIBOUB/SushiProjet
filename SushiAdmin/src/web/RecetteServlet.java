package web;

import java.io.IOException;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import metier.FichierUtil;
import metier.Recette;

/**
 * servlet admin pour gerer les recettes
 */
@WebServlet("/recettes")
public class RecetteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	public void init() throws ServletException {
		// TODO Auto-generated method stub
		super.init();
		// initialisation du chemin des fichiers
		String chemin = getServletContext().getRealPath("/");
		FichierUtil.init(chemin);
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String action = request.getParameter("action");
		if (action == null) {
			action = "liste";
		}

		if ("liste".equals(action)) {
			HashMap<Integer, Recette> hRecettes = FichierUtil.lireRecettes();
			request.setAttribute("recettes", hRecettes);
			getServletConfig().getServletContext()
				.getRequestDispatcher("/WEB-INF/jsp/recettes.jsp")
				.forward(request, response);

		} else if ("formulaire".equals(action)) {
			String idParam = request.getParameter("id");
			if (idParam != null) {
				HashMap<Integer, Recette> hRecettes = FichierUtil.lireRecettes();
				request.setAttribute("recette", hRecettes.get(Integer.parseInt(idParam)));
			}
			getServletConfig().getServletContext()
				.getRequestDispatcher("/WEB-INF/jsp/formulaireRecette.jsp")
				.forward(request, response);

		} else if ("supprimer".equals(action)) {
			int id = Integer.parseInt(request.getParameter("id"));
			HashMap<Integer, Recette> hRecettes = FichierUtil.lireRecettes();
			hRecettes.remove(id);
			FichierUtil.ecrireRecettes(hRecettes);
			response.sendRedirect(getServletContext().getContextPath() + "/recettes");
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		request.setCharacterEncoding("UTF-8");
		String action      = request.getParameter("action");
		String nom         = request.getParameter("nom");
		String ingredients = request.getParameter("ingredients");
		String description = request.getParameter("description");

		HashMap<Integer, Recette> hRecettes = FichierUtil.lireRecettes();

		if ("modifier".equals(action)) {
			int id = Integer.parseInt(request.getParameter("id"));
			Recette r = hRecettes.get(id);
			r.setNom(nom);
			r.setIngredients(ingredients);
			r.setDescription(description);
		} else {
			// nouvelle recette
			Recette r = new Recette();
			r.setId(FichierUtil.prochainId(hRecettes));
			r.setNom(nom);
			r.setIngredients(ingredients);
			r.setDescription(description);
			hRecettes.put(r.getId(), r);
		}

		FichierUtil.ecrireRecettes(hRecettes);
		response.sendRedirect(getServletContext().getContextPath() + "/recettes");
	}
}
