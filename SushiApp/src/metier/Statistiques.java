package metier;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

// calcule les indicateurs du tableau de bord a partir des commandes et des sushis
// les commandes annulees ne sont pas comptees dans le chiffre d affaires
public class Statistiques {

	private double chiffreAffaires;
	private double chiffreAffairesJour;
	private int nombreCommandes;
	private int nombreCommandesJour;
	private double panierMoyen;
	private int articlesVendus;
	private LinkedHashMap<String, Integer> commandesParStatut = new LinkedHashMap<>();
	private LinkedHashMap<String, Integer> topSushis = new LinkedHashMap<>();
	private ArrayList<Sushi> alertesStock = new ArrayList<>();

	public Statistiques(Collection<Commande> commandes, Collection<Sushi> sushis, String aujourdhui) {
		HashMap<String, Integer> ventesParSushi = new HashMap<>();

		for (Commande c : commandes) {
			commandesParStatut.merge(c.getStatut(), 1, Integer::sum);
			if (c.isAnnulee()) {
				continue;
			}

			nombreCommandes++;
			chiffreAffaires += c.getTotal();
			articlesVendus += c.getNombreArticles();

			if (aujourdhui.equals(c.getJour())) {
				nombreCommandesJour++;
				chiffreAffairesJour += c.getTotal();
			}

			for (CommandeLigne l : c.getLignes()) {
				ventesParSushi.merge(l.getSushi().getNom(), l.getQuantite(), Integer::sum);
			}
		}

		panierMoyen = nombreCommandes > 0 ? chiffreAffaires / nombreCommandes : 0;

		// les 5 sushis les plus vendus, du plus vendu au moins vendu
		List<Map.Entry<String, Integer>> classement = new ArrayList<>(ventesParSushi.entrySet());
		classement.sort((a, b) -> b.getValue() - a.getValue());
		for (int i = 0; i < Math.min(5, classement.size()); i++) {
			topSushis.put(classement.get(i).getKey(), classement.get(i).getValue());
		}

		// plats en rupture ou sous le seuil d alerte
		for (Sushi s : sushis) {
			if (s.isEnRupture() || s.isStockBas()) {
				alertesStock.add(s);
			}
		}
		alertesStock.sort((a, b) -> a.getStock() - b.getStock());
	}

	public double getChiffreAffaires() {
		return chiffreAffaires;
	}
	public double getChiffreAffairesJour() {
		return chiffreAffairesJour;
	}
	public int getNombreCommandes() {
		return nombreCommandes;
	}
	public int getNombreCommandesJour() {
		return nombreCommandesJour;
	}
	public double getPanierMoyen() {
		return panierMoyen;
	}
	public int getArticlesVendus() {
		return articlesVendus;
	}
	public LinkedHashMap<String, Integer> getCommandesParStatut() {
		return commandesParStatut;
	}
	public LinkedHashMap<String, Integer> getTopSushis() {
		return topSushis;
	}
	public ArrayList<Sushi> getAlertesStock() {
		return alertesStock;
	}
}
