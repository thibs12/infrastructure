import json
import pymysql
import os
import base64
import gzip
from datetime import datetime, timedelta

# Configurer les informations de la base de données RDS
RDS_HOST = os.environ['DATABASE_ENDPOINT']
RDS_DATABASE = os.environ['DATABASE_NAME']
RDS_USER = os.environ['DATABASE_USER']
RDS_PASSWORD = os.environ['DATABASE_PASSWORD']

def lambda_handler(event, context):
    print("Received event: " + json.dumps(event, indent=2))
    
    # Connect to MySQL and insert the incident
    conn = pymysql.connect(
        host=RDS_HOST,
        database=RDS_DATABASE,
        user=RDS_USER,
        password=RDS_PASSWORD
    )

    cursor = conn.cursor()

    # Check si le système est en panne pour ne pas référencer deux fois le même incident
    cursor.execute("SELECT is_down FROM service_status WHERE id = 1")
    is_down = cursor.fetchone()[0]
    if is_down:
        # Le système est déjà en panne
        return {
            'statusCode': 200,
            'body': json.dumps('Incident already recorded!')
        }

    # Initialiser incident_time
    incident_time = None

    # Check if the event is from an ECS task state change
    if "detail-type" in event and event["detail-type"][0] == "ECS Task State Change":
        incident_time = datetime.now() + timedelta(hours=2)
    
    # Check if the event is from CloudWatch Logs
    elif "awslogs" in event:

        # Gestion des événements CloudWatch Logs
        cw_data = event['awslogs']['data']
        compressed_payload = base64.b64decode(cw_data)
        uncompressed_payload = gzip.decompress(compressed_payload)
        payload = json.loads(uncompressed_payload)
        log_events = payload['logEvents']

        for log_event in log_events:
            message = log_event['message']
            
            # Filtrer uniquement les messages contenant "fail:"
            if "fail:" in message:
                incident_time = datetime.fromtimestamp(log_event['timestamp'])
                incident_time = incident_time + timedelta(hours=2)
                break


    if incident_time is not None:
        cursor.execute(
            "INSERT INTO incidents (incident_time) VALUES (%s)", (incident_time,)
        )
        # Mettre à jour l'état général du système
        cursor.execute(
            "UPDATE service_status SET is_down = TRUE WHERE id = 1"
        )
        conn.commit()
        cursor.close()
        conn.close()

        return {
            'statusCode': 200,
            'body': json.dumps('Incident recorded successfully!')
        }
    else:
        return {
            'statusCode': 200,
            'body': json.dumps('No incident detected!')
        }
