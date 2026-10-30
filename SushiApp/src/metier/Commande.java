package metier;

import java.util.ArrayList;

/**
 * classe qui represente une commande d un client
 */
public class Commande {

	private int id;
	private String client;
	private String adresse;
	private String statut;
	private Livraison livraison;
	private ArrayList<CommandeLigne> lignes;
	// date de la commande au format "yyyy-MM-dd HH:mm"
	private String date;

	// taux de TVA de la restauration (vente a consommer ou a emporter)
	public static final double TAUX_TVA = 0.10;
	public static final String STATUT_ANNULEE = "annulee";

	public Commande() {
		// statut par defaut
		this.statut = "en attente";
		this.lignes = new ArrayList<>();
		this.date = "";
	}

	// les prix affiches sont TTC : on en deduit le montant HT
	public double getTotalHT() {
		return getTotal() / (1 + TAUX_TVA);
	}

	public double getMontantTVA() {
		return getTotal() - getTotalHT();
	}

	// numero de facture lisible, ex : FAC-2026-0007
	public String getNumeroFacture() {
		String annee = (date != null && date.length() >= 4) ? date.substring(0, 4) : "0000";
		return String.format("FAC-%s-%04d", annee, id);
	}

	// jour de la commande, ex : 2026-10-30
	public String getJour() {
		return (date != null && date.length() >= 10) ? date.substring(0, 10) : "";
	}

	public boolean isAnnulee() {
		return STATUT_ANNULEE.equals(statut);
	}

	// nombre total d articles de la commande
	public int getNombreArticles() {
		int nb = 0;
		for (CommandeLigne l : lignes) {
			nb += l.getQuantite();
		}
		return nb;
	}

	// ajouter une ligne a la commande
	public void ajouterLigne(CommandeLigne ligne) {
		lignes.add(ligne);
	}

	// calcul du total avec les frais de livraison
	public double getTotal() {
		double total = 0;
		for (CommandeLigne l : lignes) {
			total += l.getSousTotal();
		}
		if (livraison != null) {
			total += livraison.getTarif();
		}
		return total;
	}

	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getClient() {
		return client;
	}
	public void setClient(String client) {
		this.client = client;
	}
	public String getAdresse() {
		return adresse;
	}
	public void setAdresse(String adresse) {
		this.adresse = adresse;
	}
	public String getStatut() {
		return statut;
	}
	public void setStatut(String statut) {
		this.statut = statut;
	}
	public Livraison getLivraison() {
		return livraison;
	}
	public void setLivraison(Livraison livraison) {
		this.livraison = livraison;
	}
	public ArrayList<CommandeLigne> getLignes() {
		return lignes;
	}
	public void setLignes(ArrayList<CommandeLigne> lignes) {
		this.lignes = lignes;
	}
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}
}
