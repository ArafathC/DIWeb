import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseCon {
	   static final String JDBC_DRIVER="com.mysql.jdbc.Driver";  
	   static final String DB_URL="jdbc:mysql://localhost/cities";
	      //  Database credentials
	   static final String USER = "root";
	   static final String PASS = "sasken1990";	   
       private Connection connection;
	   DatabaseCon(){		   
	   }
	   public Connection getConnection(){
		   try {
			   Class.forName(JDBC_DRIVER);
			   this.connection = DriverManager.getConnection(DB_URL, USER, PASS);
		   } catch (SQLException e) {
	            e.printStackTrace();
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
		   return this.connection;
	   }	   
}
