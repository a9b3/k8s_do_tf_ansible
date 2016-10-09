variable "do_token" {}
variable "ssh_fingerprint" {}
variable "etcd_count" {}
variable "kube_controller_count" {}
variable "kube-worker_count" {}

provider "digitalocean" {
  token = "${var.do_token}"
}

/*****************************************************************************
 * modules
 ****************************************************************************/

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

module "kube-worker" {
  source = "./modules/kube-worker"

  count = "${var.kube-worker_count}"
  ssh_fingerprint = "${var.ssh_fingerprint}"
}

/*****************************************************************************
 * outputs
 ****************************************************************************/

output "etcd_ips" {
  value = "${module.etcd.public_ips}"
}

output "etcd_ips_private" {
  value = "${module.etcd.private_ips}"
}

output "kube_controller_ips" {
  value = "${module.kube_controller.public_ips}"
}

output "kube_controller_ips_private" {
  value = "${module.kube_controller.private_ips}"
}

output "kube-worker_ips" {
  value = "${module.kube-worker.public_ips}"
}

output "kube-worker_ips_private" {
  value = "${module.kube-worker.private_ips}"
}
