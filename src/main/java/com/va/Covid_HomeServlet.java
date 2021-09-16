package com.va;

import java.io.IOException;
import java.sql.Timestamp;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.va.DbManager;

import java.util.ArrayList;
import java.util.List;

/**
 * Servlet implementation class Covid_HomeServlet
 */
@WebServlet("/Covid_HomeServlet")
public class Covid_HomeServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Covid_HomeServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	public void init() throws ServletException {

	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/WEB-INF/jsp/Covid19-Home.jsp");
		dispatcher.forward(request, response);

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		int randomId = 0;
		List randomizedList = new ArrayList();
		String treatment = "";
		String treatmentValue = "";
		HttpSession session = request.getSession();
		UserBean userBean = new UserBean();
		String firstName = request.getParameter("firstName");
		String lastName = request.getParameter("lastName");
		String ssnNumber = request.getParameter("ssnNumber");
		String dateOfBirth = request.getParameter("dateOfBirth");
		String site = request.getParameter("siteName");
		try {
			randomizedList = DbManager.getRandomizedId();
			if (randomizedList != null && !randomizedList.isEmpty()) {
				randomId = Integer.parseInt(randomizedList.get(0).toString());
				treatment = randomizedList.get(1).toString();
				if (treatment.equalsIgnoreCase("Active")) {
					treatmentValue = "This patient has been randomized to active therapy. Please order investigational SARILUMAB for this patient from the Pharmacy Ordering Menu";
				} else if (treatment.equalsIgnoreCase("SOC")) {
					treatmentValue = "This patient had been randomized to standard of care therapy. Please order according to clinical care guidelines";
				}
			}

			Timestamp timestamp = new Timestamp(System.currentTimeMillis());
			userBean.setFirstName(firstName);
			userBean.setLastName(lastName);
			userBean.setSsn(ssnNumber);
			userBean.setDateOfBirth(dateOfBirth);
			userBean.setSite(site);
			userBean.setRandomNumber(randomId);
			userBean.setTreatment(treatment);
			userBean.setTreatmentValue(treatmentValue);
			userBean.setRandomizedDateTime(timestamp);

			DbManager.updateRandomizationTable(userBean);

		} catch (Exception e) {
			e.printStackTrace();
		}

		session.setAttribute("UsrBean", userBean);
		session.setAttribute("randomized", "randomized");

		if (randomId != 0) {
			try {
				DbManager.SaveUserInDB(userBean);
			} catch (Exception e) {
				e.printStackTrace();
			}
		} 
		RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/WEB-INF/jsp/Covid19-Home.jsp");
		dispatcher.forward(request, response);

	}

}
