# EC2 Role for Web Tier
resource "aws_iam_role" "web_role" {
  name = "${var.project}-${var.environment}-web-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.project}-${var.environment}-web-role"
    Project     = var.project
    Environment = var.environment
    Tier        = "web"
    ManagedBy   = "terraform"
    Owner       = var.owner
  }
}

# EC2 Role for App Tier
resource "aws_iam_role" "app_role" {
  name = "${var.project}-${var.environment}-app-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.project}-${var.environment}-app-role"
    Project     = var.project
    Environment = var.environment
    Tier        = "app"
    ManagedBy   = "terraform"
    Owner       = var.owner
  }
}

# Instance Profile for Web Tier
resource "aws_iam_instance_profile" "web_profile" {
  name = "${var.project}-${var.environment}-web-profile"
  role = aws_iam_role.web_role.name

  tags = {
    Project     = var.project
    Environment = var.environment
    Tier        = "web"
    ManagedBy   = "terraform"
    Owner       = var.owner
  }
}

# Instance Profile for App Tier
resource "aws_iam_instance_profile" "app_profile" {
  name = "${var.project}-${var.environment}-app-profile"
  role = aws_iam_role.app_role.name

  tags = {
    Project     = var.project
    Environment = var.environment
    Tier        = "app"
    ManagedBy   = "terraform"
    Owner       = var.owner
  }
}

# Attach SSM policy to roles (for session management)
resource "aws_iam_role_policy_attachment" "web_ssm" {
  role       = aws_iam_role.web_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "app_ssm" {
  role       = aws_iam_role.app_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Attach CloudWatch policy to roles (for monitoring)
resource "aws_iam_role_policy_attachment" "web_cloudwatch" {
  role       = aws_iam_role.web_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "app_cloudwatch" {
  role       = aws_iam_role.app_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Custom policy for web tier (minimal permissions)
resource "aws_iam_policy" "web_policy" {
  name        = "${var.project}-${var.environment}-web-policy"
  description = "Policy for web tier instances"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:s3:::${var.project}-${var.environment}-web-assets/*",
          "arn:aws:s3:::${var.project}-${var.environment}-web-assets"
        ]
      }
    ]
  })

  tags = {
    Project     = var.project
    Environment = var.environment
    Tier        = "web"
    ManagedBy   = "terraform"
    Owner       = var.owner
  }
}

# Custom policy for app tier (appropriate permissions)
resource "aws_iam_policy" "app_policy" {
  name        = "${var.project}-${var.environment}-app-policy"
  description = "Policy for app tier instances"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:s3:::${var.project}-${var.environment}-app-data/*",
          "arn:aws:s3:::${var.project}-${var.environment}-app-data"
        ]
      },
      {
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:secretsmanager:*:*:secret:${var.project}/${var.environment}/*"
      }
    ]
  })

  tags = {
    Project     = var.project
    Environment = var.environment
    Tier        = "app"
    ManagedBy   = "terraform"
    Owner       = var.owner
  }
}

# Attach custom policies
resource "aws_iam_role_policy_attachment" "web_custom" {
  role       = aws_iam_role.web_role.name
  policy_arn = aws_iam_policy.web_policy.arn
}

resource "aws_iam_role_policy_attachment" "app_custom" {
  role       = aws_iam_role.app_role.name
  policy_arn = aws_iam_policy.app_policy.arn
}