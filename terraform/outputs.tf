output "vpc_id" {
  value = aws_vpc.main.id
}

output "instance_id" {
  value = aws_instance.app.id
}

output "evidence_bucket" {
  value = aws_s3_bucket.evidence.id
}

output "kms_key_arn" {
  value = aws_kms_key.main.arn
}
