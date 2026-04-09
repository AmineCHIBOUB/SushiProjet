package service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import metier.Commande;
import metier.CommandeLigne;
import metier.FichierUtil;
import metier.Livraison;
import metier.Recette;
import metier.Sushi;

/**
 * API JSON pour SushiAdmin
 * GET    /api?ressource=sushis            -> liste tous les sushis
 * GET    /api?ressource=sushis&id=1       -> un sushi par id
 * GET    /api?ressource=recettes          -> liste toutes les recettes
 * GET    /api?ressource=livraisons        -> liste toutes les livraisons
 * GET    /api?ressource=commandes         -> liste toutes les commandes
 * POST   /api?ressource=sushis            -> ajouter un sushi (JSON body)
 * POST   /api?ressource=recettes          -> ajouter une recette (JSON body)
 * POST   /api?ressource=livraisons        -> ajouter une livraison (JSON body)
 * DELETE /api?ressource=sushis&id=1       -> supprimer un sushi
 * DELETE /api?ressource=recettes&id=1     -> supprimer une recette
 * DELETE /api?ressource=livraisons&id=1   -> supprimer une livraison
 * DELETE /api?ressource=commandes&id=1    -> supprimer une commande
 */
@WebServlet("/api")
public class ApiAdminServlet extends HttpServlet {
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
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.setHeader("Access-Control-Allow-Origin", "*");

		PrintWriter out = response.getWriter();
		String ressource = request.getParameter("ressource");
		String idParam   = request.getParameter("id");

