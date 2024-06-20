import json
import boto3
import pymysql
import os
import time
from datetime import datetime, timedelta

# Configurer les informations de la base de données RDS
RDS_HOST = os.environ['DATABASE_ENDPOINT']
RDS_DATABASE = os.environ['DATABASE_NAME']
RDS_USER = os.environ['DATABASE_USER']
RDS_PASSWORD = os.environ['DATABASE_PASSWORD']

CLUSTER_ARN = os.environ['CLUSTER_ARN']
SERVICE_NAME = os.environ['SERVICE_NAME']


def lambda_handler(event, context):

    # Récupérer les tâches ECS en cours
    ecs_client = boto3.client('ecs')
    # utc +2
    start_time = datetime.now() + timedelta(hours=2)

    while True: 

        tasks = ecs_client.list_tasks(
            cluster=CLUSTER_ARN,
            serviceName=SERVICE_NAME,
            desiredStatus='RUNNING'
        )['taskArns']

        response = ecs_client.describe_tasks(
            cluster=CLUSTER_ARN,
            tasks=tasks
        )

        all_healthy = all(
            task['healthStatus'] == 'HEALTHY'
            for task in response['tasks']
        )

        if all_healthy:

            # Connexion à la base de données RDS
            conn = pymysql.connect(
                host=RDS_HOST,
                database=RDS_DATABASE,
                user=RDS_USER,
                password=RDS_PASSWORD
            )
            cursor = conn.cursor()

            commit_id = event['commit_id']
            # Extraire les données du payload
            deploy_time = datetime.now() + timedelta(hours=2)

            # Vérifier si le système est en panne
            cursor.execute("SELECT is_down FROM service_status WHERE id = 1")
            is_down = cursor.fetchone()[0]

            redeployment = False
            incident_id = None

            if is_down:
                redeployment = True

                # Récupérer le dernier incident non résolu
                cursor.execute(
                    "SELECT id FROM incidents ORDER BY incident_time DESC LIMIT 1"
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
        
        # Vérifier si le délai de déploiement est dépassé
        if datetime.now() + timedelta(hours=2) - start_time > timedelta(minutes=10):
            return {
                'statusCode': 500,
                'body': json.dumps('Deployment timeout exceeded!')
            }
        
        # Attendre 5 secondes avant de vérifier à nouveau
        time.sleep(5)
