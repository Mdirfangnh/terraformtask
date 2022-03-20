#this is my assignment provide by " the Cloud world " .
#assignment task:
#1. creat a vpc
#2. creat internet getaway inside vpc
#3. creat tow subnet inside vpc
#4. creat route table inside vpc
#5. creat route inside vpc
#6. creat route associate subnet  inside vpc
#7. creat tow ec2
#8. creat key pair



#######creating provider######
provider "aws" {
  region     = "us-west-2"
  access_key = "my-access-key"
  secret_key = "my-secret-key"
}
#######creating vpc #######
resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
}

########creating internet getway ####

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "internet getway"
  }
}

#####creating subnet 1 #######
resource "aws_subnet" "subnet1" {
  vpc_id = aws_vpc.myvpc.id
  
}
######creating rout table #####
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.myvpc.id

  route = []

  tags = {
    Name = "rout table"
  }
}

######creating rout #######
resource "aws_route" "rout" {
  route_table_id            = aws_rout_table.rt.id
  destination_cidr_block    = "10.0.1.0/22"
  vpc_peering_connection_id = "pcx-45ff3dc1"
  depends_on                = [aws_route_table.rt]
}

#######creating route table assosiat ##

resource "aws_route_table_association" "subnet1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.rt.id
}
resource "aws_route_table_association" "subnet 2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.rt.id
}

###creating securty group####
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [aws_vpc.myvpc.cidr_block]
    ipv6_cidr_blocks = [aws_vpc.myvpc.ipv6_cidr_block]
    ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = null
      self             = null
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "Outbound rule"
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  }

  tags = {
    Name = "allow_tls"
  }
}

#####creating ec2 instence#####
resource "aws_instance" "ec2" {
  ami           = e8goyr8isfjdkl
  instance_type = "t3.micro"
  subnet_id   = aws_subnet.subnet1.id

  tags = {
    Name = "my first ec2"
  }
}


#####creating subnet 2#######
resource "aws_subnet" "subnet2" {
  vpc_id = aws_vpc.myvpc.id
  
}


#####creating ec2 instence with key pair#####
resource "aws_instance" "ec2_1" {
   ami           = "ami-0c2b8ca1dad447f8a"
   instance_type = "t2.micro"
   subnet_id     = aws_subnet.subnet1.id
   key_name = "dev-account"
   tags = {
     Name = "my first ec2"
   }
 }
 
 resource "aws_instance" "ec2_1" {
   ami           = "ami-0c2b8ca1dad447f8a"
   instance_type = "t2.micro"
   subnet_id     = aws_subnet.subnet2.id
   key_name = "dev-account"
   tags = {
     Name = "my second ec2"
   }
 }


