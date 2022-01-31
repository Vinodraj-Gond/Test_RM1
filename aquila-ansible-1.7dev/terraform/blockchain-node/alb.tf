resource "aws_lb" "application-load-balancer" {
  name = "alb-${random_id.postfix.hex}"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb-security-group.id]
  subnet_mapping {
  subnet_id = var.public1_subnet_id
}
subnet_mapping {
  subnet_id = var.public2_subnet_id
}

enable_deletion_protection = false


tags = {
Environment = "staging"
}
}

resource "aws_lb_target_group" "alb-target-group" {
  name        = "aquila-http-${random_id.postfix.hex}"
  target_type = "instance"
  port        = 80
  protocol = "HTTP"
  vpc_id      = var.vpc_id
  
health_check {
        healthy_threshold  = 5
        interval           = 30
        matcher            = "200,302"
        path               = "/"
        port               = "traffic-port"
        protocol           = "HTTP"
        #protocol_version   = "HTTP"
        timeout            = 5
        unhealthy_threshold = 2
}
}


resource "aws_lb_target_group_attachment" "alb-target-group" {
  target_group_arn = aws_lb_target_group.alb-target-group.arn
  target_id        = aws_instance.aquila.id
  port             = 80
}



resource "aws_lb_listener" "alb-listener-no-ssl-certificate" {
  load_balancer_arn = aws_lb.application-load-balancer.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "redirect"

    redirect {
      host          =  "#{host}"
      path          =  "/#{path}"
      port          =  "443"
      protocol      = "HTTPS"
      status_code   =  "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "alb-listener-ssl-certificate" {
  load_balancer_arn = aws_lb.application-load-balancer.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb-target-group.arn
  }
}  



resource "aws_security_group" "alb-security-group" {
  name        = "ALB Security Group_${random_id.postfix.hex}"
  description = "Enable HTTP/HTTPS access on Port 80/443"
  vpc_id      = var.vpc_id

  ingress {
    description      = "HTTP Access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "HTTPS Access"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "ELB Security Group"
  }
}