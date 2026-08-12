data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "web" {
  count                       = var.instance_count
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public[count.index % length(aws_subnet.public)].id
  vpc_security_group_ids      = [aws_security_group.web.id]
  key_name                    = var.key_name != "" ? var.key_name : null
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    dnf update -y
    dnf install -y httpd
    systemctl enable httpd
    systemctl start httpd
 
    TOKEN=$(curl -Ss -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
    AZ=$(curl -Ss -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone)
    IID=$(curl -Ss -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
 
    cat > /var/www/html/index.html <<HTML
    <html>
      <head><title>CI/CD Demo</title></head>
      <body style="font-family: sans-serif; text-align:center; margin-top:80px;">
        <h1>Hello from Apache!</h1>
        <p>Instance ID: $IID</p>
        <p>Availability Zone: $AZ</p>
      </body>
    </html>
    HTML
  EOF

  tags = {
    Name = "${var.project_name}-web-${count.index + 1}"
  }
}
