resource "aws_lb" "load_balancer" {
  name               = var.load_balancer_name
  internal           = var.load_balancer_internal
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_internet.id]
  subnets            = var.subnet_ids

  #   access_logs {
  #     bucket  = aws_s3_bucket.lb_logs.id
  #     prefix  = "test-lb"
  #     enabled = true
  #   }
  #   connection {
  #     host = ""
  #   }
  #   drop_invalid_header_fields = true/false
  #   enable_deletion_protection = true
  #   enable_http2 = true
  #   enable_tls_version_and_cipher_suite_headers = false (default), true
  #   enable_xff_client_port = false (default), true
  #   enable_waf_fail_open = false (default), true
  #   idle_timeout = 60
  #   ip_address_type = "dualstack"/"ipv4"
  #   preserve_host_header = true
  # xff_header_processing_mode = append, preserve, and remove

  #   customer_owned_ipv4_pool = ""
  #   desync_mitigation_mode = "monitor, defensive (default), strictest"
  tags = {
    Environment = "production"
  }
}

