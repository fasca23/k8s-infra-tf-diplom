# Получаем ID базового образа для ВМ
data "yandex_compute_image" "base_image" {
  family = var.yc_image_family
}

# Создаем виртуальные машины для кластера
resource "yandex_compute_instance" "cluster-k8s" {
  count                     = var.cluster_size
  name                      = "node-kuber-${count.index}"
  hostname                  = "node-kuber-${count.index}"
  zone                      = element(var.subnet-zones, count.index)
  platform_id               = "standard-v3"
  allow_stopping_for_update = true

  # Используем прерываемые инстансы для экономии
  scheduling_policy {
    # preemptible = true
    preemptible = count.index <= 2 ? false : true
  }

  # Ресурсы ВМ (Ядра и память)
  resources {
    cores  = var.instance_cores
    memory = var.instance_memory
  }

  # Настройка загрузочного диска
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.base_image.id
      type     = "network-hdd"
      size     = "20"
    }
  }


  # Подключаем ВМ к созданным подсетям (берем сеть из списка по индексу)
  network_interface {
    subnet_id = element(local.subnet_ids, count.index)
    # Включаем NAT для доступа в интернет
    nat = true
    # security_group_ids = [yandex_vpc_security_group.k8s-nodes-sg.id]
  }

  # Настройка доступа по SSH
  metadata = {
    # ssh-keys  = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
    ssh-keys = "ubuntu:${var.ssh_public_key}"
  }

  # Добавляем информативные метки для удобства управления
  labels = {
    node_id   = count.index
    node_type = count.index == 0 ? "master" : "worker"
  }
}

# Собираем информацию о созданных ресурсах
locals {
  external_ips = [yandex_compute_instance.cluster-k8s.*.network_interface.0.nat_ip_address]
  hostnames    = [yandex_compute_instance.cluster-k8s.*.hostname]
}