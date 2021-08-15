# debian_component_based image includes additional gcloud components
FROM gcr.io/google.com/cloudsdktool/cloud-sdk:debian_component_based

ARG TERRAFORM_VERSION=1.0.4
ARG TERRAFORM_DOCS_VERSION=0.10.1

RUN set -xe && \
    # install packages
    apt-get install -y \
    unzip \
    jq \
    sudo \
    dnsutils \
    dos2unix \
    nano && \ 
    # install terraform
    curl -k -O https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && mv terraform /usr/local/bin/ && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    # install terraform-docs
    curl -k -LO https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64 && \
    mv terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64 terraform-docs && \
    chmod +x terraform-docs && \
    mv terraform-docs /usr/local/bin && \
    # update ca-certificates
    openssl s_client -showcerts -servername github.com -connect github.com:443 </dev/null 2>/dev/null | sed -n -e '/BEGIN\ CERTIFICATE/,/END\ CERTIFICATE/ p'  > github-com.pem && \
    cat github-com.pem | tee -a /etc/ssl/certs/ca-certificates.crt && \
    rm github-com.pem

RUN useradd -ms /bin/bash rajesh && echo "rajesh:rajesh" | chpasswd && adduser rajesh sudo && \
    sed -i "s/^#*\s*force_color_prompt=yes/force_color_prompt=yes/g" /home/rajesh/.bashrc

USER rajesh
WORKDIR /home/rajesh

# COPY entrypoint.sh ./entrypoint.sh
# RUN chmod +x ./entrypoint.sh
# ENTRYPOINT ["./entrypoint.sh"]
