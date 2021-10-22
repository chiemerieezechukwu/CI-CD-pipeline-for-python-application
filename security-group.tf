resource "aws_security_group" "container_sg" {
  name        = local.security_group_name
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc-id

  ingress = [
    {
      description      = "8000 open"
      from_port        = 8000
      to_port          = 8000
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "6379 open"
      from_port        = 6379
      to_port          = 6379
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "all in"
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

}