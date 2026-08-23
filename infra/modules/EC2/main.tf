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
}
