resource "aws_security_group" "container_sg" {
  name        = local.security_group_name_app
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc-id
  depends_on  = [aws_security_group.lb_sg, ]
  lifecycle { create_before_destroy = true }
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

resource "aws_security_group" "lb_sg" {
  name        = local.security_group_name_lb
  description = "Allow load balancer traffic"
  vpc_id      = var.vpc-id

  ingress = [
    {
      description      = "http open"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
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

resource "aws_security_group" "redis_sg" {
  name        = local.security_group_name_redis
  description = "open port for redis"
  vpc_id      = var.vpc-id
  depends_on  = [aws_security_group.container_sg, ]
  ingress = [
    {
      description      = "6379 open for redis"
      from_port        = 6379
      to_port          = 6379
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
      security_groups  = ["${aws_security_group.container_sg.id}", ]
    },
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