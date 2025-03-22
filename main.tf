terraform {
required_providers { aws =
{ source =
&quot;hashicorp/aws&quot; version
= &quot;~&gt; 5.0&quot;
}
}
}

# Configure the AWS Provider
provider &quot;aws&quot; { region =
&quot;us-east-1&quot;
}

# Create a VPC resource
&quot;aws_vpc&quot; &quot;example&quot; {
cidr_block = &quot;10.0.0.0/16&quot;
enable_dns_support = true
enable_dns_hostnames = true

tags = {
Name = &quot;ExampleVPC&quot;
}
}

# Create Subnet 1 (Public) resource
&quot;aws_subnet&quot; &quot;subnet1&quot; {
vpc_id = aws_vpc.example.id
cidr_block = &quot;10.0.1.0/24&quot;
map_public_ip_on_launch = true
availability_zone = &quot;us-east-1a&quot;

tags = {
Name = &quot;Subnet1-Public&quot;
}
}

# Create Subnet 2 (Private) resource
&quot;aws_subnet&quot; &quot;subnet2&quot; { vpc_id
= aws_vpc.example.id cidr_block
= &quot;10.0.2.0/24&quot; availability_zone =
&quot;us-east-1b&quot;

tags = {
Name = &quot;Subnet2-Private&quot;
}
}

# Create an Additional Public Subnet
resource &quot;aws_subnet&quot; &quot;public&quot; { vpc_id

= aws_vpc.example.id cidr_block =
&quot;10.0.3.0/24&quot; map_public_ip_on_launch =
true availability_zone = &quot;us-east-1c&quot;

tags = {
Name = &quot;PublicSubnet&quot;
}
}

# Create an Internet Gateway resource
&quot;aws_internet_gateway&quot; &quot;igw&quot; { vpc_id
= aws_vpc.example.id

tags = {
Name = &quot;InternetGateway&quot;
}
}

# Create a Route Table for Public Subnets
resource &quot;aws_route_table&quot; &quot;public_rt&quot; {
vpc_id = aws_vpc.example.id

route { cidr_block = &quot;0.0.0.0/0&quot;
gateway_id = aws_internet_gateway.igw.id
}

tags = {
Name = &quot;PublicRouteTable&quot;
}
}

# Associate Route Table with Public Subnet 1
resource &quot;aws_route_table_association&quot; &quot;subnet1_association&quot;
{ subnet_id = aws_subnet.subnet1.id route_table_id =
aws_route_table.public_rt.id
}

# Associate Route Table with Public Subnet (Additional)
resource &quot;aws_route_table_association&quot; &quot;public_association&quot;
{ subnet_id = aws_subnet.public.id route_table_id =
aws_route_table.public_rt.id
}

# Create a Security Group for SSH Access
resource &quot;aws_security_group&quot; &quot;allow_ssh&quot; {
vpc_id = aws_vpc.example.id

ingress {
description = &quot;Allow SSH&quot;
from_port = 22
to_port = 22

protocol = &quot;tcp&quot;
cidr_blocks = [&quot;0.0.0.0/0&quot;]
}

egress { from_port = 0
to_port = 0 protocol =
&quot;-1&quot; cidr_blocks =
[&quot;0.0.0.0/0&quot;]
}

tags = {
Name = &quot;AllowSSH&quot;
}
}

# Create an EC2 Instance in Subnet 1 (Public)
resource &quot;aws_instance&quot; &quot;example1&quot; {
ami = &quot;ami-0c55b159cbfafe1f0&quot; # Change this to your preferred
AMI
instance_type = &quot;t2.micro&quot;
subnet_id = aws_subnet.subnet1.id
security_groups = [aws_security_group.allow_ssh.name]
associate_public_ip_address = true

tags = {
Name = &quot;ExampleInstance1&quot;

}
}

# Create an EC2 Instance in Subnet 2 (Private)
resource &quot;aws_instance&quot; &quot;example2&quot; {
ami = &quot;ami-0c55b159cbfafe1f0&quot; # Change this to your preferred
AMI
instance_type = &quot;t2.micro&quot;
subnet_id = aws_subnet.subnet2.id
security_groups = [aws_security_group.allow_ssh.name]

tags = {
Name = &quot;ExampleInstance2&quot;
}
}

# Create an EC2 Instance in the Public Subnet
resource &quot;aws_instance&quot; &quot;example3&quot; {
ami = &quot;ami-0c55b159cbfafe1f0&quot; # Change this to your preferred
AMI
instance_type = &quot;t2.micro&quot;
subnet_id = aws_subnet.public.id
security_groups = [aws_security_group.allow_ssh.name]
associate_public_ip_address = true

tags = {
Name = &quot;ExampleInstance3&quot;

}
}
#terraform init
#terraform validate
#terraform plan
#terraform apply
#terraform destroy

Cheatsheet -
https://registry.terraform.io/providers/hashicorp/aws/latest/docs
