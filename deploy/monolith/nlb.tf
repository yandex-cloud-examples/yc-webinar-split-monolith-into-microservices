resource "yandex_lb_network_load_balancer" "app-nlb" {
  name                = "app-nlb"
  deletion_protection = "false"
  listener {
    name = "app-balancer"
    port = 80
    target_port = 8080
  }
  attached_target_group {
    target_group_id = yandex_compute_instance_group.app-ig.load_balancer[0].target_group_id
    healthcheck {
      name = "http"
      http_options {
        port = 8080
        path = "/api/healthcheck"
      }
    }
  }
}
