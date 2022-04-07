locals {
  name          = "cp-db2-schema"
  bin_dir       = module.setup_clis.bin_dir
  yaml_dir      = "${path.cwd}/.tmp/${local.name}/chart/${local.name}"
  #service_url   = "http://${local.name}.${var.namespace}"
  secret_dir    = "${path.cwd}/.tmp/${local.name}/secrets"
  sa_name = var.sa_name
  values_content = {
  jobName = "${local.name}-job" 
  ConfigmapName = "${local.name}-commands-configmap"
  DB2Host = var.DB2Host
  db2_port = var.db2_port
  database_name = var.database_name
  sa_name = local.sa_name
  }
  layer = "services"
  type  = "base"
  application_branch = "main"
  namespace = var.namespace
  layer_config = var.gitops_config[local.layer]
  cpd_namespace = var.cpd_namespace
  
}

module setup_clis {
  source = "github.com/cloud-native-toolkit/terraform-util-clis.git"
}

resource null_resource create_yaml {
  provisioner "local-exec" {
    command = "${path.module}/scripts/create-yaml.sh '${local.name}' '${local.yaml_dir}'"

    environment = {
      VALUES_CONTENT = yamlencode(local.values_content)
    }
  }
}
module "service_account" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-service-account.git"

  gitops_config = var.gitops_config
  git_credentials = var.git_credentials
  namespace = var.cpd_namespace
  name = local.sa_name
  sccs = ["anyuid", "privileged"]
  server_name = var.server_name
}

resource null_resource create_secrets_yaml {
  depends_on = [null_resource.create_yaml]

  provisioner "local-exec" {
    command = "${path.module}/scripts/create-secrets.sh '${var.cpd_namespace}' '${local.secret_dir}'"

    environment = {
      BIN_DIR = module.setup_clis.bin_dir
      DB_USER_PASSWORD = var.dbuserpassword
      
    }
  }
}

module seal_secrets {
  depends_on = [null_resource.create_secrets_yaml]

  source = "github.com/cloud-native-toolkit/terraform-util-seal-secrets.git"

  source_dir    = local.secret_dir
  dest_dir      = "${local.yaml_dir}/templates"
  kubeseal_cert = var.kubeseal_cert
  label         = local.name
}

resource null_resource setup_gitops {
  depends_on = [null_resource.create_yaml,module.service_account]

  triggers = {
    name = local.name
    namespace = var.cpd_namespace
    yaml_dir = local.yaml_dir
    server_name = var.server_name
    layer = local.layer
    type = local.type
    git_credentials = yamlencode(var.git_credentials)
    gitops_config   = yamlencode(var.gitops_config)
    bin_dir = local.bin_dir
  }

  provisioner "local-exec" {
    command = "${self.triggers.bin_dir}/igc gitops-module '${self.triggers.name}' -n '${self.triggers.namespace}' --contentDir '${self.triggers.yaml_dir}' --serverName '${self.triggers.server_name}' -l '${self.triggers.layer}' --type '${self.triggers.type}'"

    environment = {
      GIT_CREDENTIALS = nonsensitive(self.triggers.git_credentials)
      GITOPS_CONFIG   = self.triggers.gitops_config
    }
  }

  provisioner "local-exec" {
    when = destroy
    command = "${self.triggers.bin_dir}/igc gitops-module '${self.triggers.name}' -n '${self.triggers.namespace}' --delete --contentDir '${self.triggers.yaml_dir}' --serverName '${self.triggers.server_name}' -l '${self.triggers.layer}' --type '${self.triggers.type}'"

    environment = {
      GIT_CREDENTIALS = nonsensitive(self.triggers.git_credentials)
      GITOPS_CONFIG   = self.triggers.gitops_config
    }
  }
}
