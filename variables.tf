
variable "gitops_config" {
  type        = object({
    boostrap = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
    })
    infrastructure = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
    services = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
    applications = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
  })
  description = "Config information regarding the gitops repo structure"
}

variable "git_credentials" {
  type = list(object({
    repo = string
    url = string
    username = string
    token = string
  }))
  description = "The credentials for the gitops repo(s)"
  sensitive   = true
}

variable "kubeseal_cert" {
  type        = string
  description = "The certificate/public key used to encrypt the sealed secrets"
  default     = ""
}

variable "server_name" {
  type        = string
  description = "The name of the server"
  default     = "default"
}

variable "namespace" {
  type        = string
  description = "Namespace where the database secret has been provisioned"
}

variable "secret_name" {
  type        = string
  description = "The name of the secret that contains the credentials for the database"
}

variable "username_key" {
  type        = string
  description = "The key in the provided secret used for the username"
  default     = "username"
}

variable "password_key" {
  type        = string
  description = "The key in the provided secret used for the password"
  default     = "password"
}

variable "host_key" {
  type        = string
  description = "The key in the provided secret used for the host"
  default     = "host"
}

variable "port_key" {
  type        = string
  description = "The key in the provided secret used for the port"
  default     = "port"
}

variable "database_name_key" {
  type        = string
  description = "The key in the provided secret used for the database name"
  default     = "database"
}

variable "schemas" {
  type        = list(string)
  description = "The list of schemas that should be added to the database"
  default     = []
}

variable "customScriptFile" {
  type        = string
  description = "The path to the file containing the custom script that should be run against the database. The script can either be provided in a file or as a string in the `customScript` variable."
  default     = ""
}

variable "customScript" {
  type        = string
  description = "The contents of the custom script that should be run against the database. The script can either be provided as a string or in a file via the `customScriptFile` variable."
  default     = ""
}
