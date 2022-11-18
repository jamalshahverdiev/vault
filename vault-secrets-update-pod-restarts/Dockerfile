FROM vault:latest
RUN wget https://storage.googleapis.com/kubernetes-release/release/v1.23.3/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl
ADD restart_deployment.sh /opt/restart_deployment.sh
