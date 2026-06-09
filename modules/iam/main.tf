data "aws_caller_identity" "current" {}

locals {
  # Trust the current account root by default so the module is usable without
  # the caller having to know principal ARNs up front. Override in production
  # with specific principals via `trusted_principal_arns`.
  trusted_principals = length(var.trusted_principal_arns) > 0 ? var.trusted_principal_arns : ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = local.trusted_principals
    }

    dynamic "condition" {
      for_each = var.require_mfa ? [1] : []
      content {
        test     = "Bool"
        variable = "aws:MultiFactorAuthPresent"
        values   = ["true"]
      }
    }
  }
}

# --- Administrator role -----------------------------------------------------
resource "aws_iam_role" "admin" {
  count = var.create_admin_role ? 1 : 0

  name                 = "${var.name_prefix}-admin"
  description          = "Full administrator access (assume-role)."
  assume_role_policy   = data.aws_iam_policy_document.assume_role.json
  max_session_duration = var.max_session_duration
  tags                 = var.tags
}

resource "aws_iam_role_policy_attachment" "admin" {
  count = var.create_admin_role ? 1 : 0

  role       = aws_iam_role.admin[0].name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# --- Read-only role ---------------------------------------------------------
resource "aws_iam_role" "readonly" {
  count = var.create_readonly_role ? 1 : 0

  name                 = "${var.name_prefix}-readonly"
  description          = "Read-only access to the account (assume-role)."
  assume_role_policy   = data.aws_iam_policy_document.assume_role.json
  max_session_duration = var.max_session_duration
  tags                 = var.tags
}

resource "aws_iam_role_policy_attachment" "readonly" {
  count = var.create_readonly_role ? 1 : 0

  role       = aws_iam_role.readonly[0].name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# --- Developer role (optional) ----------------------------------------------
resource "aws_iam_role" "developer" {
  count = var.create_developer_role ? 1 : 0

  name                 = "${var.name_prefix}-developer"
  description          = "Developer access (assume-role)."
  assume_role_policy   = data.aws_iam_policy_document.assume_role.json
  max_session_duration = var.max_session_duration
  tags                 = var.tags
}

resource "aws_iam_role_policy_attachment" "developer" {
  # One attachment per managed policy ARN in developer_managed_policy_arns.
  for_each = var.create_developer_role ? toset(var.developer_managed_policy_arns) : []

  role       = aws_iam_role.developer[0].name
  policy_arn = each.value
}
