FROM debian:bookworm-slim

RUN  apt-get update \
  && apt-get install --no-install-recommends --no-install-suggests -y \
       ca-certificates \
       curl \
       git \
       jq \
       libicu-dev \
       libxml2-dev \
       sudo \
  && apt-get remove --purge --auto-remove -y \
  && rm -rf /var/lib/apt/lists/* \
  && useradd --system -s /bin/bash actions-runner \
  && usermod -aG sudo actions-runner \
  && echo 'actions-runner ALL=(ALL:ALL) NOPASSWD:ALL' \
       | EDITOR='tee -a' visudo -f /etc/sudoers.d/actions-runner
USER actions-runner
WORKDIR /home/actions-runner

RUN  curl --proto "=https" --tlsv1.2 -sSf -Lo actions-runner-linux-x64-latest.tar.gz \
       $(curl --proto "=https" --tlsv1.2 -sSf -L https://api.github.com/repos/actions/runner/releases/latest \
         | jq '.assets[] | select(.name | contains("actions-runner-linux-x64-")).browser_download_url' -r) \
  && tar vxzf ./actions-runner-linux-x64-latest.tar.gz \
  && rm -f ./actions-runner-linux-x64-latest.tar.gz
