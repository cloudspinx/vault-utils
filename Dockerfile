FROM ubuntu:24.04
ARG VAULT_VERSION=1.17.5 # https://github.com/hashicorp/vault/releases
ARG UID=999
ARG GID=999
ARG KUBECTL_VERSION=v1.28.14

RUN groupadd -g "${GID}" vault && mkdir -p /home/vault \
  && usermod -l vault -g "${GID}" -d /home/vault _apt && chown -R vault:vault /home/vault


# Update apt and Install dependencies
RUN apt update && apt install software-properties-common -y \
    && apt update && DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get install -y \
    tzdata \
    curl \
    dnsutils \
    git \
    jq \
    yq \
    zip \
    wget \
    && rm -rf /var/lib/apt/lists/* \
    && wget -O /tmp/vault.zip https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip \
    && unzip /tmp/vault.zip -d /tmp && mv /tmp/vault /usr/local/bin/vault && chmod +x /usr/local/bin/vault \
    && wget https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl
