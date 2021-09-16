package com.va;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.ResourceBundle;
import com.va.ConnectionManager;

public class DbManager {

	public DbManager() {
	}

	public static List getRandomizedId() throws SQLException {
		ResourceBundle rb = ResourceBundle.getBundle("sql");
		Connection conn = ConnectionManager.getInstance().getConnection();
		int randomNumber = 0;
		String treatment = "";
		List listFromRandomizationTable = new ArrayList();
		try {

			PreparedStatement prepStmt = conn.prepareStatement(rb.getString("selectRandomizedData"));
			ResultSet rs = prepStmt.executeQuery();

			if (rs != null) {
				while (rs.next()) {
					randomNumber = rs.getInt("RandomizedID");
					treatment = rs.getString("Treatment");
				}
			}
			listFromRandomizationTable.add(randomNumber);
			listFromRandomizationTable.add(treatment);
			rs.close();
			prepStmt.close();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (conn != null) {
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
				conn = null;
			}
		}
		return listFromRandomizationTable;
	}
	public static String[] getRecipientsEmails() throws SQLException {
		ResourceBundle rb = ResourceBundle.getBundle("sql");
		Connection conn = ConnectionManager.getInstance().getConnection();
		String emailAddress = "";
		List<String> toAddresses = new ArrayList<String>();
		String emailAddresses[] = null;
		try {

			PreparedStatement prepStmt = conn.prepareStatement(rb.getString("selectRecipientEmails"));
			ResultSet rs = prepStmt.executeQuery();

			if (rs != null) {
				while (rs.next()) {
					emailAddress = rs.getString("Email");
					toAddresses.add(emailAddress);
				}
			}
			emailAddresses = new String[toAddresses.size()];
			/*ArrayList to Array Conversion */
			for(int i=0;i<toAddresses.size();i++){
				emailAddresses[i] = toAddresses.get(i);
			}
			rs.close();
			prepStmt.close();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (conn != null) {
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
				conn = null;
			}
		}
		return emailAddresses;
	}
	public static int getOrderNumber(int randomId) throws SQLException {
		ResourceBundle rb = ResourceBundle.getBundle("sql");
		Connection conn = ConnectionManager.getInstance().getConnection();
		int orderNumber = 0;
		try {
			PreparedStatement prepStmt = conn.prepareStatement(rb.getString("orderNo"));
			prepStmt.setInt(1,randomId);
			ResultSet rs = prepStmt.executeQuery();
			if (rs != null) {
				while (rs.next()) {
					orderNumber = rs.getInt("Order");
				}
			}
			rs.close();
			prepStmt.close();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (conn != null) {
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
				conn = null;
			}
		}
		return orderNumber;
	}

