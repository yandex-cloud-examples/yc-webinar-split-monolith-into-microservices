terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider yandex {
  endpoint         = local.yc_endpoint
  folder_id        = local.yc_folder
  zone             = local.yc_zone
}

locals {
  yc_folder        = var.YC_FOLDER
  yc_zone          = "ru-central1-a"
  yc_endpoint      = "api.cloud.yandex.net:443"
}