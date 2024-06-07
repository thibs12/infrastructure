import json
import pymysql
from datetime import datetime

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
    commit_time = datetime.strptime(event['commit_time'], '%Y-%m-%dT%H:%M:%SZ')
    
    # Insérer les données dans la table commits
    cursor.execute(
        "INSERT INTO commits (commit_id, commit_time) VALUES (%s, %s)",
        (commit_id, commit_time)
    )
    conn.commit()
    cursor.close()
    conn.close()
    
    return {
        'statusCode': 200,
        'body': json.dumps('Commit data inserted successfully!')
    }
