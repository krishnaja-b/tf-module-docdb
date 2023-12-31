resource "aws_docdb_cluster" "main" {
  cluster_identifier      = "${var.env}-docdb"
  engine                  = "var.engine"
  master_username         = "data.aws_ssm_parameter.user.value"
  master_password         = "data.aws_ssm_parameter.pass.value"
  backup_retention_period = "var.backup_retention_period"
  preferred_backup_window = "var.preferred_backup_window"
  skip_final_snapshot     = "var.skip_final_snapshot"
  db_subnet_group_name =  aws_docdb_subnet_group.main.name
  kms_key_id = data.aws_kms_key.key.key_id
  storage_encrypted = var.storage_encrypted
}
resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = 2
  identifier         = "${var.env}-docdb-${count.index}"
  cluster_identifier = aws_docdb_cluster.main.id
  instance_class     = var.instance_class
}

resource "aws_docdb_subnet_group" "main" {
  name       = "${var.env}-docdb"
  subnet_ids = var.subnet_ids
  tags = merge(
    var.tags,
    { Name = "${var.env}-subnet-group" }
  )
}
