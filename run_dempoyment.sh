
rg='adbx03'

az login --tenant 72f988bf-86f1-41af-91ab-2d7cd011db47
echo "Logged in."
az group create -n $rg -l westeurope
echo "RG created"

# DEPLOY Databricks and VNET & Get the resulting managed storage
# az group deployment create -g $rg --template-file databricks-DBX-VNET-TAG-RT.json --parameters databricks-DBX-VNET-TAG-RT.params.json
az deployment group create --resource-group $rg --name adbx-fw01 --template-file databricks-DBX-VNET-TAG-RT.json  --parameters databricks-DBX-VNET-TAG-RT.params.json
echo "Deployed. Databricks."

# get the name of the managed RG
# az group list --query "[?starts_with(name,'adbx')].{Name:name}"
rg_managedx=`az group list --query "[?starts_with(name,'adbx-rg-$rg')].[name][0][0]" -o tsv`
rg_managed="$(echo -e "${rg_managedx}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"

storage_managedx=`az storage account list -g "$rg_managed" --query [].[name][0][0] -o tsv`
storage_managed="$(echo -e "${storage_managedx}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
echo $storage_managed

# DEPLOY Databricks and VNET & Get the resulting managed storage
# az group deployment create -g $rg --template-file databricks-FW-IP-rules-westeurope.json --parameters databricksManagedStorageName={$storage_managed}
az deployment group create --resource-group $rg --name adbx-fw02 --template-file databricks-FW-IP-rules-westeurope.json --parameters databricksManagedStorageName=$storage_managed
echo "Deployed. Firewall."

# routes
az network vnet subnet update -g $rg -n dataplane-subnet --vnet-name databricks-vnet --route-table dbx-route
az network vnet subnet update -g $rg -n controlplane-subnet --vnet-name databricks-vnet --route-table dbx-route