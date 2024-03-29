#FROM resin/rpi-raspbian:latest
FROM debian:latest
MAINTAINER Tonny Gieselaar<tgiesela@hccnet.nl>

ENV _aptclean="apt-get clean && rm -rf /var/lib/apt/lists/*"

# Setup ssh and install supervisord
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y \
    apt-utils \
    build-essential \
    dnsutils \
    tcpdump \
    git \
    iputils-ping \
    pkg-config \
    nano \
    net-tools \
    supervisor \
    wget \
 && eval $_aptclean 

RUN apt-get update && apt-get install -y cmake 
WORKDIR /home

#Relocate timezone file and create folders
RUN mkdir -p /config/.etc \
 && mkdir -p /var/run/sshd \
 && mkdir -p /var/log/supervisor \
 && mv /etc/timezone /config/.etc/ \
 && ln -s /config/.etc/timezone /etc/

#Smartcard reader
RUN apt-get update \ 
 && apt-get install -y libpcsclite-dev \
    pcscd \
    pcsc-tools \
 && eval $_aptclean

#OSCAM
RUN git clone https://github.com/gfto/oscam /tmp/oscam-git 
RUN cd /tmp/oscam-git && sed -i '/#include <sys\/utsname.h>/a #include <sys\/sysmacros.h>' globals.h
RUN cd /tmp/oscam-git && make pcsc
RUN mkdir /var/bin mkdir /var/log/oscam 
RUN cp /tmp/oscam-git/Distribution/oscam-1.20-unstable_svn0-arm-linux-gnueabihf-pcsc /var/bin/oscam

# for x86-64 processor, change last line to:
#RUN cp /tmp/oscam-git/Distribution/oscam-1.20-unstable_svn0-x86_64-linux-gnu-pcsc /var/bin/oscam

# configs
ADD config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD scripts/init.sh /init.sh
ADD config/ /etc/oscam/
RUN chmod +x /init.sh

EXPOSE 9000 8888
VOLUME /config 
ENTRYPOINT ["/init.sh"]
CMD ["app:start"]
