
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
  description = "Namespace where cp4d is provisioned and where the db2 is created"
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

variable "dbuser" {
  type        = string
  description = "The db2inst1 user"
  default = "db2inst1"
}

variable "dbuserpassword" {
  type        = string
  description = "The db2inst1 user password"
  sensitive   = true
}

variable "cpd_namespace" {
  type        = string
  description = "Namespace for cpd services"
  default = "gitops-cp4d-instance"
}

variable "cp4dclusterhost" {
  type        = string
  description = "The service name for cp4d"
  default     = "https://ibm-nginx-svc"
}

variable "db2_ssl_port" {
  type        = number
  description = " The port number of the Db2 secure sockets layer (SSL) instance"
  default     = 50001
}

variable "database_name" {
  type        = string
  description = "Name of database created by DB2 instance"
  default     = "NAME"
}



