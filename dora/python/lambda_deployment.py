import json
import pymysql
from datetime import datetime

# Configurer les informations de la base de données RDS
RDS_HOST = "dora-db.ch6qay4mc0rv.eu-west-1.rds.amazonaws.com"
RDS_DATABASE = "dora"
RDS_USER = "dorauser"
RDS_PASSWORD = "dorapassword"

def lambda_handler(event, context):
    # Connexion à la base de données RDS
    conn = pymysql.connect(
        host=RDS_HOST,
        database=RDS_DATABASE,
        user=RDS_USER,
        password=RDS_PASSWORD
    )
    cursor = conn.cursor()

    # Extraire les données du payload
    commit_id = event['commit_id']
    deploy_time = datetime.strptime(event['deploy_time'], '%Y-%m-%dT%H:%M:%SZ')

    # Vérifier si le système est en panne
    cursor.execute("SELECT is_down FROM service_status WHERE id = 1")
    is_down = cursor.fetchone()[0]

    redeployment = False
    incident_id = None

    if is_down:
        redeployment = True

        # Récupérer le dernier incident non résolu
        cursor.execute(
            "SELECT incident_id FROM incidents WHERE resolution_time IS NULL ORDER BY incident_time DESC LIMIT 1"
        )
        incident = cursor.fetchone()
        if incident:
            incident_id = incident[0]

            # Mettre à jour le temps de résolution de l'incident
            cursor.execute(
                "UPDATE incidents SET resolution_time = %s WHERE incident_id = %s",
                (deploy_time, incident_id)
            )

        # Mettre à jour l'état général du système
        cursor.execute(
            "UPDATE service_status SET is_down = FALSE WHERE id = 1"
        )

    # Insérer les données dans la table des déploiements
    cursor.execute(
        "INSERT INTO deployments (commit_id, deploy_time, redeployment, incident_id) VALUES (%s, %s, %s, %s)",
        (commit_id, deploy_time, redeployment, incident_id)
    )
    conn.commit()
    cursor.close()
    conn.close()

    return {
        'statusCode': 200,
        'body': json.dumps('Deployment data inserted successfully!')
    }
