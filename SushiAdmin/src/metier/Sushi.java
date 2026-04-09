package metier;

// classe qui represente un sushi du menu
public class Sushi {

	private int id;
	private String nom;
	private String description;
	private double prix;
	private String categorie;
	// url de l image du sushi
	private String image;

	public Sushi() {
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
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public double getPrix() {
		return prix;
	}
	public void setPrix(double prix) {
		this.prix = prix;
	}
	public String getCategorie() {
		return categorie;
	}
	public void setCategorie(String categorie) {
		this.categorie = categorie;
	}
	// getter et setter pour l image
	public String getImage() {
		return image;
	}
	public void setImage(String image) {
		this.image = image;
	}
}
