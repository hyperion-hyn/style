FROM node:10 as builder

EXPOSE 8888

ENV HOME /maputnik
RUN mkdir ${HOME}

COPY . ${HOME}/

WORKDIR ${HOME}

RUN npm install -d --dev
RUN npm run build

WORKDIR ${HOME}/build/build


FROM nginx:stable-alpine
LABEL maintainer="zouguangxian <zouguangxian@hyn.space>"
ARG S6_OVERLAY_VERSION=v1.21.4.0

RUN set -eux; \
    wget -O /tmp/s6-overlay-amd64.tar.gz https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz \
    && tar xzf /tmp/s6-overlay-amd64.tar.gz -C / \
    && rm /tmp/*

COPY --from=builder /maputnik/build/build /usr/share/nginx/html

COPY docker/rootfs /

ENTRYPOINT ["/init"]


