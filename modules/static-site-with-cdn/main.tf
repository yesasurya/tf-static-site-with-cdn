resource "google_storage_bucket" "bucket-static-site" {
    name            = var.SITE_URL
    location        = "ASIA-SOUTHEAST1"
    force_destroy   = true

    website {
        main_page_suffix    = var.MAIN_PAGE
        not_found_page      = var.NOT_FOUND_PAGE
    }

    provisioner "local-exec" {
        environment = {
            PATH_TO_STATIC_SITE = var.PATH_TO_STATIC_SITE
            BUCKET_NAME         = self.name             
        }

        command = "gsutil cp -r $PATH_TO_STATIC_SITE/* gs://$BUCKET_NAME && gsutil iam ch allUsers:objectViewer gs://$BUCKET_NAME"
    }
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


resource "google_compute_target_http_proxy" "proxy-for-load-balancer-static-site" {
    name        = "proxy-for-load-balancer-static-site"
    url_map     = google_compute_url_map.load-balancer-static-site.id
}


resource "google_compute_global_forwarding_rule" "global-forwarding-rule-for-load-balancer" {
    name       = "global-forwarding-rule-for-load-balancer"
    target     = google_compute_target_http_proxy.proxy-for-load-balancer-static-site.id
    port_range = "80"
}
