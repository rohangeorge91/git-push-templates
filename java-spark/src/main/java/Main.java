import static spark.Spark.get;
import static spark.Spark.port;

public class Main {

    public static void main(String[] args) {
        //To run it on port 8080
        port(8080);

        get("/", (req, res) -> "Hello There");

        get("/schema", (req, res) -> new GetHasuraSchema().run());

        get("/test", (req,res) -> "Test Endpoint");

        get("/:role", (req, res) -> {
            String role = req.params(":role");
            String allowedRoles = req.headers("X-Hasura-Allowed-Roles");
            if (allowedRoles == null) {
                res.status(401);
                return "No roles allowed for you";
            }
            if (allowedRoles.contains(role))
                return "Your role is : " + role;

            res.status(401);
            return "Denied. Only users with role " + allowedRoles + " are allowed.";
        });
    }


}