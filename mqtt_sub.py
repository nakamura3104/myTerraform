import boto3
import ssl
import os
from AWSIoTPythonSDK.MQTTLib import AWSIoTMQTTClient

# Cognito Identity Pool ID
identity_pool_id = "your_identity_pool_id"

# AWS Region
region = "your_region"

# Amazon Cognito認証情報プロバイダー
cognito_credentials = boto3.client("cognito-identity", region_name=region)
identity_id = cognito_credentials.get_id(IdentityPoolId=identity_pool_id)["IdentityId"]
credentials = cognito_credentials.get_credentials_for_identity(IdentityId=identity_id)

# AWS IoTエンドポイントの取得
iot = boto3.client("iot", region_name=region, aws_access_key_id=credentials["Credentials"]["AccessKeyId"],
                   aws_secret_access_key=credentials["Credentials"]["SecretKey"],
                   aws_session_token=credentials["Credentials"]["SessionToken"])
endpoint = iot.describe_endpoint(endpointType="iot:Data-ATS")["endpointAddress"]

# MQTTクライアントの設定
client_id = "your_client_id"
my_mqtt_client = AWSIoTMQTTClient(client_id)
my_mqtt_client.configureEndpoint(endpoint, 8883)
my_mqtt_client.configureCredentials(os.path.join(os.path.dirname(os.path.realpath(__file__)), "AmazonRootCA1.pem"))
my_mqtt_client.configureIAMCredentials(credentials["Credentials"]["AccessKeyId"],
                                       credentials["Credentials"]["SecretKey"],
                                       credentials["Credentials"]["SessionToken"])
my_mqtt_client.configureAutoReconnectBackoffTime(1, 32, 20)
my_mqtt_client.configureOfflinePublishQueueing(-1)
my_mqtt_client.configureDrainingFrequency(2)
my_mqtt_client.configureConnectDisconnectTimeout(10)
my_mqtt_client.configureMQTTOperationTimeout(5)

# MQTTクライアントの接続
my_mqtt_client.connect()

# トピックへのサブスクライブ
def custom_callback(client, userdata, message):
    print("Received a new message: ")
    print(message.payload)
    print("from topic: ")
    print(message.topic)
    print("----------------------")

my_mqtt_client.subscribe("your/topic", 1, custom_callback)

# メインループ
while True:
    pass
