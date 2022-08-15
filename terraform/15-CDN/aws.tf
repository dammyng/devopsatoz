provider "aws" {
  region = "us-east-1"
}

resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = "example.com.s3.amazonaws.com"
    origin_id   = "S3-example.com"
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-example.com"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl           = 3600
    max_ttl               = 86400
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
