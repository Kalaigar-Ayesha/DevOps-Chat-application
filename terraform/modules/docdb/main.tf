resource "aws_security_group" "docdb" {
  name        = "${var.name_prefix}-docdb-sg"
  description = "DocumentDB SG"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.name_prefix}-docdb-sg" }
}

resource "aws_docdb_subnet_group" "this" {
  name       = "${var.name_prefix}-docdb-subnets"
  subnet_ids = var.db_subnet_ids

  tags = {
    Name = "${var.name_prefix}-docdb-subnets"
  }
}

resource "aws_docdb_cluster_parameter_group" "this" {
  name        = "${var.name_prefix}-docdb-params"
  family      = "docdb5.0"
  description = "Parameters for chatapp DocumentDB"

  # Keep TLS enabled (default). App tier user-data installs CA bundle and uses tls=true.
}

resource "aws_docdb_cluster" "this" {
  cluster_identifier              = "${var.name_prefix}-docdb"
  master_username                 = var.master_username
  master_password                 = var.master_password
  db_subnet_group_name            = aws_docdb_subnet_group.this.name
  vpc_security_group_ids          = [aws_security_group.docdb.id]
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.this.name
  engine                          = "docdb"
  storage_encrypted               = true
  backup_retention_period         = 7
  preferred_backup_window         = "02:00-04:00"
  preferred_maintenance_window    = "sun:04:30-sun:05:00"
  skip_final_snapshot             = true
}

resource "aws_docdb_cluster_instance" "instances" {
  count              = var.instance_count
  identifier         = "${var.name_prefix}-docdb-${count.index + 1}"
  cluster_identifier = aws_docdb_cluster.this.id
  instance_class     = var.instance_class
}


