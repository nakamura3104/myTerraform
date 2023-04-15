variable "condition" {
  default = true
}

locals {
  json_content = templatefile("example.json.tmpl", { condition = var.condition })
}

output "json_output" {
  value = local.json_content
}
