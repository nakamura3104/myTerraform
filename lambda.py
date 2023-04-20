import json

def lambda_handler(event, context):
    # イベントデータを表示形式に変換
    event_str = json.dumps(event, indent=2)

    # HTTPメソッドを取得
    http_method = event['httpMethod']

    # メソッドに応じたレスポンスを作成
    if http_method == 'GET':
        response = {
            "statusCode": 200,
            "headers": {
                "Content-Type": "application/json"
            },
            "body": json.dumps({
                "message": "Hello from Lambda and API Gateway with a GET request!",
                "event": event_str
            })
        }
    elif http_method == 'PUT':
        response = {
            "statusCode": 200,
            "headers": {
                "Content-Type": "text/plain"
            },
            "body": "Hello from Lambda and API Gateway with a PUT request!"
        }
    else:
        response = {
            "statusCode": 400,
            "headers": {
                "Content-Type": "application/json"
            },
            "body": json.dumps({
                "message": "Unsupported method.",
                "event": event_str
            })
        }

    return response
