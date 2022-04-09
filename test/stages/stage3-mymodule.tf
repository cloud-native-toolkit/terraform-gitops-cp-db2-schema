module "gitops_module" {
  source = "./module"

  gitops_config = module.gitops.gitops_config
  git_credentials = module.gitops.git_credentials
  server_name = module.gitops.server_name
  namespace = var.cpd_namespace
  kubeseal_cert = module.gitops.sealed_secrets_cert
  dbuserpassword = module.db2.defaultuserpaswrd
  DB2Host = module.db2.dbconnectionhost
  #dbname = module.db2.database_name
}
