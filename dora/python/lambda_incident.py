import json
import pymysql

# Configurer les informations de la base de données RDS
RDS_HOST = "dora-db.ch6qay4mc0rv.eu-west-1.rds.amazonaws.com"
RDS_DATABASE = "dora"
RDS_USER = "dorauser"
RDS_PASSWORD = "dorapassword"

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

    # Determine the source of the event

    # Check if the event is from an ECS task state change
    if "detail-type" in event and event["detail-type"] == "ECS Task State Change":
        incident_time = event['time']
    
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
