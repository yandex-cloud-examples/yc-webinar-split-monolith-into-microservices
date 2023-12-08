resource "yandex_iam_service_account" "gw-sa" {
  name = "gw-service-account"
}

resource "yandex_resourcemanager_folder_iam_member" "invoker" {
  folder_id = local.yc_folder
  role      = "functions.functionInvoker"
  member    = "serviceAccount:${yandex_iam_service_account.gw-sa.id}"
}

resource "yandex_api_gateway" "app-gw" {
  name = "app-gw"
  spec = templatefile("resources/gateway_spec_v1.yml", {
    FUNCTION_ID : yandex_function.posts-microservice.id,
    FUNCTION_TAG : "v1-0",
    GW_SA_ID : yandex_iam_service_account.gw-sa.id,
    APP_IP : var.NLB_IP
  })
  canary {
    weight    = 50
    variables = {
      "microservices.posts" = "#/components/x-yc-apigateway-integrations/PostsMicroservice"
    }
  }
  connectivity {
    network_id = var.NETWORK_ID
  }
}

## Uncomment for spec v2
#resource "yandex_api_gateway" "app-gw" {
#  name = "app-gw"
#  spec = templatefile("resources/gateway_spec_v2.yml", {
#    FUNCTION_ID_POSTS : yandex_function.posts-microservice.id,
#    FUNCTION_ID_USERS : yandex_function.users-microservice.id,
#    FUNCTION_TAG_POSTS : "v1-0",
#    FUNCTION_TAG_USERS : "v1-0",
#    GW_SA_ID : yandex_iam_service_account.gw-sa.id,
#    NLB_IP : var.NLB_IP
#  })
#  canary {
#    weight    = 50
#    variables = {
#      "microservices.users" = "#/components/x-yc-apigateway-integrations/UsersMicroservice"
#    }
#  }
#  connectivity {
#    network_id = var.NETWORK_ID
#  }
#}