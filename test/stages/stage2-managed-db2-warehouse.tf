module "db2-warehouse" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-db2-warehouse"

  resource_group_name = module.resource_group.name
  resource_location   = "us-south"
  tags                = []
}
