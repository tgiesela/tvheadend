FROM debian:latest AS oscambase
ENV _aptclean="apt-get clean && rm -rf /var/lib/apt/lists/*"

#Smartcard reader
RUN apt-get update \ 
 && apt-get install -y --no-install-recommends \
    pcscd \
    pcsc-tools \
 && eval $_aptclean

#Relocate timezone file and create folders
RUN mkdir -p /config/.etc \
 && mkdir -p /var/run/sshd \
 && mv /etc/timezone /config/.etc/ \
 && ln -s /config/.etc/timezone /etc/

#=============================================================================
FROM oscambase AS oscambuilder

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y \
   libpcsclite-dev \
   apt-utils \
   build-essential \
   dnsutils \
   tcpdump \
   git \
   iputils-ping \
   pkg-config \
   nano \
   net-tools \
   wget \
   cmake \
 && eval $_aptclean 

WORKDIR /home
#OSCAM
#RUN git clone https://github.com/gfto/oscam /tmp/oscam-git 
RUN git clone https://git.streamboard.tv/common/oscam /tmp/oscam-git
#RUN cd /tmp/oscam-git && sed -i '/#include <sys\/utsname.h>/a #include <sys\/sysmacros.h>' globals.h
RUN cd /tmp/oscam-git && make pcsc OSCAM_BIN=Distribution/oscam_bin

#=============================================================================
FROM oscambase AS oscamruntime

RUN mkdir /var/bin mkdir /var/log/oscam 
COPY --from=oscambuilder /tmp/oscam-git/Distribution/oscam_bin /var/bin/oscam
ADD config/ /etc/oscam/

EXPOSE 9000 8888
VOLUME /config 
#ENTRYPOINT ["/init.sh"]
CMD ["/var/bin/oscam","-c","/etc/oscam/"]