		if ("sushis".equals(ressource)) {
			HashMap<Integer, Sushi> hSushis = FichierUtil.lireSushis();
			if (idParam != null) {
				Sushi s = hSushis.get(Integer.parseInt(idParam));
				out.print(s != null ? sushiEnJson(s) : "{\"erreur\":\"sushi non trouve\"}");
			} else {
				out.print("[");
				int i = 0;
				for (Sushi s : hSushis.values()) {
					if (i > 0) out.print(",");
					out.print(sushiEnJson(s));
					i++;
				}
				out.print("]");
			}

		} else if ("recettes".equals(ressource)) {
			HashMap<Integer, Recette> hRecettes = FichierUtil.lireRecettes();
			if (idParam != null) {
				Recette r = hRecettes.get(Integer.parseInt(idParam));
				out.print(r != null ? recetteEnJson(r) : "{\"erreur\":\"recette non trouvee\"}");
			} else {
				out.print("[");
				int i = 0;
				for (Recette r : hRecettes.values()) {
					if (i > 0) out.print(",");
					out.print(recetteEnJson(r));
					i++;
				}
				out.print("]");
			}

		} else if ("livraisons".equals(ressource)) {
			HashMap<Integer, Livraison> hLivraisons = FichierUtil.lireLivraisons();
			if (idParam != null) {
				Livraison l = hLivraisons.get(Integer.parseInt(idParam));
				out.print(l != null ? livraisonEnJson(l) : "{\"erreur\":\"livraison non trouvee\"}");
			} else {
				out.print("[");
				int i = 0;
				for (Livraison l : hLivraisons.values()) {
					if (i > 0) out.print(",");
					out.print(livraisonEnJson(l));
					i++;
				}
				out.print("]");
			}

		} else if ("commandes".equals(ressource)) {
			HashMap<Integer, Sushi> hSushis = FichierUtil.lireSushis();
			HashMap<Integer, Livraison> hLivraisons = FichierUtil.lireLivraisons();
			HashMap<Integer, Commande> hCommandes = FichierUtil.lireCommandes(hSushis, hLivraisons);
			if (idParam != null) {
				Commande c = hCommandes.get(Integer.parseInt(idParam));
				out.print(c != null ? commandeEnJson(c) : "{\"erreur\":\"commande non trouvee\"}");
			} else {
				out.print("[");
				int i = 0;
				for (Commande c : hCommandes.values()) {
					if (i > 0) out.print(",");
					out.print(commandeEnJson(c));
					i++;
				}
				out.print("]");
			}

		} else {
			out.print("{\"erreur\":\"ressource inconnue\"}");
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 * POST /api?ressource=sushis
	 * body JSON : {"nom":"salmon","description":"...","prix":8.5,"categorie":"nigiri"}
	 * POST /api?ressource=recettes
	 * body JSON : {"nom":"recette","ingredients":"...","description":"..."}
	 * POST /api?ressource=livraisons
	 * body JSON : {"nom":"express","tarif":5.0}
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.setHeader("Access-Control-Allow-Origin", "*");

		PrintWriter out = response.getWriter();
		String ressource = request.getParameter("ressource");

		// lecture du body JSON
		StringBuilder sb = new StringBuilder();
		BufferedReader br = request.getReader();
		String line;
		while ((line = br.readLine()) != null) {
			sb.append(line);
		}
		String json = sb.toString();

		try {
			if ("sushis".equals(ressource)) {
				String nom         = extraireValeur(json, "nom");
				String description = extraireValeur(json, "description");
				double prix        = Double.parseDouble(extraireValeur(json, "prix"));
				String categorie   = extraireValeur(json, "categorie");

				HashMap<Integer, Sushi> hSushis = FichierUtil.lireSushis();
				Sushi sushi = new Sushi();
				sushi.setId(FichierUtil.prochainId(hSushis));
				sushi.setNom(nom);
				sushi.setDescription(description);
				sushi.setPrix(prix);
				sushi.setCategorie(categorie);
				hSushis.put(sushi.getId(), sushi);
				FichierUtil.ecrireSushis(hSushis);
				response.setStatus(201);
				out.print(sushiEnJson(sushi));

			} else if ("recettes".equals(ressource)) {
				String nom         = extraireValeur(json, "nom");
				String ingredients = extraireValeur(json, "ingredients");
				String description = extraireValeur(json, "description");

				HashMap<Integer, Recette> hRecettes = FichierUtil.lireRecettes();
				Recette r = new Recette();
				r.setId(FichierUtil.prochainId(hRecettes));
				r.setNom(nom);
				r.setIngredients(ingredients);
				r.setDescription(description);
				hRecettes.put(r.getId(), r);
				FichierUtil.ecrireRecettes(hRecettes);
				response.setStatus(201);
				out.print(recetteEnJson(r));

			} else if ("livraisons".equals(ressource)) {
				String nom   = extraireValeur(json, "nom");
				double tarif = Double.parseDouble(extraireValeur(json, "tarif"));

				HashMap<Integer, Livraison> hLivraisons = FichierUtil.lireLivraisons();
				Livraison l = new Livraison();
				l.setId(FichierUtil.prochainId(hLivraisons));
				l.setNom(nom);
				l.setTarif(tarif);
				hLivraisons.put(l.getId(), l);
				FichierUtil.ecrireLivraisons(hLivraisons);
				response.setStatus(201);
				out.print(livraisonEnJson(l));

			} else {
				response.setStatus(400);
				out.print("{\"erreur\":\"POST non supporte pour cette ressource\"}");
			}

		} catch (Exception e) {
			response.setStatus(400);
			out.print("{\"erreur\":\"format JSON invalide\"}");
			e.printStackTrace();
		}
	}

	/**
	 * @see HttpServlet#doDelete(HttpServletRequest request, HttpServletResponse response)
	 * DELETE /api?ressource=sushis&id=1
	 * DELETE /api?ressource=recettes&id=1
	 * DELETE /api?ressource=livraisons&id=1
	 * DELETE /api?ressource=commandes&id=1
	 */
	protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.setHeader("Access-Control-Allow-Origin", "*");

		PrintWriter out = response.getWriter();
		String ressource = request.getParameter("ressource");
		String idParam   = request.getParameter("id");

		if (idParam == null) {
			response.setStatus(400);
			out.print("{\"erreur\":\"id manquant\"}");
			return;
		}

		int id = Integer.parseInt(idParam);

