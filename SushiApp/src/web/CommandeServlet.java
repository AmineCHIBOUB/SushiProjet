package web;

import java.io.IOException;
import java.net.URLEncoder;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Enumeration;
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
import metier.Sushi;

// servlet qui gere les commandes du cote client
// liste, detail, et passage d une nouvelle commande
@WebServlet("/commandes")
public class CommandeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	// format de la date enregistree avec chaque commande
	private static final DateTimeFormatter FORMAT_DATE = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

	// traitement des requetes GET (liste ou detail)
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// on recupere l action (liste par defaut)
		String action = request.getParameter("action");
		if (action == null) {
			action = "liste";
		}

		// affichage de la liste des commandes
		if ("liste".equals(action)) {
			// on charge toutes les donnees necessaires
			HashMap<Integer, Sushi>     hSushis     = FichierUtil.lireSushis();
			HashMap<Integer, Livraison> hLivraisons = FichierUtil.lireLivraisons();
			HashMap<Integer, Commande>  hCommandes  = FichierUtil.lireCommandes(hSushis, hLivraisons);

			// on peut filtrer par client si le parametre est fourni
			String client = request.getParameter("client");
			if (client != null && !client.isEmpty()) {
				// on cree une nouvelle map avec seulement les commandes du client
				HashMap<Integer, Commande> hFiltre = new HashMap<>();
				for (Commande c : hCommandes.values()) {
					if (client.equalsIgnoreCase(c.getClient())) {
						hFiltre.put(c.getId(), c);
					}
				}
				request.setAttribute("commandes", hFiltre);
				request.setAttribute("clientFiltre", client);
			} else {
				// sinon on affiche toutes les commandes
				request.setAttribute("commandes", hCommandes);
			}

			// forward vers la liste des commandes
			getServletConfig().getServletContext()
				.getRequestDispatcher("/WEB-INF/jsp/mesCommandes.jsp")
				.forward(request, response);

		// affichage du detail d une commande
		} else if ("detail".equals(action)) {
			int id = Integer.parseInt(request.getParameter("id"));

			// on charge les donnees et on recupere la commande par son id
			HashMap<Integer, Sushi>     hSushis     = FichierUtil.lireSushis();
			HashMap<Integer, Livraison> hLivraisons = FichierUtil.lireLivraisons();
			HashMap<Integer, Commande>  hCommandes  = FichierUtil.lireCommandes(hSushis, hLivraisons);

			// on passe la commande trouvee a la JSP
			request.setAttribute("commande", hCommandes.get(id));

			getServletConfig().getServletContext()
				.getRequestDispatcher("/WEB-INF/jsp/detailCommande.jsp")
				.forward(request, response);

		// facture imprimable d une commande
		} else if ("facture".equals(action)) {
			int id = Integer.parseInt(request.getParameter("id"));
			HashMap<Integer, Sushi>     hSushis     = FichierUtil.lireSushis();
			HashMap<Integer, Livraison> hLivraisons = FichierUtil.lireLivraisons();
			HashMap<Integer, Commande>  hCommandes  = FichierUtil.lireCommandes(hSushis, hLivraisons);

			request.setAttribute("commande", hCommandes.get(id));

			getServletConfig().getServletContext()
				.getRequestDispatcher("/WEB-INF/jsp/facture.jsp")
				.forward(request, response);
		}
	}

	// traitement des requetes POST (passage d une nouvelle commande)
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// on force l encodage UTF-8 pour les accents
		request.setCharacterEncoding("UTF-8");

		String action = request.getParameter("action");

		// creation d une nouvelle commande
		if ("passer".equals(action)) {
			// on recupere les infos du client
			String client  = request.getParameter("client");
			String adresse = request.getParameter("adresse");
			String livParam = request.getParameter("livraison");

			// on charge les donnees existantes
			HashMap<Integer, Sushi>     hSushis     = FichierUtil.lireSushis();
			HashMap<Integer, Livraison> hLivraisons = FichierUtil.lireLivraisons();
			HashMap<Integer, Commande>  hCommandes  = FichierUtil.lireCommandes(hSushis, hLivraisons);

			// creation de la nouvelle commande
			Commande commande = new Commande();
			commande.setId(FichierUtil.prochainId(hCommandes));
			commande.setClient(client);
			commande.setAdresse(adresse != null ? adresse : "");
			commande.setStatut("en attente");

			// on associe le mode de livraison choisi
			if (livParam != null && !livParam.isEmpty()) {
				int idLiv = Integer.parseInt(livParam);
				if (hLivraisons.containsKey(idLiv)) {
					commande.setLivraison(hLivraisons.get(idLiv));
				}
			}

			// on parcourt tous les parametres pour trouver les quantites
			// les noms de parametres sont de la forme "qte_<idSushi>"
			Enumeration<String> params = request.getParameterNames();
			while (params.hasMoreElements()) {
				String nomParam = params.nextElement();
				if (nomParam.startsWith("qte_")) {
					// on extrait l id du sushi depuis le nom du parametre
					int idSushi = Integer.parseInt(nomParam.substring(4));
					int qte     = Integer.parseInt(request.getParameter(nomParam));

					// on n ajoute la ligne que si la quantite est superieure a 0
					if (qte > 0 && hSushis.containsKey(idSushi)) {
						CommandeLigne ligne = new CommandeLigne();
						ligne.setSushi(hSushis.get(idSushi));
						ligne.setQuantite(qte);
						commande.ajouterLigne(ligne);
					}
				}
			}

			// on verifie que le stock suffit pour chaque plat avant d enregistrer
			for (CommandeLigne ligne : commande.getLignes()) {
				Sushi sushi = ligne.getSushi();
				if (ligne.getQuantite() > sushi.getStock()) {
					response.sendRedirect(getServletContext().getContextPath()
							+ "/sushis?action=commander&erreur=stock&plat="
							+ URLEncoder.encode(sushi.getNom(), "UTF-8"));
					return;
				}
			}

			// on sauvegarde la commande seulement si elle contient au moins une ligne
			if (!commande.getLignes().isEmpty()) {
				commande.setDate(LocalDateTime.now().format(FORMAT_DATE));
				hCommandes.put(commande.getId(), commande);
				FichierUtil.ecrireCommandes(hCommandes);

				// sortie de stock des plats commandes
				for (CommandeLigne ligne : commande.getLignes()) {
					ligne.getSushi().retirerStock(ligne.getQuantite());
				}
				FichierUtil.ecrireSushis(hSushis);
			}

			// redirection vers la liste des commandes apres confirmation
			response.sendRedirect(getServletContext().getContextPath() + "/commandes?action=liste");
		}
	}
}
