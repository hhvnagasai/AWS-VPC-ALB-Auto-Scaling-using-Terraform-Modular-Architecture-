resource "aws_instance" "ami_source" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  vpc_security_group_ids = [var.security_group_id]

  associate_public_ip_address = false

  user_data = <<-EOF
              #!/bin/bash
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "Hello from ASG Instance" > /var/www/html/index.html
              EOF

  tags = {
    Name = "AMI-Source-Instance"
  }
}
