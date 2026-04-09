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

	public Commande() {
		// statut par defaut
		this.statut = "en attente";
		this.lignes = new ArrayList<>();
		// TODO Auto-generated constructor stub
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
}
