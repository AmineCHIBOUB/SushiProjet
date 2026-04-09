package metier;

/**
 * classe qui represente un moyen de livraison
 * le type peut etre : surplace, emporte, domicile
 */
public class Livraison {

	private int id;
	private String nom;
	private double tarif;
	// type : surplace, emporte, domicile
	private String type;

	public Livraison() {
		// TODO Auto-generated constructor stub
	}

	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getNom() {
		return nom;
	}
	public void setNom(String nom) {
		this.nom = nom;
	}
	public double getTarif() {
		return tarif;
	}
	public void setTarif(double tarif) {
		this.tarif = tarif;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
}
