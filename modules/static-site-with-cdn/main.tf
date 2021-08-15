resource "google_storage_bucket" "bucket-static-site" {
    name            = var.SITE_URL
    location        = "ASIA-SOUTHEAST1"
    force_destroy   = true

    website {
        main_page_suffix    = var.MAIN_PAGE
        not_found_page      = var.NOT_FOUND_PAGE
    }
}


resource "google_storage_bucket_iam_binding" "binding" {
  bucket = google_storage_bucket.bucket-static-site.name
  role = "roles/storage.objectViewer"
  members = [
    "allUsers"
  ]
}


resource "google_compute_backend_bucket" "backend-bucket" {
    name          = "backend-bucket-static-site"
    bucket_name   = google_storage_bucket.bucket-static-site.name
    enable_cdn    = true
}


resource "google_compute_url_map" "load-balancer-static-site" {
    name              = "load-balancer-static-site"
    default_service   = google_compute_backend_bucket.backend-bucket.self_link
}


resource "google_compute_target_http_proxy" "http-proxy-for-load-balancer-static-site" {
    count       = var.SSL_ON ? 0 : 1
    name        = "http-proxy-for-load-balancer-static-site"
    url_map     = google_compute_url_map.load-balancer-static-site.id
}


resource "google_compute_managed_ssl_certificate" "ssl-certificate" {
    count       = var.SSL_ON ? 1 : 0
    name        = "ssl-certificate"
    managed {
        domains = [var.SITE_URL]
    }
}


resource "google_compute_target_https_proxy" "https-proxy-for-load-balancer-static-site" {
    count               = var.SSL_ON ? 1 : 0
    name                = "https-proxy-for-load-balancer-static-site"
    url_map             = google_compute_url_map.load-balancer-static-site.id
    ssl_certificates    = [google_compute_managed_ssl_certificate.ssl-certificate[0].id]
}


resource "google_compute_global_forwarding_rule" "global-forwarding-rule-for-load-balancer" {
    name       = "global-forwarding-rule-for-load-balancer"
    target     = var.SSL_ON ? google_compute_target_https_proxy.https-proxy-for-load-balancer-static-site[0].id : google_compute_target_http_proxy.http-proxy-for-load-balancer-static-site[0].id
    port_range = var.SSL_ON ? "443" : "80"
}
