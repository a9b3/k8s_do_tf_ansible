## Domain Name

For digitalocean. Add digital ocean nameservers to domain name registry.

- ns1.digitalocean.com
- ns2.digitalocean.com
- ns3.digitalocean.com

Then go to digital ocean and add domain name to droplet ip.

Add cname for subdomains. `* <domain name>` in digital ocean

## Debugging Docker Container

Open bash session in container

```sh
docker exec -i -t <image name> /bin/bash
```