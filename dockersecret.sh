#!/bin/bash

# Set your credentials
USERNAME="xadmin"
PASSWORD="10110101001101110010"
EMAIL="xadmin@contoso.com"
SECRET_NAME="dockerconfigjson"
NAMESPACE="falcon-self-hosted-registry-assessment"  # Change if needed
OUTPUT_FILE="dockerconfig.json"  # Local file to save the JSON

# List of registries to authenticate with
REGISTRIES=(
  "xadmin.azure.io"
  # Add more registries as needed
)

# Create the initial config JSON
CONFIG_JSON=$(echo -n "{\"auths\":{}}")

# Add each registry to the config
for registry in "${REGISTRIES[@]}"; do
  # Create auth token (base64 encoded username:password)
  AUTH=$(echo -n "${USERNAME}:${PASSWORD}" | base64 -w 0)
  
  # Add this registry to our JSON
  CONFIG_JSON=$(echo $CONFIG_JSON | jq --arg reg "$registry" --arg auth "$AUTH" --arg email "$EMAIL" \
    '.auths[$reg] = {"username": "'$USERNAME'", "password": "'$PASSWORD'", "email": $email, "auth": $auth}')
done

# Save the JSON to a local file
echo "$CONFIG_JSON" | jq '.' > "$OUTPUT_FILE"
echo "Docker config JSON saved to $OUTPUT_FILE"

# Create the secret from the file
kubectl create secret docker-registry $SECRET_NAME --namespace=$NAMESPACE --from-file=.dockerconfigjson="$OUTPUT_FILE"
echo "Secret '$SECRET_NAME' created in namespace '$NAMESPACE'"
