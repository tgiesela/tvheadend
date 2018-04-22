FROM ubuntu:16.04
MAINTAINER Tonny Gieselaar<tgiesela@hccnet.nl>

ENV tvh_release=stable
ENV _aptclean="apt-get clean && rm -rf /var/lib/apt/lists/*"
ENV _repocomponent="stable-4.2"
ENV _distro="xenial"

# Setup ssh and install supervisord
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y \
    apt-utils \
    build-essential \
    bzip2 \
    dirmngr \
    dnsutils \
    tcpdump \
    gettext \
    git \
    iputils-ping \
    pkg-config \
    libavahi-client-dev \
    libavcodec-dev \
    libavformat-dev \
    libavresample-dev \
    libavutil-dev \
    libssl-dev \
    libswscale-dev \
    nano \
    net-tools \
    openssh-server \
    supervisor \
    wget \
    zlib1g-dev \
 && eval $_aptclean 

RUN apt-get update && apt-get install -y cmake libdvbcsa-dev
WORKDIR /home
RUN git clone https://github.com/tvheadend/tvheadend.git \
 && cd tvheadend \
 && ./configure \
 && make \
 && make install

# Install xmltv & tvheadend 
RUN apt-get update \
 && apt-get install -y apt-transport-https \
 && apt-get install -y xmltv \
 && rm -rf /home/hts \
 && eval $_aptclean

#Relocate timezone file and create folders
RUN mkdir -p /config/.etc \
 && mkdir -p /var/run/sshd \
 && mkdir -p /var/log/supervisor \
 && mv /etc/timezone /config/.etc/ \
 && ln -s /config/.etc/timezone /etc/

# configs
ADD config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD scripts/init.sh /init.sh
ADD config/Astra-19.2E /usr/local/share/tvheadend/data/dvb-scan/dvb-s/
RUN chmod +x /init.sh

EXPOSE 9981 9982
VOLUME /config /recordings
ENTRYPOINT ["/init.sh"]
CMD ["app:start"]
