FROM debian:latest AS tvheadendbase
ENV _aptclean="apt-get clean && rm -rf /var/lib/apt/lists/*"

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends \
        libdvbcsa1 \
        libssl3 \
        iproute2 \
 && eval $_aptclean 

FROM tvheadendbase AS tvheadendbuilder

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y \
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
 && ./configure \
 && make \
 && make install

FROM tvheadendbase AS tvheadendruntime

COPY --from=tvheadendbuilder /usr/local/bin/ /usr/local/bin/
COPY --from=tvheadendbuilder /usr/local/share/tvheadend/ /usr/local/share/tvheadend/

EXPOSE 9981 9982
CMD ["tvheadend", "-C", "-u", "hts", "-g", "video", "-c", "/config","--satip_bindaddr","10.56.57.145"]
