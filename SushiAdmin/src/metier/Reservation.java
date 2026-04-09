package metier;

// classe qui represente une reservation de table
// c est une fonctionnalite innovante ajoutee au site
public class Reservation {

	private int id;
	// nom du client qui reserve
	private String client;
	// date de la reservation (format texte jj/mm/aaaa)
	private String date;
	// heure de la reservation (format hh:mm)
	private String heure;
	// nombre de personnes
	private int nbPersonnes;
	// numero de telephone pour confirmer
	private String telephone;
	// statut : confirmee, en attente, annulee
	private String statut;

	public Reservation() {
		// TODO Auto-generated constructor stub
		// par defaut la reservation est en attente
		this.statut = "en attente";
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
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}
	public String getHeure() {
		return heure;
	}
	public void setHeure(String heure) {
		this.heure = heure;
	}
	public int getNbPersonnes() {
		return nbPersonnes;
	}
	public void setNbPersonnes(int nbPersonnes) {
		this.nbPersonnes = nbPersonnes;
	}
	public String getTelephone() {
		return telephone;
	}
	public void setTelephone(String telephone) {
		this.telephone = telephone;
	}
	public String getStatut() {
		return statut;
	}
	public void setStatut(String statut) {
		this.statut = statut;
	}
}
