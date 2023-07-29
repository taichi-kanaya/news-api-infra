# パブリックALB
resource "aws_lb" "public" {
  name               = "public-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [for subnet in var.public_subnets : subnet.id]
  security_groups    = [var.alb_security_group_id]
}

# パブリックALB用ターゲットグループ
resource "aws_lb_target_group" "public_alb" {
  name        = "public-alb-tg"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
}

# ALBリスナー（HTTPからHTTPSへリダレクト）
resource "aws_lb_listener" "http_to_https" {
  load_balancer_arn = aws_lb.public.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# ALBリスナー（HTTPS通信をターゲットグループへ）
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.public.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.ssl_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.public_alb.arn
  }
}

# パブリックALBのAレコードを追加
resource "aws_route53_record" "public_alb" {
  zone_id = var.public_hostzone_id
  name    = "${var.app_name}.${var.domain_name}"
  type    = "A"
  alias {
    name                   = aws_lb.public.dns_name
    zone_id                = aws_lb.public.zone_id
    evaluate_target_health = true
  }
}
