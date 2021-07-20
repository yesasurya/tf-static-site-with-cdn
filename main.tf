provider "google" {
    project = "personal-320108"
    region = "asia-southeast1"
    zone = "asia-southeast1-a"
}

module "static-site-with-cdn" {
    source = "./modules/static-site-with-cdn"

    ## NOTE: You can customize the variables here
    SITE_URL = "yesa-static-site.yesa.id"
    MAIN_PAGE = "index.html"
    NOT_FOUND_PAGE = "404.html"
    SSL_ON = true
}
