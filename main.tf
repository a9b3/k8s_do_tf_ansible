variable "do_token" {}
variable "ssh_fingerprint" {}
variable "etcd_count" {}

provider "digitalocean" {
  token = "${var.do_token}"
}

module "etcd" {
  source = "./modules/etcd"

  count = "${var.etcd_count}"
  ssh_fingerprint = "${var.ssh_fingerprint}"
}

output "etcd_ips" {
  value = "${module.etcd.public_ips}"
}
