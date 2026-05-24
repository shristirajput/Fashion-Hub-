import com.fashionhub.dao.UserDAO;

public class ResetPassword {
    public static void main(String[] args) {
        UserDAO dao = new UserDAO();
        boolean success = dao.changePassword(1, "admin123");
        System.out.println("Password reset for admin: " + success);
        boolean successUser = dao.changePassword(2, "user123");
        System.out.println("Password reset for user: " + successUser);
    }
}
