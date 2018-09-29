FROM resin/rpi-raspbian:latest
MAINTAINER Tonny Gieselaar<tgiesela@hccnet.nl>

ENV _aptclean="apt-get clean && rm -rf /var/lib/apt/lists/*"
ENV _repocomponent="release/4.2"

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
    libpcre3-dev \
    nano \
    net-tools \
    openssh-server \
    supervisor \
    wget \
    zlib1g-dev \
 && eval $_aptclean 

RUN apt-get update && apt-get install -y cmake libdvbcsa-dev
WORKDIR /home

RUN apt-get -y install libvpx-dev
RUN git clone https://github.com/tvheadend/tvheadend.git \
 && cd tvheadend 
# && git checkout $_repocomponent \
#RUN ./configure "--disable-libvpx --disable-bintray_cache" \
RUN cd /home/tvheadend \
 && ./configure "--disable-ffmpeg_static --enable-ccdebug" \
 && make \
 && make install

# For x86_64 processor remove the disabled opts from './configure' above

# Install xmltv & tvheadend 
RUN apt-get update \
 && apt-get install -y apt-transport-https \
 && apt-get install -y xmltv \
 && rm -rf /home/hts \
 && eval $_aptclean

# configs
ADD config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD scripts/init.sh /init.sh
ADD config/Astra-19.2E /usr/local/share/tvheadend/data/dvb-scan/dvb-s/
RUN chmod +x /init.sh

EXPOSE 9981 9982
VOLUME /config /recordings
ENTRYPOINT ["/init.sh"]
CMD ["app:start"]
