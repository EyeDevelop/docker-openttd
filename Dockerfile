FROM alpine

RUN apk add -U unzip bash curl shadow su-exec build-base xz-dev zlib-dev lzo-dev

ENV PUID 1000
ENV PGID 1000
ENV OPENTTD_VERSION 1.10.3
ENV OPENGFX_VERSION 0.6.0

COPY entrypoint.sh /entrypoint.sh
COPY openttd.cfg /default_config.cfg
CMD [ "/entrypoint.sh" ]