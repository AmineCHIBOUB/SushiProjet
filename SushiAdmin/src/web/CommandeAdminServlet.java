package web;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Locale;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import metier.Commande;
import metier.CommandeLigne;
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
				// une commande annulee rend ses plats au stock (une seule fois)
				if (Commande.STATUT_ANNULEE.equals(statut) && !commande.isAnnulee()) {
					for (CommandeLigne ligne : commande.getLignes()) {
						ligne.getSushi().ajouterStock(ligne.getQuantite());
					}
					FichierUtil.ecrireSushis(hSushis);
				}
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

		} else if ("facture".equals(action)) {
			// facture imprimable d une commande
			int id = Integer.parseInt(request.getParameter("id"));
			HashMap<Integer, Sushi> hSushis = FichierUtil.lireSushis();
			HashMap<Integer, Livraison> hLivraisons = FichierUtil.lireLivraisons();
			HashMap<Integer, Commande> hCommandes = FichierUtil.lireCommandes(hSushis, hLivraisons);
			request.setAttribute("commande", hCommandes.get(id));
			getServletConfig().getServletContext()
				.getRequestDispatcher("/WEB-INF/jsp/facture.jsp")
				.forward(request, response);

		} else if ("export".equals(action)) {
			// export de toutes les commandes au format CSV (ouvrable dans Excel)
			HashMap<Integer, Sushi> hSushis = FichierUtil.lireSushis();
			HashMap<Integer, Livraison> hLivraisons = FichierUtil.lireLivraisons();
			HashMap<Integer, Commande> hCommandes = FichierUtil.lireCommandes(hSushis, hLivraisons);

			response.setContentType("text/csv; charset=UTF-8");
			response.setHeader("Content-Disposition", "attachment; filename=\"commandes.csv\"");
			PrintWriter out = response.getWriter();
			// BOM pour qu Excel reconnaisse l UTF-8 (accents)
			out.write('﻿');
			out.println("Facture;Date;Client;Adresse;Livraison;Articles;Total HT;TVA;Total TTC;Statut");
			for (Commande c : hCommandes.values()) {
				out.println(String.join(";",
						c.getNumeroFacture(),
						c.getDate(),
						csv(c.getClient()),
						csv(c.getAdresse()),
						c.getLivraison() != null ? csv(c.getLivraison().getNom()) : "",
						String.valueOf(c.getNombreArticles()),
						montant(c.getTotalHT()),
						montant(c.getMontantTVA()),
						montant(c.getTotal()),
						c.getStatut()));
			}
			out.flush();
		}
	}

	// montant au format francais pour Excel (virgule decimale)
	private static String montant(double valeur) {
		return String.format(Locale.FRANCE, "%.2f", valeur);
	}

	// protege une valeur qui contiendrait un point-virgule ou des guillemets
	private static String csv(String valeur) {
		if (valeur == null) {
			return "";
		}
		return "\"" + valeur.replace("\"", "\"\"") + "\"";
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}
}