	public static int getAvailableRandomizationsCount() throws SQLException {
		ResourceBundle rb = ResourceBundle.getBundle("sql");
		Connection conn = ConnectionManager.getInstance().getConnection();
		int availableRandomizationsCount = 0;
		try {
			PreparedStatement prepStmt = conn.prepareStatement(rb.getString("availableRandomizationsCount"));
			ResultSet rs = prepStmt.executeQuery();
			if (rs != null) {
				while (rs.next()) {
					availableRandomizationsCount = rs.getInt(1);
				}
			}
			rs.close();
			prepStmt.close();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (conn != null) {
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
				conn = null;
			}
		}
		return availableRandomizationsCount;
	}
	public static int getDuplicateSSN(String ssn) throws SQLException {
		ResourceBundle rb = ResourceBundle.getBundle("sql");
		Connection conn = ConnectionManager.getInstance().getConnection();
		int ssnCount = 0;
		try {
			PreparedStatement prepStmt = conn.prepareStatement(rb.getString("duplicateSSN"));
			prepStmt.setString(1, ssn);
			ResultSet rs = prepStmt.executeQuery();
			if (rs != null) {
				while (rs.next()) {
					ssnCount = rs.getInt(1);
				}
			}
			rs.close();
			prepStmt.close();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (conn != null) {
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
				conn = null;
			}
		}
		return ssnCount;
	}
	public static Timestamp updateRandomizationTable(UserBean userBean)
			throws ClassNotFoundException, SQLException {
		Connection conn = ConnectionManager.getInstance().getConnection();
		ResourceBundle rbi = ResourceBundle.getBundle("sql");
		Timestamp randomizedTime = null;
		try {
			PreparedStatement pstmt = null;
			pstmt = conn.prepareStatement(rbi.getString("updateRandomizationTable"));
			pstmt.setString(1, userBean.getUserId());
			pstmt.setInt(2, userBean.getRandomNumber());
			ResultSet rs = pstmt.executeQuery();
			if (rs != null) {
				while (rs.next()) {
					randomizedTime = rs.getTimestamp("RandomizedDateTime");
				}
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (conn != null) {
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
				conn = null;
			}
		}
		return randomizedTime;
	}
	
	public static void SaveUserInDB(UserBean userBean)
			throws ClassNotFoundException, SQLException {
		Connection conn = ConnectionManager.getInstance().getConnection();
		ResourceBundle rbi = ResourceBundle.getBundle("sql");
		try {
			PreparedStatement pstmt = conn.prepareStatement(rbi
					.getString("insertUserInfoToDb"));
			pstmt.setString(1, userBean.getSsn());
			pstmt.setString(2, userBean.getFirstName());
			pstmt.setString(3, userBean.getLastName());
			pstmt.setString(4, userBean.getDateOfBirth());
			pstmt.setString(5, userBean.getSite());
			pstmt.setInt(6, userBean.getRandomNumber());
			pstmt.setTimestamp(7, userBean.getRandomizedDateTime());
			pstmt.setString(8, userBean.getTreatment());
			pstmt.setString(9, userBean.getUserId());
			pstmt.setString(10, userBean.getUserId());
			pstmt.setTimestamp(11, userBean.getRandomizedDateTime());
			pstmt.executeUpdate();
			pstmt.close();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (conn != null) {
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
				conn = null;
			}
		}
	}

	public static void SaveUserInPatientAuditDB(UserBean userBean)
			throws ClassNotFoundException, SQLException {
		Connection conn = ConnectionManager.getInstance().getConnection();
		ResourceBundle rbi = ResourceBundle.getBundle("sql");
		try {
			PreparedStatement pstmt = conn.prepareStatement(rbi
					.getString("insertUserInfoToAuditDb"));
			pstmt.setString(1, userBean.getSsn());
			pstmt.setString(2, userBean.getFirstName());
			pstmt.setString(3, userBean.getLastName());
			pstmt.setString(4, userBean.getDateOfBirth());
			pstmt.setString(5, userBean.getSite());
			pstmt.setInt(6, userBean.getRandomNumber());
			pstmt.setTimestamp(7, userBean.getRandomizedDateTime());
			pstmt.setString(8, userBean.getTreatment());
			pstmt.setString(9, userBean.getUserId());
			pstmt.setString(10, userBean.getUserId());
			pstmt.setTimestamp(11, userBean.getRandomizedDateTime());
			pstmt.executeUpdate();
			pstmt.close();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (conn != null) {
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
				conn = null;
			}
		}
	}

	public static void saveRandomizationInfoToAudit(UserBean userBean)
			throws ClassNotFoundException, SQLException {
		Connection conn = ConnectionManager.getInstance().getConnection();
		ResourceBundle rbi = ResourceBundle.getBundle("sql");
		try {
			PreparedStatement pstmt = conn.prepareStatement(rbi
					.getString("insertRandomizationInfoToAudit"));
			pstmt.setInt(1, userBean.getRandomNumber());
			pstmt.executeUpdate();
			pstmt.close();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (conn != null) {
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
				conn = null;
			}
		}
	}

}
