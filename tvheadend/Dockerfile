FROM debian:latest AS tvheadendbase
ENV _aptclean="apt-get clean && rm -rf /var/lib/apt/lists/*"

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends \
        libdvbcsa1 \
	libavahi-common3 \
	libavahi-client3 \
        libssl3 \
        iproute2 \
        liburiparser1 \
 && eval $_aptclean 

FROM tvheadendbase AS tvheadendbuilder

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y \
        debhelper \
        libavahi-client-dev \
        zlib1g-dev \
        liburiparser-dev \
        python3-requests \
        libpcre2-dev \
        apt-utils \
        pkg-config \
        git \
        gettext \
        build-essential \
        python3 \
        libssl-dev \
        libdvbcsa-dev \
        cmake \
        wget \
        python-is-python3 \
 && eval $_aptclean 

WORKDIR /git
RUN git clone https://github.com/tvheadend/tvheadend.git \
 && cd tvheadend \
 && AUTOBUILD_CONFIGURE_EXTRA="--enable-libffmpeg_static --enable-trace --enable-debug" ./Autobuild.sh \
 && make 

RUN cd tvheadend && make install

FROM tvheadendbase AS tvheadendruntime

COPY --from=tvheadendbuilder /usr/bin/ /usr/bin/
COPY --from=tvheadendbuilder /usr/share/tvheadend/ /usr/share/tvheadend/

EXPOSE 9981 9982
#CMD ["tvheadend", "-C", "-u", "hts", "-g", "video", "-c", "/config","--satip_bindaddr","10.56.57.145"]
CMD ["tvheadend", "-C", "-c", "/config"]
