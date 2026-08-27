module "ec2-instance" {
    source = "terraform-aws-modules/ec2-instance/aws"
    version = "6.4.0"

    subnet_id = var.subnet_id # from VPC module
    # IAM role for SSM
    create_iam_instance_profile = true
    iam_role_description        = "IAM role for EC2 instance for SSM"
    iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    }

    vpc_security_group_ids = var.vpc_security_group_ids # from module ec2_security_group

    tags = {
        Name = "l2c-ec2-instance"
    }
}

//Pull file from S3 and run it on EC2 instance via SSM
resource "null_resource" "init_db" {
  depends_on = [aws_s3_object.db_setup_file, module.ec2-instance]

  provisioner "local-exec" {
    command = <<EOT
      instance_id = ${terraform output -raw instance_id}
      aws ssm send-command \
        --instance-ids $instance_id \
        --document-name "AWS-RunShellScript" \
        --parameters commands='["aws s3 cp s3://${aws_s3_bucket.l2c_bucket.id}/database_setup.sql /home/ec2-user"]'
    EOT
  }
}