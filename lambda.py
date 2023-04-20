import json

def lambda_handler(event, context):
    # イベントデータを表示形式に変換
    event_str = json.dumps(event, indent=2)

    # HTTPメソッドを取得
    http_method = event['httpMethod']

    # メソッドに応じたメッセージを作成
    if http_method == 'GET':
        message = "Hello from Lambda and API Gateway with a GET request!"
    elif http_method == 'PUT':
        message = "Hello from Lambda and API Gateway with a PUT request!"
    else:
        message = "Hello from Lambda and API Gateway with an unsupported request!"

    # レスポンスを作成
    response = {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps({
            "message": message,
            "event": event_str
        })
    }

    return response
