until /usr/bin/confd -node http://127.0.0.1:2379 -client-cert {{ certs_certfile }} -client-key {{ certs_keyfile }} -onetime -config-file /etc/confd/conf.d/nginx.toml; do
  echo "[nginx] waiting for confd to refresh nginx.conf"
  sleep 5
done
