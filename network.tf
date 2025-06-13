# Получение дефолтной сети
data "yandex_vpc_network" "default_network" {
  name = "default"
}

# Создание подсетей в разных зонах
resource "yandex_vpc_subnet" "example_subnet_different_zones" {
  count          = 3
  name           = "subnet-kuber-${var.subnet-zones[count.index]}"
  zone           = var.subnet-zones[count.index]
  network_id     = data.yandex_vpc_network.default_network.id
  v4_cidr_blocks = ["${var.cidr.stage[count.index]}"]
}

# Собираем ID созданных подсетей
locals {
  subnet_ids = yandex_vpc_subnet.example_subnet_different_zones.*.id
}