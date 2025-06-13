# Единая целевая группа для всех нод кластера
resource "yandex_lb_target_group" "k8s-nodes-group" {
  name = "k8s-nodes-group"

  dynamic "target" {
    for_each = yandex_compute_instance.cluster-k8s
    
    content {
      subnet_id = target.value.network_interface.0.subnet_id
      address   = target.value.network_interface.0.ip_address
    }
  }
}

# Сетевой балансировщик нагрузки для Grafana
resource "yandex_lb_network_load_balancer" "nlb-graf" {
  name = "nlb-grafana"

  listener {
    name        = "grafana-listener"
    port        = 80
    target_port = 30902
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.k8s-nodes-group.id

    healthcheck {
      name = "healthcheck-grafana"
      tcp_options {
        port = 30902
      }
    }
  }
  depends_on = [
    yandex_lb_target_group.k8s-nodes-group,
    yandex_lb_network_load_balancer.nlb-app
  ]
}

# Сетевой балансировщик нагрузки для приложения
resource "yandex_lb_network_load_balancer" "nlb-app" {
  name = "nlb-my-k8s-app"

  listener {
    name        = "app-listener"
    port        = 80
    target_port = 30903
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.k8s-nodes-group.id

    healthcheck {
      name = "healthcheck-app"
      tcp_options {
        port = 30903
      }
    }
  }

  depends_on = [yandex_lb_target_group.k8s-nodes-group]
}