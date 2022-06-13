
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

variable "namespace" {
  type        = string
  description = "Namespace where the job will be deployed"
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

variable "database_username" {
  type        = string
  description = "The username for the database instance"
}

variable "database_password" {
  type        = string
  description = "The password for the database instance"
  sensitive   = true
}

variable "database_host" {
  type        = string
  description = "The host for the database instance"
}

variable "database_port" {
  type        = number
  description = " The port number of the database secure sockets layer (SSL)"
  default     = 50000
}

variable "database_name" {
  type        = string
  description = "Name of database created for instance"
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
