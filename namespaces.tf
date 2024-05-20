resource "aws_service_discovery_http_namespace" "default" {
  name        = var.name
  description = "CloudMap namespace for ${var.name}"

  tags = local.tags
}
