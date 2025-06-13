output "external_ip_addresses" {
  value = local.external_ips
}

output "internal_ip_addresses" {
  value = [yandex_compute_instance.cluster-k8s.*.network_interface.0.ip_address]
}

output "hostnames" {
  value = local.hostnames
}

# Основные IP-адреса балансировщиков
output "load_balancer_ips" {
  description = "Внешние IP-адреса всех балансировщиков"
  value = {
    grafana = [
      for listener in yandex_lb_network_load_balancer.nlb-graf.listener :
      one([for spec in listener.external_address_spec : spec.address])
    ],
    application = [
      for listener in yandex_lb_network_load_balancer.nlb-app.listener :
      one([for spec in listener.external_address_spec : spec.address])
    ]
  }
}