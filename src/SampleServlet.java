import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import org.json.*;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class SampleServlet extends HttpServlet{
		protected void doGet(HttpServletRequest request, 
		      HttpServletResponse response) throws ServletException, IOException 
		  {
			Connection conn = null;
			try{
			   DatabaseCon con = new DatabaseCon();
			   conn = con.getConnection();
			   Statement stmt = conn.createStatement();
			   String sql;
			   sql = "CALL `cities`.`SP_ALL_CITIES`(0.1333, 0.133, 0.133, 0.133, 0.133, 0.133, 1);";
			   ResultSet rs = stmt.executeQuery(sql);
			   // Extract data from result set
			   PrintWriter out = response.getWriter();
			   JSONConverter json = new JSONConverter();
			   JSONArray jsonArray = json.convertToJSON(rs);
			   out.write(jsonArray.toString());
			   out.flush();
			   out.close();
		   }
		   catch(Exception ex){
			   try {
				   conn.close();
			   } catch (SQLException e) {
				   // TODO Auto-generated catch block
				   e.printStackTrace();
			   }
		   }
		}
		protected void doPost(HttpServletRequest request, 
			      HttpServletResponse response) throws ServletException, IOException 
			  {
				Connection conn = null;
				try{
					DatabaseCon con = new DatabaseCon();
					conn = con.getConnection();
					Statement stmt = conn.createStatement();
					String sql;
					//IN cost float, IN crime float, IN pollution float,
					//IN health float, IN property float, IN emp float
					int model = Integer.parseInt((request.getParameterValues("model")[0]));
					float cost = Float.parseFloat((request.getParameterValues("cost")[0]));
					float health = Float.parseFloat((request.getParameterValues("health")[0]));
					float crime = Float.parseFloat((request.getParameterValues("crime")[0]));
					float pollution = Float.parseFloat((request.getParameterValues("pollution")[0]));
					float property = Float.parseFloat((request.getParameterValues("property")[0]));
					float emp = Float.parseFloat((request.getParameterValues("emp")[0]));
					float sum = cost + health + crime + pollution + property + emp;
					cost = cost/sum;
					health = health/sum;
					crime = crime/sum;
					pollution = pollution/sum;
					property = property/sum;
					emp = emp/sum;
					sql = "CALL `cities`.`SP_ALL_CITIES`("+ String.valueOf(cost)
						   +","+ String.valueOf(crime)
						   +"," +String.valueOf(pollution)+
						   ","+ String.valueOf(health)+","+
						   String.valueOf(property)+","+
						   String.valueOf(emp)+ ","+
						   String.valueOf(model) + ");";
				   ResultSet rs = stmt.executeQuery(sql);
				   // Extract data from result set
				   PrintWriter out = response.getWriter();
				   JSONConverter json = new JSONConverter();
				   JSONArray jsonArray = json.convertToJSON(rs);
				   out.write(jsonArray.toString());
			   // Set response content type
				   out.flush();
				   out.close();
			   }
			   catch(Exception ex){
				   String q = "b";
				   q = q.trim();
				   try {
					   conn.close();
				   } catch (SQLException e) {
					   // TODO Auto-generated catch block
					   e.printStackTrace();
				   }
			   }
		}
}
