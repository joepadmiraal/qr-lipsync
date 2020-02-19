FROM debian:buster

ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ARG BUILD_PACKAGES="autoconf automake build-essential libtool pkg-config libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libqrencode-dev"

RUN apt-get update && apt-get -qy install --no-install-recommends make ca-certificates git \
    gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly \
    gstreamer1.0-libav libqrencode4 libzbar0 ffmpeg python3 python3-gi python-gst-1.0 python3-pip python3-setuptools && \
    pip3 install -U pip && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get -qy install --no-install-recommends ${BUILD_PACKAGES} && \
    git clone https://github.com/UbiCastTeam/gst-qroverlay.git && \
    cd gst-qroverlay/ && ./autogen.sh && ./configure && make install && cd ../ && rm -rf gst-qroverlay && \
    apt-get -qy remove --autoremove --purge ${BUILD_PACKAGES} && apt-get -q clean && rm -rf /var/lib/apt/lists/*

COPY . /usr/src
WORKDIR /usr/src
RUN pip install --editable ".[testing]"
