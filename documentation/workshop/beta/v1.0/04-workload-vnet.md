#        1         2         3         4         5         6         7         8
#2345678901234567890123456789012345678901234567890123456789012345678901234567890
#--------------------------------------+---------------------------------------8
#                                                                              |
#                            DEPLOY - WORKLOAD VNET                            |
#                                                                              |
#--------------------------------------+---------------------------------------8

# Duration of Task      : 5 minutes

mkdir -p ~/Azure_SAP_Automated_Deployment/WORKSPACES/SAP_LANDSCAPE/NP-EUS2-SAP0-INFRASTRUCTURE; cd $_
egrep -wi 'resource_group_name|storage_account_name|container_name' ../../SAP_LIBRARY/NP-EUS2-SAP_LIBRARY/.terraform/terraform.tfstate
cp ../../LOCAL/NP-EUS2-DEP00-INFRASTRUCTURE/sshkey* .
# cat <<EOF > backend.tf
# terraform {
#   backend azurerm {
#     resource_group_name   = "NP-EUS2-SAP_LIBRARY"
#     storage_account_name  = "npeus2tfstate57ba"
#     container_name        = "saplibrary"
#     key                   = "NP-EUS2-SAP0-INFRASTRUCTURE.terraform.tfstate"
#   }
# }
# EOF

vi NP-EUS2-SAP0-INFRASTRUCTURE.json


terraform init                                                                        \
                --backend-config "resource_group_name=NP-EUS2-SAP_LIBRARY"            \
                --backend-config "storage_account_name=npeus2tfstate57ba"             \
                --backend-config "container_name=saplibrary"                          \
                --backend-config "key=NP-EUS2-SAP0-INFRASTRUCTURE.terraform.tfstate"  \
                ../../../sap-hana/deploy/terraform/run/sap_system/

terraform plan                                                                        \
                --var-file=NP-EUS2-SAP0-INFRASTRUCTURE.json                           \
                ../../../sap-hana/deploy/terraform/run/sap_system/

time terraform apply --auto-approve                                                        \
                     --var-file=NP-EUS2-SAP0-INFRASTRUCTURE.json                           \
                     ../../../sap-hana/deploy/terraform/run/sap_system/

# Run Time < 1m

egrep -wi 'resource_group_name|storage_account_name|container_name' .terraform/terraform.tfstate



