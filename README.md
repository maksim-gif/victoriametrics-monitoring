# VictoriaMetrics Monitoring Stack

Развертывание системы мониторинга на базе VictoriaMetrics, Node Exporter и Grafana в VK Cloud.

## Описание проекта

Автоматическое развертывание полнофункциональной системы мониторинга с использованием Terraform.

## Компоненты системы

- **VictoriaMetrics** - база данных временных рядов
- **Node Exporter** - сбор системных метрик
- **Grafana** - визуализация метрик

## Использование

```bash
terraform init
terraform plan -var="vkcs_username=your_email" -var="vkcs_password=your_password" -var="vkcs_project_id=your_project_id" -var="lastname=your_lastname" -var="ssh_public_key=\$(cat ~/.ssh/id_rsa.pub)"
terraform apply
