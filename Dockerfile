FROM golang:1.15-buster
ENV CF_CLI_VERSION="7.2.0"
ENV YQ_VERSION="4.9.6"
ENV SPRUCE_VERION="1.25.2"
ENV SWAGGER_VERION="0.13.0"
ENV CF_MGMT_VERSION="v1.0.43"
ENV BOSH_VERSION="6.2.1"
ENV GOVC_VERSION="0.22.1"
ENV BBR_VERSION="1.7.2"
ENV MC_VERSION="RELEASE.2020-04-25T00-43-23Z"
ENV CREDHUB_VERSION "2.8.0"
ENV PACKAGES "awscli unzip curl openssl ca-certificates git jq util-linux gzip bash uuid-runtime coreutils vim tzdata openssh-client gnupg rsync make zip bc"
RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends ${PACKAGES} && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN curl -fL "https://packages.cloudfoundry.org/stable?release=linux64-binary&version=${CF_CLI_VERSION}" | tar -zx -C /usr/local/bin && \
    curl -fL "https://github.com/mikefarah/yq/releases/download/3.2.1/yq_linux_amd64" -o /usr/local/bin/yq3 && \
    curl -fL "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64" -o /usr/local/bin/yq && \
    curl -fL "https://github.com/geofffranks/spruce/releases/download/v${SPRUCE_VERION}/spruce-linux-amd64" -o /usr/local/bin/spruce && \
    curl -fL "https://github.com/go-swagger/go-swagger/releases/download/${SWAGGER_VERION}/swagger_linux_amd64" -o /usr/local/bin/swagger && \
    curl -fL "https://github.com/pivotalservices/cf-mgmt/releases/download/${CF_MGMT_VERSION}/cf-mgmt-linux" -o /usr/local/bin/cf-mgmt && \
    curl -fL "https://github.com/pivotalservices/cf-mgmt/releases/download/${CF_MGMT_VERSION}/cf-mgmt-config-linux" -o /usr/local/bin/cf-mgmt-config && \
    curl -fL "https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-${BOSH_VERSION}-linux-amd64" -o /usr/local/bin/bosh && \
    curl -fL "https://github.com/cloudfoundry-incubator/bosh-backup-and-restore/releases/download/v${BBR_VERSION}/bbr-${BBR_VERSION}-linux-amd64" -o /usr/local/bin/bbr && \
    curl -fL "https://github.com/vmware/govmomi/releases/download/v${GOVC_VERSION}/govc_linux_amd64.gz" | gunzip > /usr/local/bin/govc && \
    curl -fL "https://dl.min.io/client/mc/release/linux-amd64/archive/mc.${MC_VERSION}" > /usr/local/bin/mc && \
    curl -fL "https://github.com/cloudfoundry-incubator/credhub-cli/releases/download/${CREDHUB_VERSION}/credhub-linux-${CREDHUB_VERSION}.tgz" | tar -zx -C /usr/local/bin && \
    chmod +x /usr/local/bin/*
RUN ln /usr/bin/uuidgen /usr/local/bin/uuid && \
    cf install-plugin -r CF-Community -f "blue-green-deploy" && \
    curl -L "https://github.com/contraband/autopilot/releases/download/0.0.8/autopilot-linux" -o /tmp/autopilot-linux && \
    cf install-plugin /tmp/autopilot-linux -f && \
    mkdir -p /root/.ssh && \
    git config --global user.email "git-ssh@example.com" && \
    git config --global user.name "Docker container git-ssh" && \
    go get -v github.com/onsi/ginkgo/ginkgo && \
    go get -v github.com/onsi/gomega/... && \
    go get -v github.com/EngineerBetter/stopover && \
    go get -u -v github.com/FidelityInternational/go-check-certs && \
    rm -rf /tmp/autopilot-linux $GOPATH/src && \
    sed -i 's/^CipherString/#CipherString/g' /etc/ssl/openssl.cnf
