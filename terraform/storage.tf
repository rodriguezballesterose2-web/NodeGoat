# ---------- Bucket de evidencias (cifrado con KMS) ----------
resource "aws_s3_bucket" "evidence" {
  #checkov:skip=CKV2_AWS_62:Laboratorio sin consumidor de eventos (SNS SQS o Lambda)
  #checkov:skip=CKV_AWS_144:Replicacion entre regiones propia de produccion y no aplica en LocalStack de una sola region
  bucket = "${var.name}-evidencias-${var.account_id}"
}

resource "aws_s3_bucket_versioning" "evidence" {
  bucket = aws_s3_bucket.evidence.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "evidence" {
  bucket = aws_s3_bucket.evidence.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.main.arn
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "evidence" {
  bucket                  = aws_s3_bucket.evidence.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "evidence" {
  bucket = aws_s3_bucket.evidence.id

  rule {
    id     = "limpieza"
    status = "Enabled"

    filter {}

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }

    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }
}

resource "aws_s3_bucket_logging" "evidence" {
  bucket        = aws_s3_bucket.evidence.id
  target_bucket = aws_s3_bucket.access_logs.id
  target_prefix = "evidencias/"
}

# ---------- Bucket de registros de acceso ----------
resource "aws_s3_bucket" "access_logs" {
  #checkov:skip=CKV2_AWS_62:Laboratorio sin consumidor de eventos (SNS SQS o Lambda)
  #checkov:skip=CKV_AWS_144:Replicacion entre regiones propia de produccion y no aplica en LocalStack de una sola region
  #checkov:skip=CKV_AWS_145:El bucket destino de los registros de acceso de S3 solo admite cifrado SSE-S3
  bucket = "${var.name}-accesos-${var.account_id}"
}

resource "aws_s3_bucket_versioning" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

# El registro de accesos de S3 solo admite cifrado SSE-S3 en el bucket destino
resource "aws_s3_bucket_server_side_encryption_configuration" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "access_logs" {
  bucket                  = aws_s3_bucket.access_logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id

  rule {
    id     = "limpieza"
    status = "Enabled"

    filter {}

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }

    expiration {
      days = 365
    }

    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }
}
