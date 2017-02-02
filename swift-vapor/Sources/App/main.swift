import Vapor
import HTTP
import Foundation

enum EnvironmentVariable {
    case PRODUCTION
    case DEVELOPMENT
}

let drop = Droplet()

var adminToken: String {
get {
    guard let adminToken = ProcessInfo.processInfo.environment["ADMIN_TOKEN"] else {
        return ""
    }
    return adminToken
}
}

var PROJECT_NAME: String {
    get {
        guard let projectName = ProcessInfo.processInfo.environment["PROJECT_NAME"] else {
            return ""
        }
        return projectName
    }
}
let ENVIRONMENT = ProcessInfo.processInfo.environment["ENVIRONMENT"] == "Production" ? EnvironmentVariable.PRODUCTION : EnvironmentVariable.DEVELOPMENT

var headers: [HeaderKey : String] = [
    "Content-type"    : "application/json",
    "X-Hasura-Role"   : "admin",
    "X-Hasura-User-Id": "1"
]

var url = "http://data.hasura"

if ENVIRONMENT == EnvironmentVariable.DEVELOPMENT {
    url = "https://data.\(PROJECT_NAME).hasura-app.io"
    headers["Authorization"] = "Bearer " + adminToken
}

let schemaRequestBody = try JSON(node: [
    "type":"select",
    "args": [
        "table": [
            "schema": "hdb_catalog",
            "name"  : "hdb_table"
        ],
        "columns": ["*.*"],
        "where"  : [
            "table_schema": "public"
        ]
    ]
    ])

drop.get { (request) -> ResponseRepresentable in
    return "Hello There"
}

drop.get("schema") { req in
    print(req.headers)
    do {
        let response = try drop.client.post(url+"/v1/query", headers: headers, body: schemaRequestBody.makeBody())
        print("Response: \n\n \(response)")
        return response
    } catch (let error) {
        print("Response Error: \(error)")
        return try Response(status: Status.badRequest, json: JSON(node: [
            "Environment" : ENVIRONMENT == EnvironmentVariable.PRODUCTION ? "Production" : "Development",
            "ADMIN KEY"   : adminToken
            ]))
    }
}

drop.get(String.self) { (request,role) -> ResponseRepresentable in
    let headers = request.headers
    if let allowedRoles = headers["X-Hasura-Allowed-Roles"] {
        if allowedRoles.contains(role) {
            return "Your role is \(role)"
        }
        return Response(status: Status.unauthorized, body: "Denied. Only users with role :\(allowedRoles) are allowed")
    }
    return Response(status: Status.unauthorized, body: "Denied. No roles allowed")
}


drop.run()
