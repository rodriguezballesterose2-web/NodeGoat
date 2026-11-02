# ---------- Clave KMS (cifrado de S3, disco y logs) ----------
data "aws_iam_policy_document" "kms" {
  #checkov:skip=CKV_AWS_109:En una politica de clave KMS el recurso * es la propia clave y el permiso de la cuenta raiz es la politica estandar anti bloqueo
  #checkov:skip=CKV_AWS_111:En una politica de clave KMS el recurso * es la propia clave y el permiso de la cuenta raiz es la politica estandar anti bloqueo
  #checkov:skip=CKV_AWS_356:En una politica de clave KMS el recurso * es la propia clave y es obligatorio
  statement {
    sid       = "AdministracionCuenta"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.account_id}:root"]
    }
  }

  statement {
    sid = "UsoCloudWatchLogs"
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*",
    ]
    resources = ["*"]

    principals {
      type        = "Service"
      identifiers = ["logs.${var.region}.amazonaws.com"]
    }
  }
}

resource "aws_kms_key" "main" {
  description             = "Clave de cifrado de ${var.name}"
  enable_key_rotation     = true
  deletion_window_in_days = 30
  policy                  = data.aws_iam_policy_document.kms.json
}

resource "aws_kms_alias" "main" {
  name          = "alias/${var.name}"
  target_key_id = aws_kms_key.main.key_id
}

# ---------- Rol de la instancia (minimo privilegio) ----------
data "aws_iam_policy_document" "ec2_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_cloudwatch_log_group" "app" {
  name              = "/${var.name}/app"
  retention_in_days = 365
  kms_key_id        = aws_kms_key.main.arn
}

data "aws_iam_policy_document" "app" {
  statement {
    sid       = "LeerEscribirEvidencias"
    actions   = ["s3:GetObject", "s3:PutObject"]
    resources = ["${aws_s3_bucket.evidence.arn}/*"]
  }

  statement {
    sid       = "UsarClaveKms"
    actions   = ["kms:Decrypt", "kms:GenerateDataKey"]
    resources = [aws_kms_key.main.arn]
  }

  statement {
    sid       = "EscribirLogsDeLaApp"
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["${aws_cloudwatch_log_group.app.arn}:*"]
  }
}

resource "aws_iam_policy" "app" {
  name   = "${var.name}-app-policy"
  policy = data.aws_iam_policy_document.app.json
}

resource "aws_iam_role" "app" {
  name               = "${var.name}-app-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
}

resource "aws_iam_role_policy_attachment" "app" {
  role       = aws_iam_role.app.name
  policy_arn = aws_iam_policy.app.arn
}

resource "aws_iam_instance_profile" "app" {
  name = "${var.name}-app-profile"
  role = aws_iam_role.app.name
}

# ---------- Rol de los flow logs de la VPC ----------
data "aws_iam_policy_document" "flow_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "flow" {
  statement {
    sid = "EscribirFlowLogs"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
    ]
    resources = ["${aws_cloudwatch_log_group.flow.arn}:*"]
  }
}

resource "aws_iam_policy" "flow" {
  name   = "${var.name}-flow-policy"
  policy = data.aws_iam_policy_document.flow.json
}

resource "aws_iam_role" "flow" {
  name               = "${var.name}-flow-role"
  assume_role_policy = data.aws_iam_policy_document.flow_assume.json
}

resource "aws_iam_role_policy_attachment" "flow" {
  role       = aws_iam_role.flow.name
  policy_arn = aws_iam_policy.flow.arn
}
