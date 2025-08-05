# Exit on error
set -e

# Fetch value to determine if workflow should deploy Azure Container Apps
DEPLOY_APPS=$(azd env get-value DEPLOY_AZURE_CONTAINERAPPS)

# Deploys Frontend and Backend apps if the variable is set to "true"
if [ "$DEPLOY_APPS" = "true" ]; then
  echo "Deploying apps..."
  azd deploy
else
  echo "Skipping application deployment as DEPLOY_AZURE_CONTAINERAPPS is set to 'false'."

  # Fetch environment variables
  POSTGRES_NAME=$(azd env get-value POSTGRES_NAME)
  DB_HOST=$(azd env get-value POSTGRES_HOST)
  DB_USER=$(azd env get-value POSTGRES_USERNAME)
  DB_PASSWORD=$(azd env get-value POSTGRES_PASSWORD)
  DB_NAME=$(azd env get-value POSTGRES_DATABASE)
  AZURE_API_VERSION_LLM=$(azd env get-value AZURE_OPENAI_API_VERSION)
  AZURE_API_VERSION_EMBEDDING_MODEL=$(azd env get-value AZURE_OPENAI_API_VERSION_EMBED)
  AZURE_OPENAI_API_KEY=$(azd env get-value AZURE_OPENAI_KEY)
  AZURE_OPENAI_ENDPOINT=$(azd env get-value AZURE_OPENAI_ENDPOINT)
  PHOENIX_SQL_DATABASE_URL=$(azd env get-value ARIZE_SQL_URI)

  echo "Creating Azure PostgreSQL extensions..."
  # Create extensions
  az postgres flexible-server execute \
            --admin-user "$DB_USER" \
            --admin-password "$DB_PASSWORD" \
            --name "$POSTGRES_NAME" \
            --database-name "$DB_NAME" \
            --file-path "./scripts/create-extension.sql"

  # Create .env file with the fetched environment variables
  cat << EOF > .env
DB_HOST=$DB_HOST
DB_USER=$DB_USER
DB_PASSWORD=$DB_PASSWORD
DB_NAME=$DB_NAME
AZURE_API_VERSION_LLM=$AZURE_API_VERSION_LLM
AZURE_API_VERSION_EMBEDDING_MODEL=$AZURE_API_VERSION_EMBEDDING_MODEL
AZURE_OPENAI_API_KEY=$AZURE_OPENAI_API_KEY
AZURE_OPENAI_ENDPOINT=$AZURE_OPENAI_ENDPOINT
PHOENIX_SQL_DATABASE_URL=$PHOENIX_SQL_DATABASE_URL
EOF

fi
