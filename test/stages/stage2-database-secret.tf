module "database-secret" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-database-secret"

  gitops_config = module.gitops.gitops_config
  git_credentials = module.gitops.git_credentials
  server_name = module.gitops.server_name
  namespace = module.gitops_namespace.name
  kubeseal_cert = module.gitops.sealed_secrets_cert

  database_host = module.db2-warehouse.host
  database_port = module.db2-warehouse.port
  database_name = module.db2-warehouse.database_name
  database_username = module.db2-warehouse.username
  database_password = module.db2-warehouse.password
}
