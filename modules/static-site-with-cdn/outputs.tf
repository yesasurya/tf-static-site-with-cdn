output "LOAD_BALANCER_IP_ADDRESS" {
    value = google_compute_global_forwarding_rule.global-forwarding-rule-for-load-balancer.ip_address
}
