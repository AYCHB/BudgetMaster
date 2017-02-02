package de.deadlocker8.budgetmasterserver.main;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import de.deadlocker8.budgetmaster.logic.Category;
import de.deadlocker8.budgetmaster.logic.CategoryBudget;
import de.deadlocker8.budgetmaster.logic.Payment;
import javafx.scene.paint.Color;
import logger.LogLevel;
import logger.Logger;

public class DatabaseHandler
{
	private Connection connection;

	// DEBUG String query = "SELECT * FROM Payment WHERE YEAR(Date) = " + year + " AND MONTH(Date) = " + month + ";";

	public DatabaseHandler(Settings settings)
	{
		try
		{
			this.connection = DriverManager.getConnection(settings.getDatabaseUrl() + settings.getDatabaseName(), settings.getDatabaseUsername(), settings.getDatabasePassword());
		}
		catch(SQLException e)
		{
			throw new IllegalStateException("Cannot connect the database!", e);
		}
	}

	// DEBUG
	public void listTables()
	{
		try
		{
			DatabaseMetaData md = connection.getMetaData();
			ResultSet rs = md.getTables(null, null, "%", null);
			while(rs.next())
			{
				System.out.println(rs.getString(3));
			}
		}
		catch(SQLException e)
		{
			throw new IllegalStateException("Cannot connect the database!", e);
		}
	}

	public ArrayList<String> getPaymentTypes()
	{
		Statement stmt = null;
		String query = "SELECT Description FROM PaymentType";
		ArrayList<String> results = new ArrayList<>();
		try
		{
			stmt = connection.createStatement();
			ResultSet rs = stmt.executeQuery(query);
			while(rs.next())
			{
				results.add(rs.getString("Description"));
			}
		}
		catch(SQLException e)
		{
			Logger.log(LogLevel.ERROR, Logger.exceptionToString(e));
		}
		finally
		{
			if(stmt != null)
			{
				try
				{
					stmt.close();
				}
				catch(SQLException e)
				{
				}
			}
		}

		return results;
	}

	public ArrayList<Category> getCategories()
	{
		Statement stmt = null;
		String query = "SELECT * FROM Category";
		ArrayList<Category> results = new ArrayList<>();
		try
		{
			stmt = connection.createStatement();
			ResultSet rs = stmt.executeQuery(query);
			while(rs.next())
			{
				int id = rs.getInt("ID");
				String name = rs.getString("Name");
				String color = rs.getString("Color");

				results.add(new Category(id, name, Color.web(color)));
			}
		}
		catch(SQLException e)
		{
			Logger.log(LogLevel.ERROR, Logger.exceptionToString(e));
		}
		finally
		{
			if(stmt != null)
			{
				try
				{
					stmt.close();
				}
				catch(SQLException e)
				{
				}
			}
		}

		return results;
	}

	public ArrayList<CategoryBudget> getCategoryBudget(int year, int month)
	{	
		Statement stmt = null;
		String query = "SELECT q.cat_name AS \"Name\", q.cat_col AS \"Color\", SUM(q.amoun) AS \"Amount\" FROM (SELECT Payment.CategoryID as \"cat_ID\", Category.Name as \"cat_name\", Category.Color as \"cat_col\", Payment.Amount AS \"amoun\" FROM Payment, Category WHERE Payment.CategoryID = Category.ID AND (YEAR(Date) = "
				+ year + " AND MONTH(Date) = " + month
				+ " OR RepeatMonthDay != 0 OR RepeatInterval != 0 AND DATEDIFF(NOW(), Date ) % RepeatInterval = 0 AND RepeatEndDate IS NULL OR RepeatInterval != 0 AND DATEDIFF(NOW(), Date ) % RepeatInterval = 0 AND RepeatEndDate IS NOT NULL AND DATEDIFF(RepeatEndDate, NOW()) > 0)GROUP BY Payment.ID) as q GROUP BY q.cat_ID ORDER BY SUM(q.amoun) DESC";
		ArrayList<CategoryBudget> results = new ArrayList<>();
		try
		{
			stmt = connection.createStatement();
			ResultSet rs = stmt.executeQuery(query);

			while(rs.next())
			{
				String name = rs.getString("Name");
				String color = rs.getString("Color");
				int amount = rs.getInt("Amount");

				results.add(new CategoryBudget(name, Color.web(color), amount / 100.0));
			}
		}
		catch(SQLException e)
		{
			Logger.log(LogLevel.ERROR, Logger.exceptionToString(e));
		}
		finally
		{
			if(stmt != null)
			{
				try
				{
					stmt.close();
				}
				catch(SQLException e)
				{
				}
			}
		}

		return results;
	}

