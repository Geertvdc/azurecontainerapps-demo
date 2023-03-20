# azurecontainerapps-demo
Demo application using Azure Container apps for conference talks. Also uses DAPR &amp; Keda

## Logging cli commands

See container logs:

`az containerapp logs show -n ordering -g globo-tickets --follow`

See current replicas

`az containerapp replica list -n ordering -g globo-tickets`