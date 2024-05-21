resource "aws_service_discovery_http_namespace" "default" {
  name        = local.name
  description = "CloudMap namespace for ${local.name}"

  tags = local.tags
}
