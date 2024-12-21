output "PRIVATE_ALB_ARN" {
  value = aws_lb.private-alb.arn
}

output "PUBLIC_ALB_ARN" {
  value = aws_lb.public-alb.arn
}

output "PRIVATE_ALB_DNS" {
  value = aws_lb.private-alb.dns_name
}

output "PUBLIC_ALB_DNS" {
  value = aws_lb.public-alb.dns_name
}
