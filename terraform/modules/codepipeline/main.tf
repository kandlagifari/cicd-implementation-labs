resource "aws_codestarconnections_connection" "this" {
  name          = var.connection_name
  provider_type = var.connection_provider
}
