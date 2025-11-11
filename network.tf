data "vkcs_networking_network" "extnet" {
  name = "ext-net"
}

resource "vkcs_networking_network" "monitoring_network" {
  name = "monitoring-network-PanyutinMA"
}

resource "vkcs_networking_subnet" "monitoring_subnet" {
  name       = "monitoring-subnet-PanyutinMA"
  network_id = vkcs_networking_network.monitoring_network.id
  cidr       = "192.168.100.0/24"
}

resource "vkcs_networking_router" "monitoring_router" {
  name                = "monitoring-router-PanyutinMA"
  external_network_id = data.vkcs_networking_network.extnet.id
}

resource "vkcs_networking_router_interface" "monitoring_interface" {
  router_id = vkcs_networking_router.monitoring_router.id
  subnet_id = vkcs_networking_subnet.monitoring_subnet.id
}
