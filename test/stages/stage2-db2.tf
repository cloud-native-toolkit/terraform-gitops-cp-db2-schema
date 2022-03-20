#module "db2" {
#  source = "github.com/cloud-native-toolkit/terraform-gitops-cp-db2"

#  gitops_config = module.gitops.gitops_config
# git_credentials = module.gitops.git_credentials
#  server_name = module.gitops.server_name
#  namespace = var.cpd_namespace
#  kubeseal_cert = module.gitops.sealed_secrets_cert
# storageClass = var.storageClass
#  database_name = var.database_name
#}