FROM nforceroh/d_alpine-s6:edge

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.name="d_alpine-radarr" \
  org.label-schema.description="Radarr docker container on alpine linux" \
  org.label-schema.url="https://github.com/nforceroh/d_alpine-radarr" \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url="https://github.com/nforceroh/d_alpine-radarr" \
  org.label-schema.vendor="nforceroh" \
  org.label-schema.version=$VERSION \
  org.label-schema.schema-version="1.0"

ENV \ 
    PYTHONIOENCODING=UTF-8 \
    LC_ALL=en_US.UTF-8  \
    LANG=en_US.UTF-8  \
    LANGUAGE=en_US.UTF-8  \
    PUID=3000 \
	PGID=1000 \
	ENABLE_NFS=false 

RUN \
    apk update \
    && apk upgrade \
    && apk add --no-cache curl  mediainfo sqlite3 --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    && echo "**** install app ****" \
    && mkdir /app \
    && wget --content-disposition 'http://radarr.servarr.com/v1/update/master/updatefile?os=linux&runtime=netcore&arch=x64' -O /tmp/radarr.tar.gz \
    && tar vxzf /tmp/radarr.tar.gz -C /app --strip-components=1 \
    && rm /tmp/radarr.tar.gz \
    && rm -rf /var/cache/apk/*

COPY rootfs /
# ports and volumes
EXPOSE 7878
WORKDIR /app
VOLUME /config
ENTRYPOINT [ "/bin/bash" ]
#ENTRYPOINT [ "/init" ]