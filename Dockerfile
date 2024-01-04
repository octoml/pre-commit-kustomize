FROM alpine:latest

ARG version=v5.3.0
ARG checksum=3ab32f92360d752a2a53e56be073b649abc1e7351b912c0fb32b960d1def854c

RUN adduser kustomize -D \
  && apk add curl git openssh \
  && git config --global url.ssh://git@github.com/.insteadOf https://github.com/

RUN curl -L --output /tmp/kustomize_${version}_linux_amd64.tar.gz https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${version}/kustomize_${version}_linux_amd64.tar.gz \
  && echo "${checksum} /tmp/kustomize_${version}_linux_amd64.tar.gz" | sha256sum -c \
  && tar -xvzf /tmp/kustomize_${version}_linux_amd64.tar.gz -C /usr/local/bin \
  && chmod +x /usr/local/bin/kustomize \
  && mkdir ~/.ssh \
  && ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
USER kustomize
WORKDIR /src
