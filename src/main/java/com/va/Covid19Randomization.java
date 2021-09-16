package com.va;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.NoSuchFileException;
import java.sql.SQLException;
import java.sql.Timestamp;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.va.DbManager;

import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.logging.FileHandler;
import java.util.logging.Logger;
import java.util.logging.LogRecord;
import java.util.logging.Formatter;
import java.util.logging.Handler;
import javax.mail.*; 
import javax.mail.internet.*; 
import javax.activation.*; 
import javax.mail.Session; 
import javax.mail.Transport;

/**
 * Servlet implementation class Covid_HomeServlet
 */

public class Covid19Randomization extends HttpServlet {

	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Covid19Randomization() {
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
		System.out.println("inside doget");
		RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/Covid19-Home.jsp");
		dispatcher.forward(request, response);

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.println("inside dopost");
		int randomId = 0;
		List randomizedList = new ArrayList();
		String treatment = "";
		String treatmentValue = "";
		int ssnCount = 0;
		Timestamp timestamp = null;
		String message = "";
		UserBean userBean = new UserBean();
		String firstName = request.getParameter("firstName");
		String lastName = request.getParameter("lastName");
		String ssnNumber = request.getParameter("ssnNumber");
		String dateOfBirth = request.getParameter("dateOfBirth");
		String site = request.getParameter("siteName");
		String userId = request.getHeader("userid");
		FileHandler fileHandler = null;
		MyFormatter formatter = new MyFormatter();
		Logger logger = Logger.getLogger(Covid19Randomization.class.getName());
		logger.setUseParentHandlers(false);
		String randomizedLogFileData = "";
		int order = 0;
		String[] emailAddresses = null;
		try {
			ssnCount = DbManager.getDuplicateSSN(ssnNumber);
			userBean.setFirstName(firstName);
			userBean.setLastName(lastName);
			userBean.setSsn(ssnNumber);
			userBean.setDateOfBirth(dateOfBirth);
			userBean.setSite(site);
			request.setAttribute("UsrBean", userBean);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		if (ssnCount != 0) {
			message = "Duplicate SSN, unable to randomize";
			request.setAttribute("duplicatemessage", message);
		}
		if (ssnCount == 0) {
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
			} catch (SQLException e) {
				e.printStackTrace();
			}
			request.setAttribute("randomized", "randomized");
			if (randomId != 0) {
				try {
					userBean.setRandomNumber(randomId);
					userBean.setTreatment(treatment);
					userBean.setTreatmentValue(treatmentValue);
					userBean.setUserId(userId);
					timestamp = DbManager.updateRandomizationTable(userBean);
					userBean.setRandomizedDateTime(timestamp);
					DbManager.saveRandomizationInfoToAudit(userBean);
					DbManager.SaveUserInDB(userBean);
					DbManager.SaveUserInPatientAuditDB(userBean);
					order = DbManager.getOrderNumber(randomId);
					randomizedLogFileData = "Randomization done. " + "UserId: " + userBean.getUserId() + " Last Order: " + order + " RandomizedDateTime: " + timestamp;
					emailAddresses = DbManager.getRecipientsEmails();
				} catch (SQLException e) {
					e.printStackTrace();
				} catch (ClassNotFoundException e) {
					e.printStackTrace();
				}
					sendEmail(randomizedLogFileData,emailAddresses);
				try {
					//test tomcat server
//				    fileHandler = new FileHandler("C:/Tomcat9_local/logs/Randomization.log", true);
				    //production tomcat server
				    fileHandler = new FileHandler("C:/Tomcat_9_local/logs/Randomization.log", true);
					fileHandler.setFormatter(formatter);
					logger.addHandler(fileHandler);
					logger.info(randomizedLogFileData);
					fileHandler.close();
				} catch (NoSuchFileException e) {
					e.printStackTrace();
				} catch (SecurityException e) {
					e.printStackTrace();
				} catch (FileNotFoundException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				} 
				}
		}
//		RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/WEB-INF/jsp/Covid19-Home.jsp");
		RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/Covid19-Home.jsp");
		dispatcher.forward(request, response);
//		response.sendRedirect(request.getContextPath() + "/Covid19Randomization");
	}

	public void sendEmail(String randomizedLogFileData, String[] emailAddresses) {
		// email ID of Recipient.
		String host = "smtp.va.gov";
		/*
		 * Initialize the JavaMail Session.
		 */
		Properties props = System.getProperties();
		props.put("mail.smtp.host", host);
		props.put("mail.debug", "true");
		// creating session object to get properties
		try {
			// Get a Session object
			Session session = Session.getInstance(props);
			/*
			 * Construct the message and send it.
			 */
			Message msg = new MimeMessage(session);
			msg.setFrom(new InternetAddress("do_not_reply@va.gov"));
			InternetAddress[] toAddress = new InternetAddress[emailAddresses.length];
	        // To get the array of addresses
	        for (int i = 0; i < emailAddresses.length; i++) {
	            toAddress[i] = new InternetAddress(emailAddresses[i]);
	        }
	        for (int i = 0; i < toAddress.length; i++) {
	            msg.addRecipient(Message.RecipientType.TO, toAddress[i]);
	        }
			msg.setSubject("New Patient Randomized");
			// If the desired charset is known, you can use
			msg.setText(randomizedLogFileData);
			// send the thing off
			Transport.send(msg);
			System.out.println("\nMail was sent successfully.");
		} catch (MessagingException ex) {
			ex.printStackTrace();
			System.out.println("\nThere was a problem in sending email.");
		}
	}
	}

class MyFormatter extends Formatter {
	public String format(LogRecord record) {
		StringBuilder builder = new StringBuilder(1000);
		builder.append(formatMessage(record));
		builder.append(System.lineSeparator());
		return builder.toString();
	}
	public String getHead(Handler h) {
		return super.getHead(h);
	}
	public String getTail(Handler h) {
		return super.getTail(h);
	}
}

