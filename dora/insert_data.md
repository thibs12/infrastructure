## Commits
On passe par la fonction lambda pour insérer les données et simuler des commits en faisant des requêtes Curl (donc on passe par l'API Gateway). On ne fait pas via GitHub Actions pour gagner du temps et gérer les données (notamment les dates).

## Déploiements
On effectue des déploiements en appelant aws lambda invoke dans la ligne de commande. Le seul problème est qu'on ne peut pas gérer les dates actuellement. Est-ce qu'on change cela le temps de l'insertion en base pour avoir une gestion sur les données ?
Sinon, dès qu'on insert un commit, penser quelques minutes après à insérer le déploiement. Permet également d'avoir un peu de variations

```bash
aws lambda invoke --function-name TL-deployFunction \
            --payload '{ "commit_id":"1", "deploy_time"="2024-06-20 14:47:32 +0200"}'
```

## Incidents
On génère manuellement des incidents via la console AWS en faisant des tests dans la fonction lambda. De même que pour les déploiements, on ne gère pas actuellement les dates, on change le temps de l'insertion en base 
 
Entre deux insertions d'incidents, insérer deux, trois déploiements (et donc commits) pour avoir un change failure rate cohérent.

On utilise les logs de l'application qui nous permet de gérer les dates des messages. 
Utiliser le script encode_msg pour encoder le message et que ce soit au bon format, puis dans la console on met le test.

## Insertions
$\textbf{Premiers commits}$

```bash
curl -X POST https://ih4ebnhsfe.execute-api.eu-west-1.amazonaws.com/prod/commit \
          -H "Content-Type: application/json" \
          -d '{"commit_id":"1" , "commit_time":"2024-06-20 14:40:13 +0200" }'

PAYLOAD=$(echo '{ "commit_id":"1", "deploy_time":"2024-06-20 14:47:32 +0200"}' | openssl base64)
aws lambda invoke --function-name TL-deployFunction \
            --payload  "$PAYLOAD" \
            response.json

-----------------------------------------------------------------------------------------

curl -X POST https://ih4ebnhsfe.execute-api.eu-west-1.amazonaws.com/prod/commit \
          -H "Content-Type: application/json" \
          -d '{"commit_id":"2" , "commit_time":"2024-06-22 11:30:06 +0200" }'

PAYLOAD=$(echo '{ "commit_id":"2", "deploy_time":"2024-06-22 11:36:53 +0200"}' | openssl base64)
aws lambda invoke --function-name TL-deployFunction \
            --payload "$PAYLOAD" \
            response.json

-----------------------------------------------------------------------------------------

curl -X POST https://ih4ebnhsfe.execute-api.eu-west-1.amazonaws.com/prod/commit \
          -H "Content-Type: application/json" \
          -d '{"commit_id":"3" , "commit_time":"2024-06-23 17:43:24 +0200" }'

PAYLOAD=$(echo '{ "commit_id":"3", "deploy_time":"2024-06-23 17:50:57 +0200"}' | openssl base64)
aws lambda invoke --function-name TL-deployFunction \
            --payload "$PAYLOAD" \
            response.json

-----------------------------------------------------------------------------------------

curl -X POST https://ih4ebnhsfe.execute-api.eu-west-1.amazonaws.com/prod/commit \
          -H "Content-Type: application/json" \
          -d '{"commit_id":"4" , "commit_time":"2024-06-25 10:12:47 +0200" }'

PAYLOAD=$(echo '{ "commit_id":"4", "deploy_time":"2024-06-25 10:20:12 +0200"}' | openssl base64)
aws lambda invoke --function-name TL-deployFunction \
            --payload "$PAYLOAD" \
            response.json

-----------------------------------------------------------------------------------------

curl -X POST https://ih4ebnhsfe.execute-api.eu-west-1.amazonaws.com/prod/commit \
          -H "Content-Type: application/json" \
          -d '{"commit_id":"5" , "commit_time":"2024-06-25 16:56:08 +0200" }'

PAYLOAD=$(echo '{ "commit_id":"5", "deploy_time":"2024-06-25 17:03:08 +0200"}' | openssl base64)
aws lambda invoke --function-name TL-deployFunction \
            --payload "$PAYLOAD" \
            response.json
```

$\textbf{ Incident 2024-06-27 14:12:45}$

```yaml
{
  "awslogs": {
    "data": "H4sIAG4hfGYC/22QXWuDMBiF/0oIu6zLR9XO3gXmymC70rsiI2q0AU0kiSul+N+X2I2xsttzznuek1zhKKzlvSgvk4B7AJ9ZyT7e86JghxxuANRnJUwwCN3GSbp7yjChwRh0fzB6noKH+NmigY91y9FFzybyZtSv7i1ZOCP4GKIU0xjhFBGKjg9vrMyLsuJ104quP/0iwpmda9sYOTmp1YscnDDWFxwhn6ZIGKNN1K0qrG6M/FMot0auULaBJYLy2pLQ5qR/qONj2Et2JIszvE2TR+yt7x8IFx2Xwx4wBVYA0E0zGyNaIBVwJwE8epAND4vgsgF3HPovhxCcxH8pTGnfZoAfDX7kpVq+AB8Ra3uMAQAA"
  }
}
```

$\textbf{Commits et Redéploiements post incidents}$

```bash
curl -X POST https://ih4ebnhsfe.execute-api.eu-west-1.amazonaws.com/prod/commit \
          -H "Content-Type: application/json" \
          -d '{"commit_id":"6" , "commit_time":"2024-06-27 16:07:34 +0200" }'

PAYLOAD=$(echo '{ "commit_id":"6", "deploy_time":"2024-06-27 16:16:14 +0200"}' | openssl base64)
aws lambda invoke --function-name TL-deployFunction \
            --payload "$PAYLOAD" \
            response.json
```

$\textbf{Déploiements post redéploiements (entre deux incidents)}$

```bash
curl -X POST https://ih4ebnhsfe.execute-api.eu-west-1.amazonaws.com/prod/commit \
          -H "Content-Type: application/json" \
          -d '{"commit_id":"7" , "commit_time":"2024-06-27 18:22:07 +0200" }'

PAYLOAD=$(echo '{ "commit_id":"7", "deploy_time":"2024-06-27 18:29:58 +0200"}' | openssl base64)
aws lambda invoke --function-name TL-deployFunction \
            --payload "$PAYLOAD" \
            response.json

-----------------------------------------------------------------------------------------

curl -X POST https://ih4ebnhsfe.execute-api.eu-west-1.amazonaws.com/prod/commit \
          -H "Content-Type: application/json" \
          -d '{"commit_id":"8" , "commit_time":"2024-06-28 11:34:31 +0200" }'

PAYLOAD=$(echo '{ "commit_id":"8", "deploy_time":"2024-06-28 11:43:22 +0200"}' | openssl base64)
aws lambda invoke --function-name TL-deployFunction \
            --payload "$PAYLOAD" \
            response.json

-----------------------------------------------------------------------------------------

curl -X POST https://ih4ebnhsfe.execute-api.eu-west-1.amazonaws.com/prod/commit \
          -H "Content-Type: application/json" \
          -d '{"commit_id":"9" , "commit_time":"2024-06-28 17:12:55 +0200" }'

PAYLOAD=$(echo '{ "commit_id":"9", "deploy_time":"2024-06-28 17:20:25 +0200"}' | openssl base64)
aws lambda invoke --function-name TL-deployFunction \
            --payload "$PAYLOAD" \
            response.json
```

$\textbf{ Incident 2024-06-29 12:34:50}$

```yaml
{
  "awslogs": {
    "data": "H4sIANghfGYC/22QUWuDMBSF/0oIe6yLyaydfQvMlcH2pG9FRtSrDWgiSVwpxf++xG4Myl7POfd8J7niEawVPZSXCfAe4Rde8s+PvCj4IccbhPVZgQkGZU/JNt09ZzFlwRh0fzB6noJHxNmSQYx1K8hFzybyZtSv7i1ZOANiDFEWs4TEKaGMHB/eeZkXZSXqpoWuP/0hwpmda9sYOTmp1ascHBjrC45YTFMExmgTdauKqxsj/wLl1sgVyzawIChvLQ1tTvqHOjGGvXRHs3S7Y1n8GHvr5wfCRSfksEdcoRWAdNPMxkCLpELuBMijB9mIsAgvG3THYf9xEkppekfhSvs2g/xo9Csv1fINCNg+Z4wBAAA="
  }
}
```

$\textbf{Déploiements post redéploiements (entre deux incidents)}$

```bash
curl -X POST https://ih4ebnhsfe.execute-api.eu-west-1.amazonaws.com/prod/commit \
          -H "Content-Type: application/json" \
          -d '{"commit_id":"10" , "commit_time":"2024-06-29 13:46:12 +0200" }'

PAYLOAD=$(echo '{ "commit_id":"10", "deploy_time":"2024-06-29 13:53:42 +0200"}' | openssl base64)
aws lambda invoke --function-name TL-deployFunction \
            --payload "$PAYLOAD" \
            response.json

-----------------------------------------------------------------------------------------

curl -X POST https://ih4ebnhsfe.execute-api.eu-west-1.amazonaws.com/prod/commit \
          -H "Content-Type: application/json" \
          -d '{"commit_id":"11" , "commit_time":"2024-06-29 17:13:57 +0200" }'

PAYLOAD=$(echo '{ "commit_id":"11", "deploy_time":"2024-06-29 17:20:43 +0200"}' | openssl base64)
aws lambda invoke --function-name TL-deployFunction \
            --payload "$PAYLOAD" \
            response.json
```

$\textbf{ Incident 2024-06-29 18:27:26}$

```yaml
{
  "awslogs": {
    "data": "H4sIAAIifGYC/22QUWuDMBSF/0oIe6yLyZxd+xaYK4PtSd+KjKhXG1AjN3GllP73JXZjrOz1nHvPd+490wGsVR0UpwnoltBnWciP9yzP5S6jK0LNcQQMBhcPyWO6ftrEXASjN90OzTwFj6mjZb0aqkaxk5kx8mbULe51MncIagijIhYJi1PGBdvfvckiy4tSVXUDbXf4RYQ1O1e2Rj05bcYX3TtA6wP2VE1TBIgGo3ZRaXllZJ8wumXkTHUTWBCU14aHNKf9oU4NoS9f843HJEl6H3vr+wNho1W63xI5kgVATF3PiNAQPRJ3AOLRva5VaEQvK3LDEf9xEs79yX8pcjQ+DYkvTX7kS3n5AsFSbv2MAQAA"
  }
}
```

$\textbf{Déploiements post redéploiements (entre deux incidents)}$

```bash
curl -X POST https://ih4ebnhsfe.execute-api.eu-west-1.amazonaws.com/prod/commit \
          -H "Content-Type: application/json" \
          -d '{"commit_id":"12" , "commit_time":"2024-06-29 19:14:34 +0200" }'

PAYLOAD=$(echo '{ "commit_id":"12", "deploy_time":"2024-06-29 19:21:28 +0200"}' | openssl base64)
aws lambda invoke --function-name TL-deployFunction \
            --payload "$PAYLOAD" \
            response.json

-----------------------------------------------------------------------------------------

curl -X POST https://ih4ebnhsfe.execute-api.eu-west-1.amazonaws.com/prod/commit \
          -H "Content-Type: application/json" \
          -d '{"commit_id":"13" , "commit_time":"2024-07-01 14:54:25 +0200" }'

PAYLOAD=$(echo '{ "commit_id":"13", "deploy_time":"2024-07-01 15:01:04 +0200"}' | openssl base64)
aws lambda invoke --function-name TL-deployFunction \
            --payload "$PAYLOAD" \
            response.json
```

$\textbf{ Incident 2024-07-03 15:12:45}$

```yaml
{
  "awslogs": {
    "data": "H4sIABkifGYC/2WQUWuDMBSF/0oIe6yLSbVd+xaYK4PtSd+KjKhXG9BEkrhSiv99id0Y617Pufd8594rHsBa0UFxGQHvEX7mBf94z/KcHzK8QlifFZhgULZO0s32aRdTFoxedwejpzF4RJwt6cVQNYJc9GQib0bd4t4mc2dADGGUxSwh8YZQRo4Pb7zI8qIUVd1A251+EWHNTpWtjRyd1OpF9g6M9QFHLMYxAmO0idpFxeWNkX2CcsvIFcsmsCAorw0NaU76Q50YQl+6ZbG/Yr1JH2NvfX8gbLRC9nvEFVoASNf1ZAw0SCrkToA8upe1CI3wvEJ3HPafQ3cJpYylfylcaZ9mkC+NfuS5nL8AlNbv3IwBAAA="
  }
}
```
$\textbf{Déploiements post redéploiements (entre deux incidents)}$

```bash
curl -X POST https://ih4ebnhsfe.execute-api.eu-west-1.amazonaws.com/prod/commit \
          -H "Content-Type: application/json" \
          -d '{"commit_id":"14" , "commit_time":"2024-07-03 21:21:11 +0200" }'

PAYLOAD=$(echo '{ "commit_id":"14", "deploy_time":"2024-07-03 21:29:54 +0200"}' | openssl base64)
aws lambda invoke --function-name TL-deployFunction \
            --payload "$PAYLOAD" \
            response.json
```

$\textbf{ Incident 2024-07-04 11:43:56}$

```yaml
{
  "awslogs": {
    "data": "H4sIADAifGYC/2WQUWuDMBSF/0oIe6yLSZ21fQvMlcH2pG9FRtRoA5rITVwppf99id0Y617POfd8J7ngUVorelmeJ4l3CD/zkn+850XB9zleIWxOWkIwKFsnT+km28aUBWMw/R7MPAWPiJMlgxjrVpCzmSHyZtQv7i1ZOJBiDFEWs4TEKaGMHB7eeJkXZSXqppVdf/xFhDM717YBNTll9IsanATrCw5YTFMkAQxE3aLi6sbIP6V2S+SCVRtYMiivLQ1tTvmHOjGGvXTD4jhL2Tp9jL31/QPhohNq2CGu0QJApmlmANkipZE7SuTRg2pEWISvK3THYf85dJtQypLsL4Vr49sA+dHoR75W1y+sYUZnjAEAAA=="
  }
}
```

$\textbf{Déploiements post redéploiements (entre deux incidents)}$

```bash
curl -X POST https://ih4ebnhsfe.execute-api.eu-west-1.amazonaws.com/prod/commit \
          -H "Content-Type: application/json" \
          -d '{"commit_id":"15" , "commit_time":"2024-07-04 14:43:35 +0200" }'

PAYLOAD=$(echo '{ "commit_id":"15", "deploy_time":"2024-07-04 14:50:44 +0200"}' | openssl base64)
aws lambda invoke --function-name TL-deployFunction \
            --payload "$PAYLOAD" \
            response.json

-----------------------------------------------------------------------------------------

curl -X POST https://ih4ebnhsfe.execute-api.eu-west-1.amazonaws.com/prod/commit \
          -H "Content-Type: application/json" \
          -d '{"commit_id":"16" , "commit_time":"2024-07-06 18:12:35 +0200" }'

PAYLOAD=$(echo '{ "commit_id":"16", "deploy_time":"2024-07-06 18:19:12 +0200"}' | openssl base64)
aws lambda invoke --function-name TL-deployFunction \
            --payload "$PAYLOAD" \
            response.json

-----------------------------------------------------------------------------------------

curl -X POST https://ih4ebnhsfe.execute-api.eu-west-1.amazonaws.com/prod/commit \
          -H "Content-Type: application/json" \
          -d '{"commit_id":"15" , "commit_time":"2024-07-08 11:34:28 +0200" }'

PAYLOAD=$(echo '{ "commit_id":"15", "deploy_time":"2024-07-08 11:41:01 +0200"}' | openssl base64)
aws lambda invoke --function-name TL-deployFunction \
            --payload "$PAYLOAD" \
            response.json
```








