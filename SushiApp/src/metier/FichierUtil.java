package metier;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;

// classe utilitaire pour lire et ecrire les fichiers txt
// le dossier data est partage entre SushiApp et SushiAdmin
public class FichierUtil {

	// chemin initialise par la servlet
	private static String DOSSIER = null;

	// initialisation avec le chemin reel du serveur
	public static void init(String cheminReel) {
		// chemin 1 : dossier data local dans le webapp (toujours disponible)
		String cheminLocal = cheminReel + "data" + File.separator;
		// chemin 2 : dossier sushi_data partage dans le parent (pour partager entre SushiApp et SushiAdmin)
		File dossierApp = new File(cheminReel);
		String dossierParent = dossierApp.getParentFile().getAbsolutePath();
		String cheminPartage = dossierParent + File.separator + "sushi_data" + File.separator;

		// on regarde d abord si le dossier partage contient des donnees
		if (new File(cheminPartage + "sushis.txt").exists()) {
			// le dossier partage existe et contient des donnees, on l utilise
			DOSSIER = cheminPartage;
		} else {
			// sinon on utilise le dossier local du webapp
			DOSSIER = cheminLocal;
			// on cree aussi le dossier partage et on copie les donnees dedans
			// comme ca les deux webapps partagent les memes donnees
			try {
				new File(cheminPartage).mkdirs();
				String[] fichiers = {"sushis.txt", "recettes.txt", "livraisons.txt", "commandes.txt", "reservations.txt"};
				for (String nom : fichiers) {
					File src = new File(cheminLocal + nom);
					if (src.exists()) {
						// on copie le fichier local vers le dossier partage
						BufferedReader br = new BufferedReader(new FileReader(src));
						PrintWriter pw = new PrintWriter(new FileWriter(cheminPartage + nom));
						String ligne;
						while ((ligne = br.readLine()) != null) {
							pw.println(ligne);
						}
						br.close();
						pw.close();
					}
				}
				// maintenant on utilise le dossier partage
				DOSSIER = cheminPartage;
			} catch (Exception e) {
				// en cas d erreur on reste sur le dossier local
				DOSSIER = cheminLocal;
			}
		}
		new File(DOSSIER).mkdirs();
		System.out.println("[FichierUtil] Dossier data : " + DOSSIER);
	}

	// ---- SUSHIS ----

