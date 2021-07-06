FROM amazon/aws-cli:2.0.34

#basic tools
RUN yum install -y curl jq python3 git gnupg unzip tar wget vim
ARG KUBECTL_VERSION=v1.13.2

#kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
  && chmod +x ./kubectl \
  && mv ./kubectl /usr/local/bin/kubectl

#terraform
#ARG TERRAFORM_VERSION=0.11.14
ARG TERRAFORM_VERSION=0.12.31
RUN curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && unzip terraform* \
  && mv terraform /usr/local/bin/ \
  && rm terraform*.zip
  
#kubectx
RUN curl -LO https://github.com/ahmetb/kubectx/releases/download/v0.9.1/kubectx_v0.9.1_linux_x86_64.tar.gz \
  && tar -zxf kubectx_v0.9.1_linux_x86_64.tar.gz \
  && mv ./kubectx /usr/local/bin \
  && rm kubectx_v0.9.1_linux_x86_64.tar.gz

CMD ["/bin/bash"]
