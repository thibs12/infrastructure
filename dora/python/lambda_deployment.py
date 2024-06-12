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
    deploy_time = datetime.strptime(event['time'], '%Y-%m-%dT%H:%M:%SZ')

    # On ajoute 2 heures pour corriger le décalage horaire
    deploy_time = deploy_time.replace(hour=deploy_time.hour + 2)

    # Récupérer l'ID du dernier commit pour le lier à son déploiement
    cursor.execute("SELECT commit_id FROM commits ORDER BY commit_time DESC LIMIT 1")
    commit_id = cursor.fetchone()[0]

    # Vérifier si le système est en panne
    cursor.execute("SELECT is_down FROM service_status WHERE id = 1")
    is_down = cursor.fetchone()[0]

    redeployment = False
    incident_id = None

    if is_down:
        redeployment = True

        # Récupérer le dernier incident non résolu
        cursor.execute(
            "SELECT incident_id FROM incidents ORDER BY incident_time DESC LIMIT 1"
        )
        incident = cursor.fetchone()
        if incident:
            incident_id = incident[0]

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
