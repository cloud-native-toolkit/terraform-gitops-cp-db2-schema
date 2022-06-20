module "gitops_module" {
  source = "./module"

  gitops_config = module.gitops.gitops_config
  git_credentials = module.gitops.git_credentials
  server_name = module.gitops.server_name
  kubeseal_cert = module.gitops.sealed_secrets_cert
  namespace = module.database-secret.namespace

  secret_name = module.database-secret.secret_name
  host_key = module.database-secret.host_key
  port_key = module.database-secret.port_key
  database_name_key = module.database-secret.database_key
  username_key = module.database-secret.username_key
  password_key = module.database-secret.password_key
  schemas = ["test"]
  customScriptFile = "${path.root}/scripts/maximo-database.sh"
}
