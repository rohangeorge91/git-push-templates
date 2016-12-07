# -*- coding: utf-8 -*-
from django.http import HttpResponse, JsonResponse
import json
import requests

from helloworld import settings

ALLOWED_ROLES_HEADER = 'HTTP_X_HASURA_ALLOWED_ROLES'


def index(request):
    return HttpResponse("Hello Hasura World!")


# Fetch schema info from HasuraDB
def get_schema(request):
    query = {
        'type': 'select',
        'args': {
            'schema': 'hdb_catalog',
            'table': 'hdb_table',
            'columns': ['*.*'],
            'where': {'table_schema': 'public'}
        }
    }

    r = requests.post(settings.DATA_URL, data=json.dumps(query),
                      headers=settings.DATA_HEADERS)
    if r.status_code != 200:
        return HttpResponse('Error fetching current schema: %s' % r.text,
                            status=400)

    return JsonResponse(r.json(), safe=False)


def get_role(request, role):
    try:
        # Django converts multi-value header into csv. Hence the split on ','
        roles = request.META[ALLOWED_ROLES_HEADER].split(',')
    except KeyError:
        return HttpResponse('Cannot fetch role information. Are you running '
                            'inside a Hasura project?', status=400)

    if role in roles:
        return HttpResponse('Hey you have the %s role!' % role)

    return HttpResponse(
        'DENIED: Only a user with %s role can access this endpoint' % role,
        status=403)
