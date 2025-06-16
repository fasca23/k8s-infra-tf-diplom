
# Создаем локальный файл hosts.cfg для Ansible в директории по шаблону

resource "local_file" "kubespray_inventory" {
  content = templatefile("./template/hosts.tftpl", {
    master_nodes = [yandex_compute_instance.cluster-k8s[0]]                                                   # Первый инстанс — мастер
    worker_nodes = slice(yandex_compute_instance.cluster-k8s, 1, length(yandex_compute_instance.cluster-k8s)) # Остальные — воркеры
  })

  # filename = "../k8s-spray/kubespray/inventory/hosts.yaml"
    filename = "${path.module}/kubespray/inventory/hosts.yaml"
  depends_on = [yandex_compute_instance.cluster-k8s]
}