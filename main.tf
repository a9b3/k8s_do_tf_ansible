variable "do_token" {}
variable "ssh_fingerprint" {}
variable "etcd_count" {}
variable "kube-controller_count" {}
variable "kube-worker_count" {}
variable "loadbalancer_count" {}

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

module "kube-controller" {
  source = "./modules/kube-controller"

  count = "${var.kube-controller_count}"
  ssh_fingerprint = "${var.ssh_fingerprint}"
}

module "kube-worker" {
  source = "./modules/kube-worker"

  count = "${var.kube-worker_count}"
  ssh_fingerprint = "${var.ssh_fingerprint}"
}

module "loadbalancer" {
  source = "./modules/loadbalancer"

  count = "${var.loadbalancer_count}"
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

output "kube-controller_ips" {
  value = "${module.kube-controller.public_ips}"
}

output "kube-controller_ips_private" {
  value = "${module.kube-controller.private_ips}"
}

output "kube-worker_ips" {
  value = "${module.kube-worker.public_ips}"
}

output "kube-worker_ips_private" {
  value = "${module.kube-worker.private_ips}"
}

output "loadbalancer_ips" {
  value = "${module.loadbalancer.public_ips}"
}

output "loadbalancer_ips_private" {
  value = "${module.loadbalancer.private_ips}"
}
