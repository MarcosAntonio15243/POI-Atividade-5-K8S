#!/bin/bash
MIP=$(minikube ip)
declare -A MAP=( [8081]=30001 [8082]=30002 [8083]=30003 )
for P in "${!MAP[@]}"; do
cat <<EOF | sudo tee /etc/systemd/system/fwd-$P.service >/dev/null
[Unit]
Description=Forward $P to minikube ${MAP[$P]}
After=docker.service
[Service]
ExecStart=/usr/bin/socat TCP-LISTEN:$P,fork,reuseaddr TCP:$MIP:${MAP[$P]}
Restart=always
[Install]
WantedBy=multi-user.target
EOF
done
sudo systemctl daemon-reload
for P in "${!MAP[@]}"; do sudo systemctl enable --now fwd-$P; sudo systemctl restart fwd-$P; done
