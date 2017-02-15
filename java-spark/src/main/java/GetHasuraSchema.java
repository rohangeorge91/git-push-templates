import okhttp3.Headers;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

import java.io.IOException;

/**
 * Created by jaison on 06/02/17.
 */
public class GetHasuraSchema {
    OkHttpClient okHttpClient = new OkHttpClient();

    private static final String BASE_URL = "https://data."+Constants.getProjectName()+".hasura-app.io";
    private static final String AUTH_HEADER = "Bearer " + Constants.getAdminToken();

    public String run() throws IOException {
        Headers.Builder headerBuilder = new Headers.Builder()
                .add("Content-type","application/json")
                .add("X-Hasura-Role","admin")
                .add("X-Hasura-User-Id","1");

        String url = "http://data.hasura";

        if (Constants.getENVIRONMENT().equals("development")) {
            url = BASE_URL;
            headerBuilder.add("Authorization",AUTH_HEADER);
        }

        try {
            Request request = new Request.Builder()
                    .url(url+ "/v1/query")
                    .headers(headerBuilder.build())
                    .post(SchemaRequestBody.getRequestBody())
                    .build();
            Response response = okHttpClient.newCall(request).execute();
            if (response.isSuccessful()) {
                return response.body().string();
            } else {
                return "Failed: "+"\n"
                        + "Request : "+request.toString() + "\n"
                        + "Request Headers : " + request.headers()
                        + "Request Body : " + request.body()
                        + "Response: "+response.body().string();
            }
        } catch (Exception e) {
            return "Failed: "+e.getLocalizedMessage();
        }
    }
}
