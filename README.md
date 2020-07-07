# azure-databricks-vnet-exfiltration

Tailored to West Europe Azure region due to hardcoded IPs/FQDNs for various Databrick resources. If you want to port to different region use this [url](https://docs.microsoft.com/en-us/azure/databricks/administration-guide/cloud-configurations/azure/udr) 

> Note: currently templates are deployed through portal (create own deployment template)

## Steps

1. deploy Databricks inside VNET 

```databricks-DBX-VNET-TAG-RT.json```

2. deploy FW 

```databricks-FW-IP-rules-westeurope.json```

3. asign route table to both VNET subnets (dataplame, controlplane) - rename if needed

```
az network vnet subnet update -g YOUR_RESOURCE_GROUP -n dataplane-subnet --vnet-name databricks-vnet --route-table dbx-route
az network vnet subnet update -g YOUR_RESOURCE_GROUP -n controlplane-subnet --vnet-name databricks-vnet --route-table dbx-route
```

4. create Storage with Private link

5. deny internet from Databricks NSG

6. add FW rules for python/r packages `*pypi.org,*pythonhosted.org,cran.r-project.org,*maven.org`, ports: `Https:443,Http:80,Http:8080`
