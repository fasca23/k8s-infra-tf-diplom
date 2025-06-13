### Переменные для подключения к облаку

variable "token" {
  type        = string
  sensitive   = true
  description = "Yandex Cloud OAuth token"
}

variable "folder_id" {
  type        = string
  sensitive   = true
  description = "Yandex Cloud OAuth token"
}

variable "cloud_id" {
  type        = string
  sensitive   = true
  description = "Yandex Cloud OAuth token"
}

### Переменные для сети

variable "default_zone" {
  description = "Зона по умолчанию в Yandex Cloud для предоставленных ресурсов"
  default     = "ru-central1-a"
}

variable "subnet-zones" {
  description = "Зоны в Yandex Cloud для предоставленных ресурсов"
  default     = ["ru-central1-a", "ru-central1-b", "ru-central1-d"]
}

variable "cidr" {
  type = map(list(string))
  default = {
    stage = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  }
}

### Переменные виртуалок

variable "yc_image_family" {
  description = "Название базового образа"
  default     = "ubuntu-2004-lts"
}

variable "image_id" {
  default = "fd8mk346omlpmp2rvng7"
}

variable "instance_cores" {
  description = "Количество ядер инстансов"
  default     = "2"
}

variable "instance_memory" {
  description = "Оперативка инстансов"
  default     = "2"
}

# Переменные кластера

variable "cluster_size" {
  description = "Количество нод кластера"
  default     = 3
}

#  Для работы CI/CD Terraform через GitHub Actions Workflow

variable "s3_access_key" {
  type        = string
  sensitive   = true
  description = "Yandex S3 секретный ключ"
}

variable "s3_secret_key" {
  type        = string
  sensitive   = true
  description = "Yandex S3 секретный ключ"
}

variable "s3_bucket_name" {
  type        = string
  description = "Имя S3 бакета для Terraform"
  sensitive   = true
}

variable "ssh_public_key" {
  description = "Публичный SSH-ключ для подключения к ВМ"
  type        = string
  sensitive   = true
}