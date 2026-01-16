import json

def handler(event, context):
    path = event.get("rawPath", "/")
    if path == "/health":
        body = {"ok": True}
    else:
        body = {"message": "Hello from lambda-web-app", "path": path}

    return {
        "statusCode": 200,
        "headers": {"content-type": "application/json"},
        "body": json.dumps(body),
    }
