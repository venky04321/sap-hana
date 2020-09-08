#        1         2         3         4         5         6         7         8
#2345678901234567890123456789012345678901234567890123456789012345678901234567890
#--------------------------------------+---------------------------------------8
#                                                                              |
#                            BOOTSTRAP - SAP_LIBRARY                           |
#                                                                              |
#--------------------------------------+---------------------------------------8

# Duration of Task      : 5 minutes

# Prepare

cd ~/Azure_SAP_Automated_Deployment/sap-hana
#git checkout v1.0-beta
git checkout kimforss-naming-module-anydb
git rev-parse HEAD
#eccdcdb8d44fa1f77572e420ce27abac199245f4
mv deploy/terraform/terraform-units/modules/sap_system/common_infrastructure/keyvault.tf \
   deploy/terraform/terraform-units/modules/sap_system/common_infrastructure/keyvault.txt


#---------------------------------------+---------------------------------------8

mkdir -p ~/Azure_SAP_Automated_Deployment/WORKSPACES/SAP_LIBRARY/NP-EUS2-SAP_LIBRARY; cd $_

# cat <<EOF > backend.tf
# terraform {
#   backend "local" {
#     path      = null
#     workspace = null
#   }
# }
# EOF

vi NP-EUS2-SAP_LIBRARY.json


terraform init  ../../../sap-hana/deploy/terraform/bootstrap/sap_library/

terraform plan                                                                  \
                --var-file=NP-EUS2-SAP_LIBRARY.json                             \
                ../../../sap-hana/deploy/terraform/bootstrap/sap_library

time terraform apply                                                                 \
                     --auto-approve                                                  \
                     --var-file=NP-EUS2-SAP_LIBRARY.json                             \
                     ../../../sap-hana/deploy/terraform/bootstrap/sap_library/

# Run Time < 1m

egrep -wi 'resource_group_name|storage_account_name|container_name' terraform.tfstate



