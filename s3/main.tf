resource "aws_s3_bucket" "s3" {
  bucket        = "hybrid-network-1014041"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "name" {
  bucket = aws_s3_bucket.s3.id
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Principal : {
          AWS : "arn:aws:iam::127311923021:root"
        },
        Action: "s3:PutObject",
        Resource : [
          "${aws_s3_bucket.s3.arn}/alb/AWSLogs/${var.acc_id}/*"
        ],
      }
    ]
  })
  depends_on = [aws_s3_bucket.s3]
}