		if ("sushis".equals(ressource)) {
			HashMap<Integer, Sushi> hSushis = FichierUtil.lireSushis();
			if (hSushis.containsKey(id)) {
				hSushis.remove(id);
				FichierUtil.ecrireSushis(hSushis);
				out.print("{\"message\":\"sushi supprime\"}");
			} else {
				response.setStatus(404);
				out.print("{\"erreur\":\"sushi non trouve\"}");
			}

		} else if ("recettes".equals(ressource)) {
			HashMap<Integer, Recette> hRecettes = FichierUtil.lireRecettes();
			if (hRecettes.containsKey(id)) {
				hRecettes.remove(id);
				FichierUtil.ecrireRecettes(hRecettes);
				out.print("{\"message\":\"recette supprimee\"}");
			} else {
				response.setStatus(404);
				out.print("{\"erreur\":\"recette non trouvee\"}");
			}

		} else if ("livraisons".equals(ressource)) {
			HashMap<Integer, Livraison> hLivraisons = FichierUtil.lireLivraisons();
			if (hLivraisons.containsKey(id)) {
				hLivraisons.remove(id);
				FichierUtil.ecrireLivraisons(hLivraisons);
				out.print("{\"message\":\"livraison supprimee\"}");
			} else {
				response.setStatus(404);
				out.print("{\"erreur\":\"livraison non trouvee\"}");
			}

		} else if ("commandes".equals(ressource)) {
			HashMap<Integer, Sushi> hSushis = FichierUtil.lireSushis();
			HashMap<Integer, Livraison> hLivraisons = FichierUtil.lireLivraisons();
			HashMap<Integer, Commande> hCommandes = FichierUtil.lireCommandes(hSushis, hLivraisons);
			if (hCommandes.containsKey(id)) {
				hCommandes.remove(id);
				FichierUtil.ecrireCommandes(hCommandes);
				out.print("{\"message\":\"commande supprimee\"}");
			} else {
				response.setStatus(404);
				out.print("{\"erreur\":\"commande non trouvee\"}");
			}

		} else {
			response.setStatus(400);
			out.print("{\"erreur\":\"ressource inconnue\"}");
		}
	}

	// extrait une valeur depuis un json simple
	private String extraireValeur(String json, String cle) {
		String pattern = "\"" + cle + "\"";
		int idx = json.indexOf(pattern);
		if (idx == -1) return "";
		int debut = json.indexOf(":", idx) + 1;
		while (debut < json.length() && json.charAt(debut) == ' ') debut++;
		if (json.charAt(debut) == '"') {
			int fin = json.indexOf("\"", debut + 1);
			return json.substring(debut + 1, fin);
		} else {
			int fin = debut;
			while (fin < json.length() && (Character.isDigit(json.charAt(fin)) || json.charAt(fin) == '.')) fin++;
			return json.substring(debut, fin);
		}
	}

	// convertit un sushi en json
	private String sushiEnJson(Sushi s) {
		return "{\"id\":" + s.getId()
			+ ",\"nom\":\"" + s.getNom() + "\""
			+ ",\"description\":\"" + s.getDescription() + "\""
			+ ",\"prix\":" + s.getPrix()
			+ ",\"categorie\":\"" + s.getCategorie() + "\""
				+ ",\"image\":\"" + s.getImage() + "\"}";
	}

	// convertit une recette en json
	private String recetteEnJson(Recette r) {
		return "{\"id\":" + r.getId()
			+ ",\"nom\":\"" + r.getNom() + "\""
			+ ",\"ingredients\":\"" + r.getIngredients() + "\""
			+ ",\"description\":\"" + r.getDescription() + "\"}";
	}

	// convertit une livraison en json
	private String livraisonEnJson(Livraison l) {
		return "{\"id\":" + l.getId()
			+ ",\"nom\":\"" + l.getNom() + "\""
			+ ",\"tarif\":" + l.getTarif() + "}";
	}

	// convertit une commande en json
	private String commandeEnJson(Commande c) {
		StringBuilder sb = new StringBuilder();
		sb.append("{\"id\":").append(c.getId())
		  .append(",\"client\":\"").append(c.getClient()).append("\"")
		  .append(",\"adresse\":\"").append(c.getAdresse()).append("\"")
		  .append(",\"statut\":\"").append(c.getStatut()).append("\"")
		  .append(",\"total\":").append(c.getTotal())
		  .append(",\"lignes\":[");
		ArrayList<CommandeLigne> lignes = c.getLignes();
		for (int i = 0; i < lignes.size(); i++) {
			if (i > 0) sb.append(",");
			CommandeLigne l = lignes.get(i);
			sb.append("{\"idSushi\":").append(l.getSushi().getId())
			  .append(",\"sushi\":\"").append(l.getSushi().getNom()).append("\"")
			  .append(",\"quantite\":").append(l.getQuantite())
			  .append(",\"sousTotal\":").append(l.getSousTotal()).append("}");
		}
		sb.append("]}");
		return sb.toString();
	}
}
