data "aws_ssm_parameter" "latest_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# Web instance in subnet A
resource "aws_instance" "web_a" {
  ami                    = var.ami_id != "" ? var.ami_id : data.aws_ssm_parameter.latest_ami.value
  instance_type          = var.instance_type
  subnet_id              = var.web_subnet_a_id
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile   = var.iam_instance_profile

  user_data = <<-EOF
    #!/bin/bash -xe
    yum -y update
    yum install -y httpd wget git
    cd /tmp
    git clone https://github.com/acantril/aws-sa-associate-saac02.git 
    cp ./aws-sa-associate-saac02/11-Route53/r53_zones_and_failover/01_a4lwebsite/* /var/www/html
    usermod -a -G apache ec2-user   
    chown -R ec2-user:apache /var/www
    chmod 2775 /var/www
    find /var/www -type d -exec chmod 2775 {} \;
    find /var/www -type f -exec chmod 0664 {} \;
    systemctl enable httpd
    systemctl start httpd
  EOF

  tags = {
    Name = "A4L-WEB-A"
  }
}

# Web instance in subnet B
resource "aws_instance" "web_b" {
  ami                    = var.ami_id != "" ? var.ami_id : data.aws_ssm_parameter.latest_ami.value
  instance_type          = var.instance_type
  subnet_id              = var.web_subnet_b_id
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile   = var.iam_instance_profile

  user_data = <<-EOF
    #!/bin/bash -xe
    yum -y update
    yum install -y httpd wget git
    cd /tmp
    git clone https://github.com/acantril/aws-sa-associate-saac02.git 
    cp ./aws-sa-associate-saac02/11-Route53/r53_zones_and_failover/01_a4lwebsite/* /var/www/html
    usermod -a -G apache ec2-user   
    chown -R ec2-user:apache /var/www
    chmod 2775 /var/www
    find /var/www -type d -exec chmod 2775 {} \;
    find /var/www -type f -exec chmod 0664 {} \;
    systemctl enable httpd
    systemctl start httpd
    echo "<h1>EC2 Instance B</h1>" >> /var/www/html/index.html
  EOF

  tags = {
    Name = "A4L-WEB-B"
  }
}