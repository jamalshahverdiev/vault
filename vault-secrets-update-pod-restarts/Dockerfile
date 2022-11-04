FROM vault:latest
RUN wget https://storage.googleapis.com/kubernetes-release/release/v1.23.3/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin
ADD restart_deployment.sh /opt/restart_deployment.sh
