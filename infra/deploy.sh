FRONTEND_IMAGE="ghcr.io/geertvdc/azurecontainerapps-demo/frontend:dapr"
CATALOG_IMAGE="ghcr.io/geertvdc/azurecontainerapps-demo/catalog:dapr"
ORDERING_IMAGE="ghcr.io/geertvdc/azurecontainerapps-demo/ordering:dapr"
REGISTRY_NAME="ghcr.io"
REGISTRY_USER="geertvdc"
REGISTRY_PASSWORD="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"

az deployment group create -g "globo-tickets" -f ./infra/main.bicep \
    -p \
    frontendImage=$FRONTEND_IMAGE \
    catalogImage=$CATALOG_IMAGE \
    orderingImage=$ORDERING_IMAGE \
    containerRegistry=$REGISTRY_NAME \
    containerRegistryUsername=$REGISTRY_USER \
    containerRegistryPassword=$REGISTRY_PASSWORD \
    appName='globotickets' \