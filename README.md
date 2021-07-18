# tf-static-site-with-cdn

### What is this?
This is a Terraform files which will provision followings:
1. GCS bucket for hosting static website
2. CDN for that GCS bucket
3. A Load Balancer which will route the request to the GCS bucket

After provisioning the GCS bucket, this Terraform configuration will upload the static website contents using `local-exec` provisioner.

### How to run this?
Before applying this Terraform files, please make sure you already have `gcloud` CLI installed.
```
terraform apply
```
