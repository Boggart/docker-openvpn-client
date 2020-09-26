FROM alpine:latest

LABEL maintainer="yacht7@protonmail.com"

ENV KILL_SWITCH=on\
    VPN_LOG_LEVEL=3 \
    PIA_user=none \
    PIA_pass=none
    

RUN \
    echo '@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories && \
    apk add --no-cache \
        bind-tools \
        openvpn \
        shadowsocks-libev@testing \
        tinyproxy \
        jq \
        curl && \
        chmod +x -R /data/scripts

RUN \
    mkdir -p /data/vpn && \
    addgroup -S shadowsocks && \
    adduser -S -G shadowsocks -g "shadowsocks user" -H -h /dev/null shadowsocks

COPY data/ /data

HEALTHCHECK CMD ping -c 3 1.1.1.1 || exit 1

ENTRYPOINT ["/data/scripts/entry.sh"]
