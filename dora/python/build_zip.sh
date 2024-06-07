# Install packages in requirements.txt in package dir
mkdir -p package
pip install -r requirements.txt -t package

# Create zips with the installed libraries at the root
cd package
zip -r ../lambda_commit.zip .
zip -r ../lambda_deployment.zip .
zip -r ../lambda_incident.zip .

# Add the lambda function code to the zips
cd ..
zip lambda_commit.zip lambda_commit.py
zip lambda_deployment.zip lambda_deployment.py
zip lambda_incident.zip lambda_incident.py