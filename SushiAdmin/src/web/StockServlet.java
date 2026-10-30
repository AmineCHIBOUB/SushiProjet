package web;

import java.io.IOException;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import metier.FichierUtil;
import metier.Sushi;

/**
 * servlet admin de gestion des stocks : consultation, reapprovisionnement et seuils d alerte
 */
@WebServlet("/stocks")
public class StockServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setAttribute("sushis", FichierUtil.lireSushis());
		getServletConfig().getServletContext()
			.getRequestDispatcher("/WEB-INF/jsp/stocks.jsp")
			.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		HashMap<Integer, Sushi> hSushis = FichierUtil.lireSushis();

		int id = Integer.parseInt(request.getParameter("id"));
		Sushi sushi = hSushis.get(id);

		if (sushi != null) {
			String action = request.getParameter("action");

			if ("reapprovisionner".equals(action)) {
				// entree en stock : on ajoute la quantite recue
				int quantite = Integer.parseInt(request.getParameter("quantite"));
				if (quantite > 0) {
					sushi.ajouterStock(quantite);
				}
			} else if ("seuil".equals(action)) {
				// modification du seuil d alerte
				int seuil = Integer.parseInt(request.getParameter("seuil"));
				if (seuil >= 0) {
					sushi.setSeuilAlerte(seuil);
				}
			}
			FichierUtil.ecrireSushis(hSushis);
		}

		response.sendRedirect(getServletContext().getContextPath() + "/stocks");
	}
}