	public Payment getPayment(int ID, int year, int month)
	{
		Statement stmt = null;
		String query = "SELECT * FROM Payment, PaymentType WHERE Payment.PaymentTypeID = PaymentType.ID AND Payment.ID= " + ID;
		try
		{
			stmt = connection.createStatement();
			ResultSet rs = stmt.executeQuery(query);

			while(rs.next())
			{
				int resultID = rs.getInt("ID");
				String paymentType = rs.getString("Description");
				boolean income = true;
				if(paymentType.equals("-"))
				{
					income = false;
				}				
				String name = rs.getString("Name");
				int amount = rs.getInt("amount");
				String date = rs.getString("Date");
				int categoryID = rs.getInt("CategoryID");
				
				int repeatInterval = rs.getInt("RepeatInterval");				
				String repeatEndDate = rs.getString("RepeatEndDate");				
				int repeatMonthDay = rs.getInt("RepeatMonthDay");
				if(repeatInterval != 0 || repeatMonthDay != 0)
				{					
					DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy-MM-dd");						
					DateTime dateTime = formatter.parseDateTime(date);
					dateTime = dateTime.year().setCopy(year);
					dateTime = dateTime.monthOfYear().setCopy(month);
					date = dateTime.toString(formatter);					
				}
				
				return new Payment(resultID, income, amount, date, categoryID, name, repeatInterval, repeatEndDate, repeatMonthDay);
			}
		}
		catch(SQLException e)
		{
			Logger.log(LogLevel.ERROR, Logger.exceptionToString(e));
		}
		finally
		{
			if(stmt != null)
			{
				try
				{
					stmt.close();
				}
				catch(SQLException e)
				{
				}
			}
		}

		return null;
	}

	public ArrayList<Integer> getPaymentIDs(int year, int month)
	{
		Statement stmt = null;
		String query = "SELECT Payment.ID as ID FROM Payment, PaymentType WHERE Payment.PaymentTypeID = PaymentType.ID AND (YEAR(Date) = " + year + " AND MONTH(Date) = " + month
				+ " OR RepeatMonthDay != 0 OR RepeatInterval != 0 AND DATEDIFF(NOW(), Date ) % RepeatInterval = 0 AND RepeatEndDate IS NULL OR RepeatInterval != 0 AND DATEDIFF(NOW(), Date ) % RepeatInterval = 0 AND RepeatEndDate IS NOT NULL AND DATEDIFF(RepeatEndDate, NOW()) > 0) GROUP BY Payment.ID ORDER BY Payment.Date;";

		ArrayList<Integer> results = new ArrayList<>();
		try
		{
			stmt = connection.createStatement();
			ResultSet rs = stmt.executeQuery(query);

			while(rs.next())
			{
				int ID = rs.getInt("ID");
				results.add(ID);
			}
		}
		catch(SQLException e)
		{
			Logger.log(LogLevel.ERROR, Logger.exceptionToString(e));
		}
		finally
		{
			if(stmt != null)
			{
				try
				{
					stmt.close();
				}
				catch(SQLException e)
				{
				}
			}
		}

		return results;
	}

	public ArrayList<Payment> getPayments(int year, int month)
	{
		ArrayList<Payment> payments = new ArrayList<>();
		ArrayList<Integer> IDs = getPaymentIDs(year, month);
		for(int currentID : IDs)
		{
			Payment currentPayment = getPayment(currentID, year, month);
			if(currentPayment != null)
			{
				payments.add(currentPayment);
			}
		}

		return payments;
	}
}