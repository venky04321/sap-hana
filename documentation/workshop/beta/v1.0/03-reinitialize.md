#        1         2         3         4         5         6         7         8
#2345678901234567890123456789012345678901234567890123456789012345678901234567890
#--------------------------------------+---------------------------------------8
#                                                                              |
#                         REINITIALIZE - SAP_LIBRARY                           |
#                                                                              |
#--------------------------------------+---------------------------------------8

# Duration of Task      : 3 minutes


# cat <<EOF > backend.tf
# terraform {
#   backend azurerm {
#     resource_group_name   = "NP-EUS2-SAP_LIBRARY"
#     storage_account_name  = "npeus2tfstate57ba"
#     container_name        = "saplibrary"
#     key                   = "NP-EUS2-SAP_LIBRARY.terraform.tfstate"
#   }
# }
# EOF


terraform init                                                                             \
               --backend-config "resource_group_name=NP-EUS2-SAP_LIBRARY"                  \
               --backend-config "storage_account_name=npeus2tfstate57ba"                   \
               --backend-config "container_name=saplibrary"                                \
               --backend-config "key=NP-EUS2-SAP_LIBRARY.terraform.tfstate"                \
               ../../../sap-hana/deploy/terraform/run/sap_deployer/

rm terraform.tfstate*

terraform plan                                                                             \
                --var-file=NP-EUS2-SAP_LIBRARY.json                                        \
                ../../../sap-hana/deploy/terraform/run/sap_library 

time terraform apply                                                                            \
                     --auto-approve                                                             \
                     --var-file=NP-EUS2-SAP_LIBRARY.json                                        \
                     ../../../sap-hana/deploy/terraform/run/sap_library/

# Run Time < 1m

egrep -wi 'resource_group_name|storage_account_name|container_name' .terraform/terraform.tfstate



#--------------------------------------+---------------------------------------8
#                                                                              |
#                            REINITIALIZE - DEP00                           |
#                                                                              |
#--------------------------------------+---------------------------------------8

# Duration of Task      : 3 minutes

cd ~/Azure_SAP_Automated_Deployment/WORKSPACES/LOCAL/NP-EUS2-DEP00-INFRASTRUCTURE
egrep -wi 'resource_group_name|storage_account_name|container_name' ../../SAP_LIBRARY/NP-EUS2-SAP_LIBRARY/.terraform/terraform.tfstate

# cat <<EOF > backend.tf
# terraform {
#   backend azurerm {
#     resource_group_name   = "NP-EUS2-SAP_LIBRARY"
#     storage_account_name  = "npeus2tfstate57ba"
#     container_name        = "saplibrary"
#     key                   = "NP-EUS2-DEP00-INFRASTRUCTURE.terraform.tfstate"
#   }
# }
# EOF


terraform init                                                                           \
               --backend-config "resource_group_name=NP-EUS2-SAP_LIBRARY"                \
               --backend-config "storage_account_name=npeus2tfstate57ba"                 \
               --backend-config "container_name=saplibrary"                              \
               --backend-config "key=NP-EUS2-DEP00-INFRASTRUCTURE.terraform.tfstate"  \
               ../../../sap-hana/deploy/terraform/run/sap_deployer/

rm terraform.tfstate*

terraform plan                                                                           \
                --var-file=NP-EUS2-DEP00-INFRASTRUCTURE.json                          \
                ../../../sap-hana/deploy/terraform/run/sap_deployer/

time terraform apply --auto-approve                                                           \
                     --var-file=NP-EUS2-DEP00-INFRASTRUCTURE.json                          \
                     ../../../sap-hana/deploy/terraform/run/sap_deployer/

# Run Time < 1m

egrep -wi 'resource_group_name|storage_account_name|container_name' .terraform/terraform.tfstate



