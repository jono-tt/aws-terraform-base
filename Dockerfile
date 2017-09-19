FROM alpine:3.6

ENV TERRAFORM_VERSION 0.10.6

# Download and install Terraform.
RUN mkdir /tmp/terraform \
    && cd /tmp/terraform \
    && apk add --update bash curl ca-certificates openssh-client git unzip \
    && curl -O -sS -L https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && apk del unzip \
    && mv terraform* /usr/local/bin \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/terraform \
    && ln -s /usr/local/bin/terraform /usr/local/bin/t \
    && echo 't plan' > /usr/local/bin/plan \
    && echo 't apply' > /usr/local/bin/apply \
    && chmod +x /usr/local/bin/plan /usr/local/bin/apply \
    && mkdir /terraform-template


WORKDIR /terraform-template

ADD aws-provider.tf aws-remote-state.tf ./
ADD entry-point.sh /entry-point.sh

RUN chmod +x /entry-point.sh \
    && terraform init --backend=false

ENTRYPOINT [ "/entry-point.sh" ]
