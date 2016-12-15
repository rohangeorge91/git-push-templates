from flask import Flask, jsonify, request
import requests
import json

import config

app = Flask(__name__)

data_url = None
headers = {
    'Content-Type': 'application/json'
}

if config.DEVELOPMENT:
    data_url = 'https://data.{}.hasura-app.io'.format(config.PROJECT_NAME)
    headers['Authorization'] = 'Bearer ' + config.ADMIN_TOKEN
else:
    # Make a request to the data API as the admin role for full access
    data_url = 'http://data.hasura'
    headers['X-Hasura-Role'] = 'admin'
    headers['X-Hasura-User-Id'] = '1'

query_url = data_url + '/v1/query'


@app.route("/")
def hello():
    query = {
        'type': 'select',
        'args': {
            'table': {
                'name': 'hdb_table',
                'schema': 'hdb_catalog'
            },
            'columns': ['*.*'],
            'where': {'table_schema': 'public'}
        }
    }

    r = requests.post(query_url, data=json.dumps(query), headers=headers)
    if r.status_code != 200:
        return "Error fetching current schema: %s" % r.text

    return jsonify(r.json())


@app.route("/<string:role>")
def get_role(role):
    roles = request.headers['X-Hasura-Allowed-Roles']

    if role in roles:
        return "Hey you have the %s role" % role

    return ('DENIED: Only a user with %s role can access this endpoint' % role, 403)

if __name__ == '__main__':
    app.run(debug=True)
