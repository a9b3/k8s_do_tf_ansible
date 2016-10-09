variable "count" {}
variable "ssh_fingerprint" {}

resource "digitalocean_tag" "kube-controller" {
  name = "kube-controller"
}

resource "digitalocean_droplet" "kube-controller" {
  count = "${var.count}"
  image = "ubuntu-16-04-x64"
  name = "kube-controller-${count.index}"
  region = "sfo1"
  size = "512mb"
  private_networking = true
  ssh_keys = [
    "${var.ssh_fingerprint}"
  ]
  tags = ["${digitalocean_tag.kube-controller.name}"]
}

output "public_ips" {
  value = ["${digitalocean_droplet.kube-controller.*.ipv4_address}"]
}

output "private_ips" {
  value = ["${digitalocean_droplet.kube-controller.*.ipv4_address_private}"]
}
