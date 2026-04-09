package web;

import java.io.IOException;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import metier.FichierUtil;
import metier.Livraison;

/**
 * servlet admin pour configurer les tarifs des livraisons
 * les 3 types sont fixes : surplace, emporte, domicile
 */
@WebServlet("/livraisons")
public class LivraisonServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	public void init() throws ServletException {
		// TODO Auto-generated method stub
		super.init();
		String chemin = getServletContext().getRealPath("/");
		FichierUtil.init(chemin);
		// on nettoie les doublons et on initialise les 3 types
		initialiserLivraisons();
	}

	// nettoie les doublons et garde seulement un de chaque type
	private void initialiserLivraisons() {
		HashMap<Integer, Livraison> hLivraisons = FichierUtil.lireLivraisons();

		// on garde seulement le premier de chaque type
		Livraison surplace = null;
		Livraison emporte  = null;
		Livraison domicile = null;

		for (Livraison l : hLivraisons.values()) {
			if ("surplace".equals(l.getType()) && surplace == null) surplace = l;
			if ("emporte".equals(l.getType())  && emporte  == null) emporte  = l;
			if ("domicile".equals(l.getType()) && domicile == null) domicile = l;
		}

		// on cree les types manquants avec tarif par defaut
		if (surplace == null) {
			surplace = new Livraison();
			surplace.setNom("Sur place");
			surplace.setType("surplace");
			surplace.setTarif(0);
		}
		if (emporte == null) {
			emporte = new Livraison();
			emporte.setNom("Emporte");
			emporte.setType("emporte");
			emporte.setTarif(0);
		}
		if (domicile == null) {
			domicile = new Livraison();
			domicile.setNom("Livraison a domicile");
			domicile.setType("domicile");
			domicile.setTarif(5);
		}

		// on reecrit avec des ids fixes 1 2 3 - sans doublons
		HashMap<Integer, Livraison> hPropre = new HashMap<>();
		surplace.setId(1);
		emporte.setId(2);
		domicile.setId(3);
		hPropre.put(1, surplace);
		hPropre.put(2, emporte);
		hPropre.put(3, domicile);

		FichierUtil.ecrireLivraisons(hPropre);
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		HashMap<Integer, Livraison> hLivraisons = FichierUtil.lireLivraisons();
		request.setAttribute("livraisons", hLivraisons);
		getServletConfig().getServletContext()
			.getRequestDispatcher("/WEB-INF/jsp/livraisons.jsp")
			.forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		request.setCharacterEncoding("UTF-8");
		String action  = request.getParameter("action");
		double tarif   = Double.parseDouble(request.getParameter("tarif"));
		String type    = request.getParameter("type");
		String idParam = request.getParameter("id");

		HashMap<Integer, Livraison> hLivraisons = FichierUtil.lireLivraisons();

		if ("modifier".equals(action) && idParam != null && !idParam.isEmpty()) {
			int id = Integer.parseInt(idParam);
			Livraison l = hLivraisons.get(id);
			if (l != null) {
				// on met a jour seulement le tarif
				l.setTarif(tarif);
			}
		}

		FichierUtil.ecrireLivraisons(hLivraisons);
		response.sendRedirect(getServletContext().getContextPath() + "/livraisons");
	}
}
