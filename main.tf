locals {
  name          = "db2-schema"
  bin_dir       = module.setup_clis.bin_dir
  yaml_dir      = "${path.cwd}/.tmp/${local.name}/chart/${local.name}"
  secret_dir    = "${path.cwd}/.tmp/${local.name}/secrets"
  sa_name = "db2-schema"
  secret_name = "db2-credentials"
  custom_script = var.customScriptFile != "" ? file(var.customScriptFile) : var.customScript
  values_content = {
    serviceAccount = {
      create = false
      name = local.sa_name
    }
    secret = {
      create = false
      name = local.secret_name
    }
    customScript = local.custom_script
  }
  layer = "services"
  type  = "base"
  application_branch = "main"
  namespace = var.namespace
  layer_config = var.gitops_config[local.layer]
}

module setup_clis {
  source = "cloud-native-toolkit/clis/util"
  version = "1.16.1"
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
  server_name = var.server_name
  namespace = var.namespace
  name = local.sa_name
  sccs = ["anyuid", "privileged"]
}

resource null_resource setup_gitops {
  depends_on = [null_resource.create_yaml,module.service_account]

  triggers = {
    name = local.name
    namespace = var.namespace
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
