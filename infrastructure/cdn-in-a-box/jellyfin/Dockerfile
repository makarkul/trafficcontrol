FROM jellyfin/jellyfin:latest

RUN DEBIAN_FRONTEND=noninteractive apt update \
    && DEBIAN_FRONTEND=noninteractive apt install -y \
    net-tools \
    lighttpd \
    bash \
    curl \
    bind9-libs \
    gettext \
    jq \
    iproute2 \
    iputils-ping \
    traceroute \
    libpcap-dev \
    tcpdump \
    vim \
    dnsutils
    
ADD jellyfin/run.sh \
    traffic_ops/to-access.sh \
    enroller/server_template.json \
    /

COPY dns/set-dns.sh \
     dns/insert-self-into-dns.sh \
     dns/insert-any-into-dns.sh \
     /usr/local/sbin/

EXPOSE 8096 8920 9300
