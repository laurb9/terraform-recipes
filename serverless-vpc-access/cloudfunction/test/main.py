import os
import json
import requests

def query_url():
    ip = os.environ["HTTP_ENDPOINT"]
    url = f'http://{ip}/'
    response = requests.get(url)
    return json.dumps(dict(url=url,
                           status=response.status_code,
                           headers=dict(response.headers),
                           env=dict(os.environ)),
                      indent=4,
                      sort_keys=True)

def main(request):
    """Responds to any HTTP request.
    Args:
        request (flask.Request): HTTP request object.
    Returns:
        The response text or any set of values that can be turned into a
        Response object using
        `make_response <http://flask.pocoo.org/docs/1.0/api/#flask.Flask.make_response>`.
    """
    request_json = request.get_json()
    if request.args and 'message' in request.args and request.args.get('message') == 'call_nginx':
        return query_url()
    elif request_json and 'message' in request_json:
        return request_json['message']

if __name__ == "__main__":
    print(query_url())