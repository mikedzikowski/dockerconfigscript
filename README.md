# CrowdStrike Self-Hosted Registry Assessment (SHRA) Credentials Setup

## Overview

This script automates the creation of a Kubernetes secret containing Docker registry credentials for use with CrowdStrike's Self-Hosted Registry Assessment (SHRA) tool. It generates a Docker configuration JSON file and creates a corresponding Kubernetes secret to allow SHRA to authenticate with your container registries.

## Prerequisites

- Bash shell environment
- `kubectl` configured with access to your cluster
- `jq` command-line JSON processor
- `base64` utility
- Access credentials for your container registries

## Configuration

Edit the following variables at the top of the script to match your environment:

```bash
USERNAME="xadmin"                   # Registry username
PASSWORD="10110101001101110010"     # Registry password
EMAIL="xadmin@contoso.com"          # Email associated with registry account
SECRET_NAME="dockerconfigjson"      # Name of the Kubernetes secret to create
NAMESPACE="falcon-self-hosted-registry-assessment"  # Kubernetes namespace
OUTPUT_FILE="dockerconfig.json"     # Local file to save the configuration
```

Add your registries to the `REGISTRIES` array:

```bash
REGISTRIES=(
  "xadmin.azure.io"
  # Add more registries as needed
)
```

## Usage

1. Update the script with your credentials and registry information
2. Make the script executable:
   ```
   chmod +x setup-shra-credentials.sh
   ```
3. Run the script:
   ```
   ./setup-shra-credentials.sh
   ```

## What the Script Does

1. Creates a Docker configuration JSON file with authentication details for each registry
2. Saves this configuration to a local file (`dockerconfig.json` by default)
3. Creates a Kubernetes secret of type `docker-registry` in the specified namespace
4. The secret will be used by SHRA to authenticate with private container registries

## Security Considerations

- This script contains sensitive credentials in plain text. Consider:
  - Using environment variables or a secrets manager instead
  - Restricting file permissions
  - Deleting the local configuration file after secret creation
- The created Kubernetes secret will contain your registry credentials, so ensure appropriate RBAC controls are in place

## Additional Notes

- The namespace (`falcon-self-hosted-registry-assessment`) should match where your SHRA deployment is running
- Verify the secret was created successfully using `kubectl get secrets -n $NAMESPACE`
- Reference this secret in your SHRA configuration to enable authentication with private registries
