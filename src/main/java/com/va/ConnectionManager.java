package com.va;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ResourceBundle;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.*;

import org.apache.tomcat.jdbc.pool.PoolProperties;

public class ConnectionManager {

	private static ConnectionManager instance = null;
	public Connection connection = null;
	public Statement statement = null;
	private final DataSource ds = null;

	public ConnectionManager() {
	}

	public static ConnectionManager getInstance() {
		if (instance == null) {
			instance = new ConnectionManager();
		}
		return instance;
	}

	private boolean openConnection() {
		try {
			Context ctx = new InitialContext();
			Context envCtx = (Context) ctx.lookup("java:comp/env");
			DataSource ds = (DataSource) envCtx.lookup("jdbc/sqlserv");

			if (ds != null) {
				connection = ds.getConnection();
				statement = connection.createStatement();
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} catch (NamingException e) {
			e.printStackTrace();
		}
		return true;
	}

	public synchronized Connection getConnection() throws SQLException {
		try {
			Context ctx = new InitialContext();
			Context envCtx = (Context) ctx.lookup("java:comp/env");
			DataSource ds = (DataSource) envCtx.lookup("jdbc/sqlserv");

			if (ds != null) {
				connection = ds.getConnection();
				statement = connection.createStatement();
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} catch (NamingException e) {
			e.printStackTrace();
		}
		return connection;
	}

	public void close() {
		System.out.println("Closing connection");
		try {
			connection.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		connection = null;
	}

}
