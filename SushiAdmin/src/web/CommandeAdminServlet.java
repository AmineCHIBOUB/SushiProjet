package web;

import java.io.IOException;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import metier.Commande;
import metier.FichierUtil;
import metier.Livraison;
import metier.Sushi;

/**
 * servlet admin pour gerer les commandes des clients
 */
@WebServlet("/commandes")
public class CommandeAdminServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

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
			// lecture de toutes les commandes
			HashMap<Integer, Sushi> hSushis = FichierUtil.lireSushis();
			HashMap<Integer, Livraison> hLivraisons = FichierUtil.lireLivraisons();
			HashMap<Integer, Commande> hCommandes = FichierUtil.lireCommandes(hSushis, hLivraisons);
			request.setAttribute("commandes", hCommandes);
			getServletConfig().getServletContext()
				.getRequestDispatcher("/WEB-INF/jsp/commandes.jsp")
				.forward(request, response);

		} else if ("detail".equals(action)) {
			int id = Integer.parseInt(request.getParameter("id"));
			HashMap<Integer, Sushi> hSushis = FichierUtil.lireSushis();
			HashMap<Integer, Livraison> hLivraisons = FichierUtil.lireLivraisons();
			HashMap<Integer, Commande> hCommandes = FichierUtil.lireCommandes(hSushis, hLivraisons);
			request.setAttribute("commande", hCommandes.get(id));
			getServletConfig().getServletContext()
				.getRequestDispatcher("/WEB-INF/jsp/detailCommande.jsp")
				.forward(request, response);

		} else if ("changerStatut".equals(action)) {
			// changer le statut d une commande
			int id = Integer.parseInt(request.getParameter("id"));
			String statut = request.getParameter("statut");
			HashMap<Integer, Sushi> hSushis = FichierUtil.lireSushis();
			HashMap<Integer, Livraison> hLivraisons = FichierUtil.lireLivraisons();
			HashMap<Integer, Commande> hCommandes = FichierUtil.lireCommandes(hSushis, hLivraisons);
			Commande commande = hCommandes.get(id);
			if (commande != null) {
				commande.setStatut(statut);
			}
			FichierUtil.ecrireCommandes(hCommandes);
			response.sendRedirect(getServletContext().getContextPath() + "/commandes?action=detail&id=" + id);

		} else if ("supprimer".equals(action)) {
			int id = Integer.parseInt(request.getParameter("id"));
			HashMap<Integer, Sushi> hSushis = FichierUtil.lireSushis();
			HashMap<Integer, Livraison> hLivraisons = FichierUtil.lireLivraisons();
			HashMap<Integer, Commande> hCommandes = FichierUtil.lireCommandes(hSushis, hLivraisons);
			hCommandes.remove(id);
			FichierUtil.ecrireCommandes(hCommandes);
			response.sendRedirect(getServletContext().getContextPath() + "/commandes");
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}
}
