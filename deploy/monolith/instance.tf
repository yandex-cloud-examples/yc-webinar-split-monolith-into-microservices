locals {
  compose_spec = <<-EOT
  version: '3.7'
  services:
    app:
      container_name: monolith_app
      restart: always
      image: cr.yandex/${var.YC_REGISTRY_ID}/monolith:${var.IMAGE_TAG}
      environment:
        - POSTGRES_HOST=${yandex_mdb_postgresql_cluster.postgresql.host[0].fqdn}
        - POSTGRES_USER=${yandex_mdb_postgresql_user.username.name}
        - POSTGRES_PASSWORD=${yandex_mdb_postgresql_user.username.password}
        - POSTGRES_DB=${yandex_mdb_postgresql_database.db.name}
        - POSTGRES_PORT=6432
        - PORT=8080
      ports:
        - "8080:8080"
  EOT
  user = "user"
  pub_key = "ssh-ed25519 dummy_public_key"
}

resource "yandex_iam_service_account" "vm-sa" {
  name = "vm-service-account"
}

resource "yandex_resourcemanager_folder_iam_member" "puller" {
  folder_id = local.yc_folder
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.vm-sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "compute-editor" {
  folder_id = local.yc_folder
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.vm-sa.id}"
}

data "yandex_compute_image" "coi-image" {
  family    = "container-optimized-image"
  folder_id = "standard-images"
}

resource "yandex_compute_instance_group" "app-ig" {
  name                = "fixed-ig"
  folder_id           = local.yc_folder
  service_account_id  = yandex_iam_service_account.vm-sa.id
  deletion_protection = "false"
  depends_on          = [yandex_resourcemanager_folder_iam_member.compute-editor]
  instance_template {
    platform_id = "standard-v3"
    service_account_id  = yandex_iam_service_account.vm-sa.id
    resources {
      memory = "2"
      cores  = "2"
    }

    boot_disk {
      initialize_params {
        image_id = data.yandex_compute_image.coi-image.id
      }
    }

    network_interface {
      network_id = yandex_vpc_network.app-network.id
      subnet_ids = [
        yandex_vpc_subnet.subnet-a.id,
        yandex_vpc_subnet.subnet-b.id
      ]
    }

    metadata = {
      ssh-keys       = "${local.user}:${local.pub_key}"
      docker-compose = local.compose_spec
    }
  }

  scale_policy {
    fixed_scale {
      size = 2
    }
  }

  allocation_policy {
    zones = [
      "ru-central1-a",
      "ru-central1-b"
    ]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }

  load_balancer {
    target_group_name = "app-tg"
  }
}
