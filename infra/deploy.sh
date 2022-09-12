az deployment group create -g "globo-tickets" -f ./aca/main.bicep \
    -p \
    frontendImage='$FRONTEND_IMAGE' \
    catalogImage='$CATALOG_IMAGE' \
    orderingImage='$ORDERING_IMAGE' \
    containerRegistry=$REGISTRY_NAME \
    containerRegistryUsername=$REGISTRY_USER \
    containerRegistryPassword=$REGISTRY_PASSWORD \
    appName='globotickets' \