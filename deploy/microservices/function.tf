resource "yandex_iam_service_account" "func-sa" {
  name = "func-service-account"
}

resource "yandex_function" "posts-microservice" {
  name               = "posts-microservice"
  user_hash          = "v1.0"
  runtime            = "golang119"
  entrypoint         = "post.Posts"
  memory             = "128"
  execution_timeout  = "10"
  tags               = ["v1-0"]
  service_account_id = yandex_iam_service_account.func-sa.id
  content {
    zip_filename = "resources/post.zip"
  }
  environment = {
    POSTGRES_HOST     = var.DB_HOST
    POSTGRES_USER     = "user"
    POSTGRES_PASSWORD = "password123"
    POSTGRES_DB       = "app-db"
    POSTGRES_PORT     = "6432"
  }
  connectivity {
    network_id = var.NETWORK_ID
  }
}

resource "yandex_function" "users-microservice" {
  name               = "users-microservice"
  user_hash          = "v1.0"
  runtime            = "golang119"
  entrypoint         = "user.Users"
  memory             = "128"
  execution_timeout  = "10"
  tags               = ["v1-0"]
  service_account_id = yandex_iam_service_account.func-sa.id
  content {
    zip_filename = "resources/user.zip"
  }
  environment = {
    POSTGRES_HOST     = var.DB_HOST
    POSTGRES_USER     = "user"
    POSTGRES_PASSWORD = "password123"
    POSTGRES_DB       = "app-db"
    POSTGRES_PORT     = "6432"
  }
  connectivity {
    network_id = var.NETWORK_ID
  }
}
