FROM alpine:3.7

ENV TERRAFORM_SHA256SUM=84ccfb8e13b5fce63051294f787885b76a1fedef6bdbecf51c5e586c9e20c9b7
ENV TERRAFORM_VERSION=0.11.8

ENV PACKER_SHA256SUM=258d1baa23498932baede9b40f2eca4ac363b86b32487b36f48f5102630e9fbb
ENV PACKER_VERSION=1.2.4


# Common dependencies
RUN apk add --no-cache \
    curl \
    python2 \
    py2-pip \
    jq \
    bash \
    make \
    openssh


# Install terraform
RUN curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip > terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && echo "${TERRAFORM_SHA256SUM}  terraform_${TERRAFORM_VERSION}_linux_amd64.zip" > terraform_${TERRAFORM_VERSION}_SHA256SUMS && sha256sum -cs terraform_${TERRAFORM_VERSION}_SHA256SUMS \
    && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin \
    && rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && rm -f terraform_${TERRAFORM_VERSION}_SHA256SUMS

# Install packer
RUN curl https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip > packer_${PACKER_VERSION}_linux_amd64.zip \
    && echo "${PACKER_SHA256SUM}  packer_${PACKER_VERSION}_linux_amd64.zip" > packer_${PACKER_VERSION}_SHA256SUMS && sha256sum -cs packer_${PACKER_VERSION}_SHA256SUMS \
    && unzip packer_${PACKER_VERSION}_linux_amd64.zip -d /usr/bin \
    && rm -f packer_${PACKER_VERSION}_linux_amd64.zipj \
    && rm -f terraform_${PACKER_VERSION}_SHA256SUMS

# Install AWS and Okta tooling
RUN pip install virtualenv
RUN virtualenv /okta_venv \
        && source /okta_venv/bin/activate \
        && pip install \
            "aws_role_credentials>=0.6.3" \
            "oktaauth>=0.2" \
            "awscli>=1.15"

#Install aws-iam-authenticator
RUN curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/linux/amd64/aws-iam-authenticator \
	&& chmod +x ./aws-iam-authenticator \
	&& cp ./aws-iam-authenticator /usr/local/bin/aws-iam-authenticator

#Install kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
	&& chmod +x ./kubectl \
	&& mv ./kubectl /usr/local/bin/kubectl


RUN mkdir /project
WORKDIR /project

ENTRYPOINT ["/bin/bash"]
