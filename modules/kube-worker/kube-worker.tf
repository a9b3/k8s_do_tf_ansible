variable "count" {}
variable "ssh_fingerprint" {}
variable "etcd_ips" {}

resource "template_file" "kube-worker" {
  template = "${file("${path.module}/user-data")}"

  vars {
    etcd_ips = "${join(",", formatlist("http://%s:2379", var.etcd_ips))}"
  }
}

resource "digitalocean_tag" "kube-worker" {
  name = "kube-worker"
}

resource "digitalocean_droplet" "kube-worker" {
  count = "${var.count}"
  image = "coreos-stable"
  name = "kube-worker-${count.index}"
  region = "sfo1"
  size = "512mb"
  private_networking = true
  ssh_keys = [
    "${var.ssh_fingerprint}"
  ]
  tags = ["${digitalocean_tag.kube-worker.name}"]
  user_data = "${template_file.kube-worker.rendered}"
}

output "public_ips" {
  value = ["${digitalocean_droplet.kube-worker.*.ipv4_address}"]
}

output "private_ips" {
  value = ["${digitalocean_droplet.kube-worker.*.ipv4_address_private}"]
}
