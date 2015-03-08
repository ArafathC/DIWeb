
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.URL;
import java.net.URLConnection;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.select.Elements;

/**
 * Servlet implementation class SelectData
 */
@WebServlet("/CheckWeb")
public class CheckWeb extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static HashSet<String> websites;
	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public CheckWeb() {
		super();
		// TODO Auto-generated constructor stub
		websites.add("http://www.google.com");
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub

		if (request.getParameterValues("action")[0]
				.compareTo("Select city data") == 0)
			selectCityData(request, response);
		else if (request.getParameterValues("action")[0].compareTo("GDP Data") == 0)
			selectGDPData(request, response);
		else if (request.getParameterValues("action")[0].compareTo("POP Data") == 0)
			selectPOPData(request, response);
		else if (request.getParameterValues("action")[0]
				.compareTo("Employment") == 0)
			selectEmploymentData(request, response);
		else if (request.getParameterValues("action")[0].compareTo("CITY Info") == 0)
			selectCityInfoData(request, response);
		else if (request.getParameterValues("action")[0].compareTo("check") == 0) {
			checkWebSites(request, response);
		} else if (request.getParameterValues("action")[0].compareTo("update") == 0) {
			updateWebSites(request, response);
		}

	}

	protected void updateWebSites(HttpServletRequest request,
			HttpServletResponse response) {
		URL url;
		try {
			// get URL content
			url = new URL("http://www.mkyong.com");
			URLConnection conn = url.openConnection();

			// open the stream and put it into BufferedReader
			BufferedReader br = new BufferedReader(new InputStreamReader(
					conn.getInputStream()));

			Document doc = Jsoup.connect("http://google.com/").get();

			String title = doc.title();
			PrintWriter out = response.getWriter();
			out.write(title);
			out.flush();
			out.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	protected void checkWebSites(HttpServletRequest request,
			HttpServletResponse response) {
		try {
			Document doc = Jsoup.connect("http://google.com/").get();
			Elements stories = doc.select("");

			String title = doc.title();
			PrintWriter out = response.getWriter();
			out.write(title);
			out.flush();
			out.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	protected void selectCityInfoData(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		double latitude = Double.parseDouble(request.getParameter("latitude"));
		double longitude = Double
				.parseDouble(request.getParameter("longitude"));
		String sql = "CALL `cities`.`SP_CITY_INFO`(" + latitude + ","
				+ longitude + ");";
		JSONArray jsonArray = getData(sql);
		PrintWriter out = response.getWriter();
		out.write(jsonArray.toString());
		out.flush();
		out.close();

	}

	protected void selectCityData(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String sql;
		sql = "select * from city_tbl;";
		JSONArray jsonArray = getData(sql);
		PrintWriter out = response.getWriter();
		out.write(jsonArray.toString());
		out.flush();
		out.close();

	}

	protected void selectPOPData(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		float latitude = Float.parseFloat((request
				.getParameterValues("latitude")[0]));
		float longitude = Float.parseFloat((request
				.getParameterValues("longitude")[0]));
		String sql;
		sql = "CALL `cities`.`SP_CITY_POP`(" + String.valueOf(latitude) + ","
				+ String.valueOf(longitude) + ");";
		JSONArray jsonArray = getData(sql);
		PrintWriter out = response.getWriter();
		out.write(jsonArray.toString());
		out.flush();
		out.close();

	}

	protected void selectGDPData(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		float latitude = Float.parseFloat((request
				.getParameterValues("latitude")[0]));
		float longitude = Float.parseFloat((request
				.getParameterValues("longitude")[0]));
		String sql;
		sql = "CALL `cities`.`SP_CITY_GDP`(" + String.valueOf(latitude) + ","
				+ String.valueOf(longitude) + ");";
		JSONArray jsonArray = getData(sql);
		PrintWriter out = response.getWriter();
		out.write(jsonArray.toString());
		out.flush();
		out.close();

	}

	protected void selectEmploymentData(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		float latitude = Float.parseFloat((request
				.getParameterValues("latitude")[0]));
		float longitude = Float.parseFloat((request
				.getParameterValues("longitude")[0]));
		String sql;
		sql = "CALL `cities`.`SP_CITY_EMPLOYMENT`(" + String.valueOf(latitude)
				+ "," + String.valueOf(longitude) + ");";
		JSONArray jsonArray = getData(sql);
		PrintWriter out = response.getWriter();
		out.write(jsonArray.toString());
		out.flush();
		out.close();

	}

	protected JSONArray getData(String sql) {
		Connection conn = null;
		try {
			DatabaseCon con = new DatabaseCon();
			conn = con.getConnection();
			Statement stmt = conn.createStatement();
			ResultSet rs = stmt.executeQuery(sql);
			// Extract data from result set
			JSONConverter json = new JSONConverter();
			JSONArray jsonArray = json.convertToJSON(rs);
			return jsonArray;
		} catch (Exception ex) {
			try {
				conn.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return null;
	}
}
