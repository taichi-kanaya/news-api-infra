# コストアラートはバージニア北部でのみ利用可能
provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

# コストアラート用のSNSトピックを作成
resource "aws_sns_topic" "cost_threshold_exceeded" {
  provider = aws.virginia
  name     = "Cost_Threshold_Exceeded_Alarms_Topic"
}
resource "aws_sns_topic_subscription" "email_subscription" {
  provider  = aws.virginia
  topic_arn = aws_sns_topic.cost_threshold_exceeded.arn
  protocol  = "email"
  endpoint  = "tk.attakait@gmail.com"
}

# コストが50USDを超えたらアラートメールで通知
resource "aws_cloudwatch_metric_alarm" "cost_threshold_exceeded" {
  provider            = aws.virginia
  alarm_name          = "cost_threshold_exceeded"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = 21600
  statistic           = "Maximum"
  datapoints_to_alarm = 1
  threshold           = 50
  alarm_description   = "This metric monitors cost threshold exceeded"
  alarm_actions       = [aws_sns_topic.cost_threshold_exceeded.arn]
}
