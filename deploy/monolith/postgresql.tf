locals {
  cluster_name          = "postgres-cluster"
  pg_version            = "16"
  db_name               = "app-db"
  username              = "user"
  password              = "password123"
}

resource "yandex_mdb_postgresql_cluster" "postgresql" {
  name               = local.cluster_name
  environment        = "PRODUCTION"
  network_id         = yandex_vpc_network.app-network.id
  folder_id   = var.YC_FOLDER

  config {
    version = local.pg_version
    resources {
      resource_preset_id = "s2.micro"
      disk_type_id       = "network-ssd"
      disk_size          = "10"
    }
    access {
      serverless = true
    }
  }
  host {
    zone             = "ru-central1-a"
    subnet_id        = yandex_vpc_subnet.subnet-a.id
  }
}

resource "yandex_mdb_postgresql_database" "db" {
  cluster_id = yandex_mdb_postgresql_cluster.postgresql.id
  name       = local.db_name
  owner      = yandex_mdb_postgresql_user.username.name

  extension {
    name    = "uuid-ossp"
  }
}

resource "yandex_mdb_postgresql_user" "username" {
  cluster_id = yandex_mdb_postgresql_cluster.postgresql.id
  name       = local.username
  password   = local.password
}