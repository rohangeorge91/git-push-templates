import com.google.gson.Gson;
import com.google.gson.annotations.SerializedName;
import okhttp3.MediaType;
import okhttp3.RequestBody;

/**
 * Created by jaison on 06/02/17.
 */
public class SchemaRequestBody {
    String type = "select";
    Args args = new Args();

    class Args {

        Table table = new Table();
        String[] columns = {"*"};
        Where where = new Where();

        class Table {
            String schema = "hdb_catalog";
            String name = "hdb_table";
        }

        class Where {
            @SerializedName("table_schema")
            String tableSchema = "public";
        }
    }

    public static RequestBody getRequestBody() {
        return RequestBody.create(MediaType.parse("application/json; charset=utf-8"), new Gson().toJson(new SchemaRequestBody()));
    }
}
