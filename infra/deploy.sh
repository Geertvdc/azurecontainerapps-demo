FRONTEND_IMAGE="ghcr.io/geertvdc/azurecontainerapps-demo/ordering:main"
CATALOG_IMAGE="ghcr.io/geertvdc/azurecontainerapps-demo/ordering:main"
ORDERING_IMAGE="ghcr.io/geertvdc/azurecontainerapps-demo/ordering:main"
REGISTRY_NAME="ghcr.io"
REGISTRY_USER="geertvdc"
REGISTRY_PASSWORD=$CR_PATH

az deployment group create -g "globo-tickets" -f ./infra/main.bicep \
    -p \
    frontendImage=$FRONTEND_IMAGE \
    catalogImage=$CATALOG_IMAGE \
    orderingImage=$ORDERING_IMAGE \
    containerRegistry=$REGISTRY_NAME \
    containerRegistryUsername=$REGISTRY_USER \
    containerRegistryPassword=$REGISTRY_PASSWORD \
    appName='globotickets' \