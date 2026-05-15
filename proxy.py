from flask import Flask, Response, request
import requests

app = Flask(__name__)

DASHBOARD = "http://127.0.0.1:10000"
TERMINAL = "http://127.0.0.1:7681"

@app.route("/", defaults={"path": ""})
@app.route("/<path:path>")
def proxy(path):
    target = DASHBOARD

    if path.startswith("terminal"):
        target = TERMINAL
        path = path.replace("terminal", "", 1)

    url = f"{target}/{path}"

    resp = requests.request(
        method=request.method,
        url=url,
        headers={k: v for k, v in request.headers},
        data=request.get_data(),
        cookies=request.cookies,
        allow_redirects=False,
        stream=True,
    )

    excluded = ["content-encoding", "content-length", "transfer-encoding", "connection"]

    headers = [
        (name, value)
        for (name, value) in resp.raw.headers.items()
        if name.lower() not in excluded
    ]

    return Response(resp.content, resp.status_code, headers)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
