# azure-databricks-vnet-exfiltration

Tailored to West Europe Azure region.

> Note: currently templates are deployed through portal (create own deployment template)

## Steps

1. deploy Databricks inside VNET 

```databricks-DBX-VNET-TAG-RT.json```

2. deploy FW 

```databricks-FW-IP-rules-westeurope.json```

3. asign route table to both VNET subnets (dataplame, controlplane)

```
az network vnet subnet update -g adbx3 -n dataplane-subnet --vnet-name databricks-vnet --route-table dbx-route
az network vnet subnet update -g adbx3 -n controlplane-subnet --vnet-name databricks-vnet --route-table dbx-route
```

4. update FW rule on DBFS

add `dbstoragexyz124.dfs.core.windows.net` from managed Databricks Resource Group

5. create Storage with Private link

6. deny internet from Databricks NSG

7. add FW rules for python/r packages `*pypi.org,*pythonhosted.org,cran.r-project.org,*maven.org`, ports: `Https:443,Http:80,Http:8080`
