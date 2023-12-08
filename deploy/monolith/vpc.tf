locals {
  zone_a_v4_cidr_blocks = "10.1.0.0/16"
  zone_b_v4_cidr_blocks = "10.2.0.0/16"
  zone_c_v4_cidr_blocks = "10.3.0.0/16"
}

resource "yandex_vpc_network" "app-network" {
  name        = "app-network"
  folder_id   = var.YC_FOLDER
}

resource "yandex_vpc_subnet" "subnet-a" {
  description    = "Subnet in the ru-central1-a availability zone"
  name           = "app-subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.app-network.id
  v4_cidr_blocks = [local.zone_a_v4_cidr_blocks]
  folder_id      = local.yc_folder
}

resource "yandex_vpc_subnet" "subnet-b" {
  description    = "Subnet in the ru-central1-b availability zone"
  name           = "app-subnet-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.app-network.id
  v4_cidr_blocks = [local.zone_b_v4_cidr_blocks]
  folder_id      = local.yc_folder
}
