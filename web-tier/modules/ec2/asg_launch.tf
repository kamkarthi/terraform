resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("web-tier-sshkey.pub")
}

data "template_file" "install-nginx" {
  template = file("${path.module}/install-nginx.sh")
}

resource "aws_launch_configuration" "as_conf" {
  image_id             = data.aws_ami.amazon-linux-2.image_id
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.ec2-iam-profile.name
  key_name             = aws_key_pair.deployer.key_name

  security_groups             = [aws_security_group.web-tier-sg.id]
  associate_public_ip_address = true

  user_data = data.template_file.install-nginx.rendered

  lifecycle {
    create_before_destroy = true
  }

}