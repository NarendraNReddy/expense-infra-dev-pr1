resource "aws_key_pair" "vpn" {
  key_name   = "vpn"
  public_key = file("~/.ssh/openvpn.pub")
}

module "vpn" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.project_name}-${var.environment}-vpn"

  instance_type          = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]
  # convert StringList to list and get first element
  subnet_id = local.public_subnet_id
  ami = data.aws_ami.ami_info.id
  #user_data = file("bastion.sh")
  key_name = aws_key_pair.vpn.key_name
  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-vpn"
    }
  )
}