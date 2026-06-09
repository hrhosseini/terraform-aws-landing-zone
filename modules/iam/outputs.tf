output "admin_role_arn" {
  description = "ARN of the administrator role (null when not created)."
  value       = try(aws_iam_role.admin[0].arn, null)
}

output "admin_role_name" {
  description = "Name of the administrator role (null when not created)."
  value       = try(aws_iam_role.admin[0].name, null)
}

output "readonly_role_arn" {
  description = "ARN of the read-only role (null when not created)."
  value       = try(aws_iam_role.readonly[0].arn, null)
}

output "readonly_role_name" {
  description = "Name of the read-only role (null when not created)."
  value       = try(aws_iam_role.readonly[0].name, null)
}

output "developer_role_arn" {
  description = "ARN of the developer role (null when not created)."
  value       = try(aws_iam_role.developer[0].arn, null)
}

output "developer_role_name" {
  description = "Name of the developer role (null when not created)."
  value       = try(aws_iam_role.developer[0].name, null)
}
