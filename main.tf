resource "aws_vpc" "my-vpc" {
  cidr_block = var.cidr
   tags = {
    Name = "vpct1"
  }
}

resource "aws_subnet" "my-subnet1" {
  vpc_id              = aws_vpc.my-vpc.id
  cidr_block          = "10.0.1.0/24"
  availability_zone   = "us-east-1a"
  map_public_ip_on_launch = true

   tags = {
    Name = "sub1"
  }
}

resource "aws_subnet" "my-subnet2" {  # Removed the space here
  vpc_id              = aws_vpc.my-vpc.id
  cidr_block          = "10.0.2.0/24"
  availability_zone   = "us-east-1b"
  map_public_ip_on_launch = true

   tags = {
    Name = "sub2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my-vpc.id

   tags = {
    Name = "ig"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
   tags = {
    Name = "vpc-rt"
  }
}

resource "aws_route_table_association" "artl1" {
  subnet_id      = aws_subnet.my-subnet1.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "artl2" {
  subnet_id      = aws_subnet.my-subnet2.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "websg" {
  name        = "websg"
  vpc_id      = aws_vpc.my-vpc.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  tags = {
    Name = "websg"
  }
}

resource "aws_s3_bucket" "mys3" {
    bucket = "akhileshterraform2023project" 
  
}

resource "aws_instance" "webserver1" {
  ami                    = "ami-053b0d53c279acc90"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.websg.id]
  subnet_id              = aws_subnet.my-subnet1.id
  user_data              = base64encode(file("userdata.sh"))

  tags = {
    Name = "t-ec2-1"
  }
}

resource "aws_instance" "webserver2" {
  ami                    = "ami-053b0d53c279acc90"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.websg.id]
  subnet_id              = aws_subnet.my-subnet2.id
  user_data              = base64encode(file("userdata1.sh"))

  tags = {
    Name = "t-ec2-2"
  }
}

resource "aws_lb" "my-lb" {
  name               = "akkiforterraform"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.websg.id]
  subnets            = [aws_subnet.my-subnet1.id, aws_subnet.my-subnet2.id]

    
  tags = {
    Name = "t-lb"
  }

}

resource "aws_lb_target_group" "tg" {
  name = "my-tg"
  port = 80

  protocol = "HTTP"
  vpc_id   = aws_vpc.my-vpc.id

  health_check {
    path = "/"
    port = "traffic-port"
  }
  
}

resource "aws_lb_target_group_attachment" "attach1" {
 target_group_arn = aws_lb_target_group.tg.arn
 target_id = aws_instance.webserver1.id
 port = 80

}
resource "aws_lb_target_group_attachment" "attach2" {
 target_group_arn = aws_lb_target_group.tg.arn
 target_id = aws_instance.webserver2.id
 port = 80

}
 resource "aws_lb_listener" "listner" {
  load_balancer_arn = aws_lb.my-lb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.tg.arn
    type = "forward"
  }
   
 }
 output "loadbalancerdns" {
  value = aws_lb.my-lb.dns_name
   
 }