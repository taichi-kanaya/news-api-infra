# パブリックALB
resource "aws_lb" "public" {
  name               = "public-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [for subnet in var.public_subnets : subnet.id]
  tags               = var.tags
}

# パブリックALB用ターゲットグループ
resource "aws_lb_target_group" "public_alb" {
  name        = "public-alb-tg"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  tags        = var.tags
}

# ALBリスナー（HTTPからHTTPSへリダレクト）
resource "aws_lb_listener" "http_to_https" {
  load_balancer_arn = aws_lb.public.arn
  port              = "80"
  protocol          = "HTTP"
  tags              = var.tags

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
  tags              = var.tags

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.public_alb.arn
  }
}
