import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import myPackage.City;

import org.json.JSONArray;


public class CityServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	Statement stmt;
	Connection conn;
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			DatabaseCon con = new DatabaseCon();
			conn = con.getConnection();
			stmt = conn.createStatement();
			double latitude = Double.parseDouble(request.getParameter("Latitude"));
			double longitude = Double.parseDouble(request.getParameter("Longitude"));
			String CITY_INFO_QUERY = "CALL `cities`.`SP_CITY_INFO`(" + latitude + "," + longitude + ");";
			ResultSet rs = stmt.executeQuery(CITY_INFO_QUERY);
			PrintWriter out = response.getWriter();
			JSONConverter json = new JSONConverter();
			JSONArray jsonArray = json.convertToJSON(rs);
			out.write(jsonArray.toString());
			out.flush();
			out.close();

		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			try {
				 if(conn != null) {
					 conn.close(); 
				 }
			} catch (SQLException e) {
				e.printStackTrace();
			} 
		} 
	}
}
