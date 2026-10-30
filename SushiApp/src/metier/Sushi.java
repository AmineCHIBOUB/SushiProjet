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
	// quantite disponible en stock
	private int stock;
	// en dessous de ce seuil, le plat est signale en stock bas
	private int seuilAlerte;

	// valeurs par defaut pour les plats crees avant la gestion de stock
	public static final int STOCK_DEFAUT = 50;
	public static final int SEUIL_DEFAUT = 5;

	public Sushi() {
		this.stock = STOCK_DEFAUT;
		this.seuilAlerte = SEUIL_DEFAUT;
	}

	// le plat ne peut plus etre commande
	public boolean isEnRupture() {
		return stock <= 0;
	}

	// le stock est bas mais pas encore epuise
	public boolean isStockBas() {
		return stock > 0 && stock <= seuilAlerte;
	}

	// retire une quantite du stock (vente)
	public void retirerStock(int quantite) {
		this.stock = Math.max(0, this.stock - quantite);
	}

	// ajoute une quantite au stock (reapprovisionnement ou annulation)
	public void ajouterStock(int quantite) {
		this.stock += quantite;
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
	public int getStock() {
		return stock;
	}
	public void setStock(int stock) {
		this.stock = stock;
	}
	public int getSeuilAlerte() {
		return seuilAlerte;
	}
	public void setSeuilAlerte(int seuilAlerte) {
		this.seuilAlerte = seuilAlerte;
	}
}
