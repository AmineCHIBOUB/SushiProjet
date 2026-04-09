package metier;

/**
 * une ligne dans une commande : sushi + quantite
 */
public class CommandeLigne {

	private Sushi sushi;
	private int quantite;

	public CommandeLigne() {
		// TODO Auto-generated constructor stub
	}

	// calcul du sous total de la ligne
	public double getSousTotal() {
		return sushi.getPrix() * quantite;
	}

	public Sushi getSushi() {
		return sushi;
	}
	public void setSushi(Sushi sushi) {
		this.sushi = sushi;
	}
	public int getQuantite() {
		return quantite;
	}
	public void setQuantite(int quantite) {
		this.quantite = quantite;
	}
}
