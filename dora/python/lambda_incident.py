import json
import pymysql
import os

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
        user=RDS_DATABASE,
        password=RDS_USER,
        db=RDS_PASSWORD
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

    # Check if the event is from an ECS task state change
    if "detail-type" in event and event["detail-type"] == "ECS Task State Change":
        incident_time = event['time']
    
    # Check if the event is from CloudWatch Logs
    elif "Records" in event:
        # Gestion des événements CloudWatch Logs
        for record in event['Records']:
            log_event = json.loads(record['body'])
            message = log_event['message']
            
            # Filtrer uniquement les messages contenant "fail:"
            if "fail:" in message:
                incident_time = log_event['timestamp']
    
    cursor.execute(
        "INSERT INTO incidents (incident_time) VALUES ( %s)", (incident_time)
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
