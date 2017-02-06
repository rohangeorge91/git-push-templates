/**
 * Created by jaison on 06/02/17.
 */
public class Constants {
    private static final String PROJECT_NAME = "PROJECT_NAME";
    private static final String ENVIRONMENT = "ENVIRONMENT";
    private static final String ADMIN_TOKEN = "ADMIN_TOKEN";

    public static String getProjectName() {
        return System.getenv(PROJECT_NAME);
    }

    public static String getENVIRONMENT() {
        return System.getenv(ENVIRONMENT);
    }

    public static String getAdminToken() {
        return System.getenv(ADMIN_TOKEN);
    }
}
