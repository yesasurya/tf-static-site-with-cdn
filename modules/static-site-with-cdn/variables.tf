variable "SITE_URL" {
  type = string
  description = "The URL of the static site"
}

variable "MAIN_PAGE" {
  type = string
  description = "A file that will be the main page (usually index.html)"
}

variable "NOT_FOUND_PAGE" {
  type = string
  description = "A file that will be returned when user get error 404 Not Found"
}

variable "PATH_TO_STATIC_SITE" {
  type = string
  description = "The path to the static site"
}

variable "SSL_ON" {
  type = bool
  description = "Should SSL be enabled?"
}
