variable "do_token" {}
variable "ssh_fingerprint" {}
variable "etcd_count" {}
variable "kube_controller_count" {}

provider "digitalocean" {
  token = "${var.do_token}"
}

module "etcd" {
  source = "./modules/etcd"

  count = "${var.etcd_count}"
  ssh_fingerprint = "${var.ssh_fingerprint}"
}

module "kube_controller" {
  source = "./modules/kube_controller"

  count = "${var.kube_controller_count}"
  ssh_fingerprint = "${var.ssh_fingerprint}"
}

output "etcd_ips" {
  value = "${module.etcd.public_ips}"
}

output "etcd_ips_private" {
  value = "${module.etcd.private_ips}"
}

output "kube_controller_ips" {
  value = "${module.kube_controller.public_ips}"
}
