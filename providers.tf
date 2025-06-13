terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.124"
    }
  }
  required_version = ">=1.9"

  backend "s3" {
    endpoint   = "https://storage.yandexcloud.net"
    bucket     = var.s3_bucket_name
    region     = "ru-central1"
    key        = "terraform.tfstate"
    access_key = var.s3_access_key
    secret_key = var.s3_secret_key

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}

provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
}