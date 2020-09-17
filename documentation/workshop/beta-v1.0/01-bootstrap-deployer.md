#        1         2         3         4         5         6         7         8
#2345678901234567890123456789012345678901234567890123456789012345678901234567890
#--------------------------------------+---------------------------------------8
#                                                                              |
#                              BOOTSTRAP - DEP00                               |
#                                                                              |
#--------------------------------------+---------------------------------------8

Duration of Task: `12 minutes`

from the portal, open the cloud shell.

1. ensure that you are authenticated fro the correct subscription
    ```bash
    az login
    az account list --output=table | grep -i true
    ```
    If not, then find and set the Default to the correct subscription.
    ```
    az account list --output=table
    az account set --subscription XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
    ```


2. Install the correct version of Terraform.
    ```
    mkdir ~/bin; cd $_
    alias terraform=~/bin/terraform
    wget https://releases.hashicorp.com/terraform/0.12.29/terraform_0.12.29_linux_amd64.zip
    unzip terraform_0.12.29_linux_amd64.zip
    ```


3. Clone the Repository and Checkout the branch.
    ```
    mkdir -p ~/Azure_SAP_Automated_Deployment; cd $_
    git clone https://github.com/Azure/sap-hana.git
    cd ~/Azure_SAP_Automated_Deployment/sap-hana
    ```
    Checkout Branch
    ```
    #git checkout v1.0-beta
    git checkout kimforss-naming-module-anydb
    ```
    Verify Brabch is at expected Revision: `eccdcdb8d44fa1f77572e420ce27abac199245f4`
    ```
    git rev-parse HEAD
    ```

```
mkdir -p ~/Azure_SAP_Automated_Deployment/WORKSPACES/LOCAL/NP-EUS2-DEP00-INFRASTRUCTURE; cd $_
#ssh-keygen -q -t rsa -C "Deploy Platform" -f sshkey
mv ~/sshkey* .
chmod 600 sshkey
```

```
vi NP-EUS2-DEP00-INFRASTRUCTURE.json
```

```
terraform init  ../../../sap-hana/deploy/terraform/bootstrap/sap_deployer/
```

```
terraform plan                                                               \
                --var-file=NP-EUS2-DEP00-INFRASTRUCTURE.json                 \
                ../../../sap-hana/deploy/terraform/bootstrap/sap_deployer/
```

```
time terraform apply --auto-approve                                               \
                     --var-file=NP-EUS2-DEP00-INFRASTRUCTURE.json                 \
                     ../../../sap-hana/deploy/terraform/bootstrap/sap_deployer/
```

# Run Time ~ 5m

```
./post_deployment.sh
```

