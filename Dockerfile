FROM nforceroh/d_alpine-s6:dev

LABEL maintainer="sylvain@nforcer.com"

ENV \ 
    PYTHONIOENCODING=UTF-8 \
    LC_ALL=en_US.UTF-8  \
    LANG=en_US.UTF-8  \
    LANGUAGE=en_US.UTF-8  \
    PUID=3000 \
	PGID=1000 \
	ENABLE_NFS=false 

RUN \
    apk add --no-cache mono \
    && echo "**** install app ****" \
    && mkdir /app \
    && radarr_tag=$(curl -sX GET "https://api.github.com/repos/Radarr/Radarr/releases" | awk '/tag_name/{print $4;exit}' FS='[""]') \
    && wget "https://github.com/Radarr/Radarr/releases/download/${radarr_tag}/Radarr.develop.${radarr_tag#v}.linux.tar.gz" -O /tmp/radarr.tar.gz \
    && tar vxzf /tmp/radarr.tar.gz -C /app --strip-components=1 \
    && rm /tmp/radarr.tar.gz \
    && rm -rf /var/cache/apk/*

COPY rootfs /
# ports and volumes
EXPOSE 7878
WORKDIR /app
VOLUME /config
ENTRYPOINT [ "/init" ]