import java.sql.Connection;
import java.sql.DriverManager;

public class TestDB {
    public static void main(String[] args) {
        String URL = "jdbc:h2:mem:fashionhub_db;MODE=MySQL;INIT=RUNSCRIPT FROM 'classpath:database.sql';DB_CLOSE_DELAY=-1";
        try {
            Class.forName("org.h2.Driver");
            Connection conn = DriverManager.getConnection(URL, "sa", "");
            System.out.println("Connection successful: " + conn);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
