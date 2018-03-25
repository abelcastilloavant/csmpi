DEFAULT_CLOUD_INTERFACES <- list(
  "s3cmd" = s3cmd_interface,
  "aws"   = awscli_interface
)

DEFAULT_DISK_INTERFACES <- list(
  "RDS"       = rds_interface,
  "table"     = table_interface,
  "json"      = json_interface,
  "plaintext" = plaintext_interface
)
