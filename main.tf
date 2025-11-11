data "vkcs_compute_flavor" "compute" {
  name = var.compute_flavor
}

data "vkcs_images_image" "ubuntu" {
  visibility = "public"
  properties = {
    mcs_os_distro  = "ubuntu"
    mcs_os_version = "22.04"
  }
  most_recent = true
}

# Создание ключевой пары из переданного публичного ключа
resource "vkcs_compute_keypair" "ssh_key" {
  name       = "keypair-${var.lastname}"
  public_key = var.ssh_public_key
}

resource "vkcs_compute_instance" "monitoring_vm" {
  name              = "Ubuntu-${var.lastname}"
  flavor_id         = data.vkcs_compute_flavor.compute.id
  key_pair          = vkcs_compute_keypair.ssh_key.name
  security_groups   = ["default", vkcs_networking_secgroup.monitoring_sg.name]
  availability_zone = var.availability_zone_name

  block_device {
    uuid                  = data.vkcs_images_image.ubuntu.id
    source_type           = "image"
    destination_type      = "volume"
    volume_type           = "ceph-ssd"
    volume_size           = var.disk_size
    boot_index            = 0
    delete_on_termination = true
  }

  network {
    uuid = vkcs_networking_network.monitoring_network.id
  }

  user_data = file("${path.module}/cloud-init.yaml")

  depends_on = [
    vkcs_networking_network.monitoring_network,
    vkcs_networking_subnet.monitoring_subnet,
    vkcs_networking_router_interface.monitoring_interface
  ]
}

resource "vkcs_networking_floatingip" "fip" {
  pool = data.vkcs_networking_network.extnet.name
}

resource "vkcs_compute_floatingip_associate" "fip" {
  floating_ip = vkcs_networking_floatingip.fip.address
  instance_id = vkcs_compute_instance.monitoring_vm.id
}

output "instance_fip" {
  value = vkcs_networking_floatingip.fip.address
}

output "vm_name" {
  value = vkcs_compute_instance.monitoring_vm.name
}

output "grafana_url" {
  value = "http://${vkcs_networking_floatingip.fip.address}:3000"
}

output "victoriametrics_url" {
  value = "http://${vkcs_networking_floatingip.fip.address}:8428"
}

output "node_exporter_url" {
  value = "http://${vkcs_networking_floatingip.fip.address}:9100"
}

output "ssh_connection" {
  value = "ssh ubuntu@${vkcs_networking_floatingip.fip.address}"
}