	// lecture de tous les sushis depuis le fichier txt
	public static HashMap<Integer, Sushi> lireSushis() {
		HashMap<Integer, Sushi> hSushis = new HashMap<>();
		File f = new File(DOSSIER + "sushis.txt");
		if (!f.exists()) return hSushis;
		try {
			BufferedReader br = new BufferedReader(new FileReader(f));
			String ligne;
			while ((ligne = br.readLine()) != null) {
				if (!ligne.trim().isEmpty()) {
					// format : id;nom;description;prix;categorie;image
					String[] parts = ligne.split(";");
					Sushi s = new Sushi();
					s.setId(Integer.parseInt(parts[0]));
					s.setNom(parts[1]);
					s.setDescription(parts[2]);
					s.setPrix(Double.parseDouble(parts[3]));
					s.setCategorie(parts[4]);
					// l image est optionnelle pour la compatibilite avec les anciens fichiers
					s.setImage(parts.length > 5 ? parts[5] : "");
					hSushis.put(s.getId(), s);
				}
			}
			br.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return hSushis;
	}

	// ecriture de tous les sushis dans le fichier txt
	public static void ecrireSushis(HashMap<Integer, Sushi> hSushis) {
		try {
			PrintWriter pw = new PrintWriter(new FileWriter(DOSSIER + "sushis.txt", false));
			for (Sushi s : hSushis.values()) {
				// on ecrit avec le champ image en plus
				pw.println(s.getId() + ";" + s.getNom() + ";" + s.getDescription() + ";" + s.getPrix() + ";" + s.getCategorie() + ";" + s.getImage());
			}
			pw.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// ---- RECETTES ----

	// lecture des recettes
	public static HashMap<Integer, Recette> lireRecettes() {
		HashMap<Integer, Recette> hRecettes = new HashMap<>();
		File f = new File(DOSSIER + "recettes.txt");
		if (!f.exists()) return hRecettes;
		try {
			BufferedReader br = new BufferedReader(new FileReader(f));
			String ligne;
			while ((ligne = br.readLine()) != null) {
				if (!ligne.trim().isEmpty()) {
					// format : id;nom;ingredients;description
					String[] parts = ligne.split(";");
					Recette r = new Recette();
					r.setId(Integer.parseInt(parts[0]));
					r.setNom(parts[1]);
					r.setIngredients(parts[2]);
					r.setDescription(parts[3]);
					hRecettes.put(r.getId(), r);
				}
			}
			br.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return hRecettes;
	}

	// ecriture des recettes
	public static void ecrireRecettes(HashMap<Integer, Recette> hRecettes) {
		try {
			PrintWriter pw = new PrintWriter(new FileWriter(DOSSIER + "recettes.txt", false));
			for (Recette r : hRecettes.values()) {
				pw.println(r.getId() + ";" + r.getNom() + ";" + r.getIngredients() + ";" + r.getDescription());
			}
			pw.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// ---- LIVRAISONS ----

	// lecture des modes de livraison
	public static HashMap<Integer, Livraison> lireLivraisons() {
		HashMap<Integer, Livraison> hLivraisons = new HashMap<>();
		File f = new File(DOSSIER + "livraisons.txt");
		if (!f.exists()) return hLivraisons;
		try {
			BufferedReader br = new BufferedReader(new FileReader(f));
			String ligne;
			while ((ligne = br.readLine()) != null) {
				if (!ligne.trim().isEmpty()) {
					// format : id;nom;tarif;type
					String[] parts = ligne.split(";");
					Livraison l = new Livraison();
					l.setId(Integer.parseInt(parts[0]));
					l.setNom(parts[1]);
					l.setTarif(Double.parseDouble(parts[2]));
					// le type est optionnel pour compatibilite avec les anciens fichiers
					l.setType(parts.length > 3 ? parts[3] : "domicile");
					hLivraisons.put(l.getId(), l);
				}
			}
			br.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return hLivraisons;
	}

	// ecriture des livraisons
	public static void ecrireLivraisons(HashMap<Integer, Livraison> hLivraisons) {
		try {
			PrintWriter pw = new PrintWriter(new FileWriter(DOSSIER + "livraisons.txt", false));
			for (Livraison l : hLivraisons.values()) {
				// format : id;nom;tarif;type
				pw.println(l.getId() + ";" + l.getNom() + ";" + l.getTarif() + ";" + l.getType());
			}
			pw.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// ---- COMMANDES ----

	// lecture des commandes avec les references aux sushis et livraisons
	public static HashMap<Integer, Commande> lireCommandes(HashMap<Integer, Sushi> hSushis, HashMap<Integer, Livraison> hLivraisons) {
		HashMap<Integer, Commande> hCommandes = new HashMap<>();
		File f = new File(DOSSIER + "commandes.txt");
		if (!f.exists()) return hCommandes;
		try {
			BufferedReader br = new BufferedReader(new FileReader(f));
			String ligne;
			while ((ligne = br.readLine()) != null) {
				if (!ligne.trim().isEmpty()) {
					// format : id;client;adresse;statut;idLivraison;idSushi1:qte1,...
					String[] parts = ligne.split(";");
					Commande c = new Commande();
					c.setId(Integer.parseInt(parts[0]));
					c.setClient(parts[1]);
					c.setAdresse(parts[2]);
					c.setStatut(parts[3]);
					int idLiv = Integer.parseInt(parts[4]);
					if (hLivraisons.containsKey(idLiv)) {
						c.setLivraison(hLivraisons.get(idLiv));
					}
					// on lit les lignes de la commande (sushi:quantite)
					if (parts.length > 5 && !parts[5].isEmpty()) {
						for (String item : parts[5].split(",")) {
							String[] lp = item.split(":");
							int idSushi = Integer.parseInt(lp[0]);
							int qte     = Integer.parseInt(lp[1]);
							if (hSushis.containsKey(idSushi)) {
								CommandeLigne cl = new CommandeLigne();
								cl.setSushi(hSushis.get(idSushi));
								cl.setQuantite(qte);
								c.ajouterLigne(cl);
							}
						}
					}
					hCommandes.put(c.getId(), c);
				}
			}
			br.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return hCommandes;
	}

	// ecriture des commandes
	public static void ecrireCommandes(HashMap<Integer, Commande> hCommandes) {
		try {
			PrintWriter pw = new PrintWriter(new FileWriter(DOSSIER + "commandes.txt", false));
			for (Commande c : hCommandes.values()) {
				StringBuilder sb = new StringBuilder();
				sb.append(c.getId()).append(";");
				sb.append(c.getClient()).append(";");
				sb.append(c.getAdresse()).append(";");
				sb.append(c.getStatut()).append(";");
				sb.append(c.getLivraison() != null ? c.getLivraison().getId() : 0).append(";");
				ArrayList<CommandeLigne> lignes = c.getLignes();
				for (int i = 0; i < lignes.size(); i++) {
					if (i > 0) sb.append(",");
					sb.append(lignes.get(i).getSushi().getId()).append(":").append(lignes.get(i).getQuantite());
				}
				pw.println(sb.toString());
			}
			pw.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// ---- RESERVATIONS ----

	// lecture des reservations de table depuis le fichier txt
	public static HashMap<Integer, Reservation> lireReservations() {
		HashMap<Integer, Reservation> hReservations = new HashMap<>();
		File f = new File(DOSSIER + "reservations.txt");
		if (!f.exists()) return hReservations;
		try {
			BufferedReader br = new BufferedReader(new FileReader(f));
			String ligne;
			while ((ligne = br.readLine()) != null) {
				if (!ligne.trim().isEmpty()) {
					// format : id;client;date;heure;nbPersonnes;telephone;statut
					String[] parts = ligne.split(";");
					Reservation r = new Reservation();
					r.setId(Integer.parseInt(parts[0]));
					r.setClient(parts[1]);
					r.setDate(parts[2]);
					r.setHeure(parts[3]);
					r.setNbPersonnes(Integer.parseInt(parts[4]));
					r.setTelephone(parts[5]);
					r.setStatut(parts.length > 6 ? parts[6] : "en attente");
					hReservations.put(r.getId(), r);
				}
			}
			br.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return hReservations;
	}

	// ecriture des reservations dans le fichier txt
	public static void ecrireReservations(HashMap<Integer, Reservation> hReservations) {
		try {
			PrintWriter pw = new PrintWriter(new FileWriter(DOSSIER + "reservations.txt", false));
			for (Reservation r : hReservations.values()) {
				pw.println(r.getId() + ";" + r.getClient() + ";" + r.getDate() + ";" + r.getHeure() + ";" + r.getNbPersonnes() + ";" + r.getTelephone() + ";" + r.getStatut());
			}
			pw.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// trouver le prochain id disponible
	public static int prochainId(HashMap<Integer, ?> hMap) {
		int max = 0;
		for (int id : hMap.keySet()) {
			if (id > max) max = id;
		}
		return max + 1;
	}
}
