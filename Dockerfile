FROM golang:1.18-bullseye
ENV CF_CLI_7_VERSION="7.5.0"
ENV CF_CLI_8_VERSION="8.5.0"
ENV YQ3_VERSION="3.2.1"
ENV YQ_VERSION="4.26.1"
ENV SPRUCE_VERION="1.25.2"
ENV SWAGGER_VERION="0.13.0"
ENV CF_MGMT_VERSION="1.0.43"
ENV BOSH_VERSION="7.0.1"
ENV GOVC_VERSION="0.26.0"
ENV BBR_VERSION="1.9.33"
ENV MC_VERSION="RELEASE.2020-04-25T00-43-23Z"
ENV CREDHUB_VERSION "2.9.3"
ENV TERRAFORM_VERSION "1.1.6"
ENV BLUE_GREEN_VERSION "1.4.0"
ENV AUTOPILOT_VERSION "0.0.8"
ENV PACKAGES "awscli unzip curl openssl ca-certificates git jq util-linux gzip bash uuid-runtime coreutils vim tzdata openssh-client gnupg rsync make zip bc dnsutils"
RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends ${PACKAGES} && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN curl -fL "https://s3-us-west-1.amazonaws.com/v7-cf-cli-releases/releases/v${CF_CLI_7_VERSION}/cf7-cli_${CF_CLI_7_VERSION}_linux_x86-64.tgz" | tar -zx -C /usr/local/bin cf7 && \
    curl -fL "https://s3-us-west-1.amazonaws.com/v8-cf-cli-releases/releases/v${CF_CLI_8_VERSION}/cf8-cli_${CF_CLI_8_VERSION}_linux_x86-64.tgz" | tar -zx -C /usr/local/bin && \
    curl -fL "https://github.com/mikefarah/yq/releases/download/${YQ3_VERSION}/yq_linux_amd64" -o /usr/local/bin/yq3 && \
    curl -fL "https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64" -o /usr/local/bin/yq && \
    curl -fL "https://github.com/geofffranks/spruce/releases/download/v${SPRUCE_VERION}/spruce-linux-amd64" -o /usr/local/bin/spruce && \
    curl -fL "https://github.com/go-swagger/go-swagger/releases/download/${SWAGGER_VERION}/swagger_linux_amd64" -o /usr/local/bin/swagger && \
    curl -fL "https://github.com/pivotalservices/cf-mgmt/releases/download/v${CF_MGMT_VERSION}/cf-mgmt-linux" -o /usr/local/bin/cf-mgmt && \
    curl -fL "https://github.com/pivotalservices/cf-mgmt/releases/download/v${CF_MGMT_VERSION}/cf-mgmt-config-linux" -o /usr/local/bin/cf-mgmt-config && \
    curl -fL "https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-${BOSH_VERSION}-linux-amd64" -o /usr/local/bin/bosh && \
    curl -fL "https://github.com/cloudfoundry-incubator/bosh-backup-and-restore/releases/download/v${BBR_VERSION}/bbr-${BBR_VERSION}-linux-amd64" -o /usr/local/bin/bbr && \
    curl -fL "https://github.com/vmware/govmomi/releases/download/v${GOVC_VERSION}/govc_Linux_x86_64.tar.gz" | tar -zx -C /usr/local/bin && \
    curl -fL "https://dl.min.io/client/mc/release/linux-amd64/archive/mc.${MC_VERSION}" > /usr/local/bin/mc && \
    curl -fL "https://github.com/cloudfoundry-incubator/credhub-cli/releases/download/${CREDHUB_VERSION}/credhub-linux-${CREDHUB_VERSION}.tgz" | tar -zx -C /usr/local/bin && \
    curl -fL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" | zcat > /usr/local/bin/terraform && \
    chmod +x /usr/local/bin/*
RUN ln /usr/bin/uuidgen /usr/local/bin/uuid && \
    curl -fL "https://github.com/bluemixgaragelondon/cf-blue-green-deploy/releases/download/v${BLUE_GREEN_VERSION}/blue-green-deploy.linux64" -o /tmp/blue-green-deploy && \
    cf install-plugin -f "/tmp/blue-green-deploy" && \
    curl -L "https://github.com/contraband/autopilot/releases/download/${AUTOPILOT_VERSION}/autopilot-linux" -o /tmp/autopilot-linux && \
    cf install-plugin /tmp/autopilot-linux -f && \
    rm -rf /tmp/autopilot-linux /tmp/blue-green-deploy
RUN mkdir -p /root/.ssh && \
    git config --global user.email "git-ssh@example.com" && \
    git config --global user.name "Docker container git-ssh" && \
    go install github.com/onsi/ginkgo/ginkgo@latest && \
    go install -mod=mod github.com/onsi/gomega && \
    go install github.com/FidelityInternational/stopover@v1.0.1 && \
    go install github.com/FidelityInternational/go-check-certs@latest && \
    rm -rf $GOPATH/src && \
    sed -i 's/^CipherString/#CipherString/g' /etc/ssl/openssl.cnf
